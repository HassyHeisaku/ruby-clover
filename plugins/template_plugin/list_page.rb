# -*- coding: utf-8 -*-
require 'erb'
require 'template_plugin'
require 'pp'

class ListPage < TemplatePlugin
  def initialize
    super('list_page/category_index.erb')
  end
  def process
    @changelog = @@changelog.dup
    @categbase_changelog = {}
    [nil, *@changelog.config[:categories].map {|c| c[:category_name]}].each do |category|
      @categbase_changelog[:category_filter] = category
      @categbase_changelog[:contents] = @changelog.get_contents_in_category(category)
      if(@categbase_changelog[:contents].length > 0)
        @categbase_changelog[:tag_map]="var tag_map =" + JSON.generate(@changelog.config[:tag_map][category])
        @categbase_changelog[:contents].sort_by!{|c| c[:id]}.reverse!

        File.open(@changelog.config[:output_dir] + @changelog.get_category_attr(category) + "index.html" , 'w', :encoding => 'utf-8') do |f|
          f.puts @erb.result(binding)
        end
        puts "processed! CategIndex: #{@categbase_changelog[:category_filter]}"
      end
    end
  end
end
