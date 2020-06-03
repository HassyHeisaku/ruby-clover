# -*- coding: utf-8 -*-
require 'pp'
require 'yaml'
require 'erb'
require 'time'

include ERB::Util

class ChangelogModel
  @@base_dir = File.expand_path('.') + '/'
  attr_accessor :config, :contents
  def initialize(conf_filename = nil)
    return if(conf_filename.nil?)
    read_config(conf_filename)
    Dir.glob(@config[:contents_dir]).each do |f|
	    parse_cl(f)
    end
    fill_permlink_outputname
    map_tags_contents
    @contents.sort_by! { |c| c[:id]}
  end
  def read_config(fileName)
    conf = File.read(fileName, :encoding => 'utf-8')
    @config = YAML.load(conf)
    @config[:base_dir] = @@base_dir
    @config[:output_dir] = @@base_dir + @config[:output_dir] 
    @config[:contents_dir] = @@base_dir + @config[:contents_dir] 
    @config[:images_dir] = @@base_dir + @config[:static][:dir] + @config[:path_of][:images] 
    @config[:model_plugin_dir] = @@base_dir + 'plugins/model_plugin/'
    @config[:shortcode_plugin_dir] = @@base_dir + 'plugins/shortcode/'
    @config[:template_plugin_dir] = @@base_dir + 'plugins/template_plugin/'
    @config[:plugin_lib_dir] = @@base_dir + 'plugins/lib/'
  end
  def parse_cl(fileName)
    buf = File.readlines(fileName, :encoding => 'utf-8')
    @contents ||= []
    oneday_string = []
    contents_date = Time.now()
    author = "hoge"
    buf.each do |line|
      line = line[/^\t?([^\r\n]*)/,1]
      if((all,date_line, author_line = /^(\d{4}-\d{2}-\d{2}) *([^ ]+)?/.match(line).to_a)[0] != nil)
        if(!oneday_string.empty?)
          one_day = parse_oneday_string(oneday_string,fileName,contents_date,author) unless(oneday_string.empty?)
          @contents.concat(one_day)
        end
        contents_date = Time.parse(date_line[/^\d{4}-\d{2}-\d{2}/,0])
        author = author_line
        oneday_string = []
      else
        oneday_string << line
      end
    end
    one_day = parse_oneday_string(oneday_string,fileName,contents_date,author) unless(oneday_string.empty?)
    @contents.concat(one_day)
  end
  def get_category(fileName)
    return '' unless(fileName)
    category_name = @config[:categories].find {|v| v[:file_name] == fileName}[:category_name] 
    category_name
  end
  def get_category_attr(categ_name, attr = :dirname)
    result = @config[:categories].find {|v| v[:category_name] == categ_name}[attr]
    result
  end
  def get_contents_in_category(categ_name)
    if(categ_name == nil)
      @contents
    else
      @contents.map {|c| c if(c[:category] == categ_name)}.compact
    end
  end
  def get_contents_id_in_a_tag(tag, category = nil)
    contents = (category.nil?)? @contents : get_contents_in_category(category) 
    contents.map {|c| c[:id] if(c[:tags].is_a?(Array) && c[:tags].include?(tag))}.compact
  end
  def each_static_file_url(file_type)
    location = [:static, :theme, :custom_theme]
    location.each do |l|
      Dir.glob(@config[l][:dir] + @config[:path_of][file_type] + '*.css').each do |f|
        yield @config[:home_url] +  @config[:path_of][file_type] + File.basename(f) # if block_given?
      end
    end
  end
  private
  def parse_oneday_string(oneday_string,fileName,contents_date,author)
    return_value = []
    one_content = []
    oneday_string.each do |line|
      if(line =~/^\*.+:/ )
        return_value.concat(parse_header(one_content)) if(!one_content.empty?)
        one_content = []
        one_content << line
      else
        one_content << line
      end
    end
    return_value.concat(parse_header(one_content)) 
    return_value.compact!
    catfile = fileName[/([^\/]+)\.chg$/,1]
    cat = get_category(catfile)
    num_content = return_value.length
    return_value.each do |c| 
      c[:date] = contents_date 
      c[:author] = author
      c[:category] = cat
      c[:catfile] = catfile
      c[:id] = c[:date].strftime("%Y-%0m-%0d") + '-' + c[:catfile] + '-' + num_content.to_s
      num_content = num_content - 1
    end
    return_value
  end
  def parse_header(one_content)
    return_value = []
    return_value_tmp = {}
    header = one_content.shift
    return [] if(/^\*p/.match(header))
    _,return_value_tmp[:title],tags,contents = /\*[ ]*([^\[]*?)[ ]*(\[.*\])?:(.*)/.match(header).to_a
    return [] if(return_value_tmp[:title].nil?)
    return_value_tmp[:title] =return_value_tmp[:title].split('%').join("\n")
    return_value_tmp.merge!(parse_tags(tags))
    return_value_tmp.merge!({:contents => contents + "\n" + one_content.join("\n")})
    return_value.push(return_value_tmp.dup)
    return_value
  end
  def parse_tags(tag_string)
    tags = tag_string.split(/[\[\]]/).select{|v| v!=""}
    return_value = {}
    tags.each do |v|
      tmp = v.split(/%/)
      (1..tmp.length-1).each {|i| (tmp[1].is_a?(Array))? tmp[1] << tmp[i] : tmp[1] = [tmp[i]] } if(tmp[0] == 'keywords' || tmp[0] == 'tags') 
      if(return_value.has_key?(:"#{tmp[0]}"))
        return_value[:"#{tmp[0]}"].push(tmp[1])
      else
        return_value[:"#{tmp[0]}"] = tmp[1]
        if(tmp[0] == 'tags')
          @config[:tags] = (@config[:tags].is_a?(Array))? @config[:tags] | tmp[1] : tmp[1]
        end
      end
    end
    return_value
  end
  def fill_permlink_outputname
    @contents.each do |c|
      c[:permlink] = @config[:home_url] + get_category_attr(c[:category]) + c[:filename] + '/'
      c[:output_name] = @config[:output_dir] + get_category_attr(c[:category]) + c[:filename] + '/index.html'
    end
  end
  def map_tags_contents
    @config[:tag_map] = {}
    @config[:categories].each do |c|
      @config[:tag_map][c[:category_name]]={}
      @config[:tags].each do |t|
        @config[:tag_map][c[:category_name]][t] = get_contents_id_in_a_tag(t)
      end
    end
  end
end
