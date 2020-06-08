# -*- coding: utf-8 -*-

require 'template_plugin'
require 'rss'
require 'rss_cdata'

class RssFile < TemplatePlugin
  def initialize
    super(nil)
  end
  def process
    @changelog = @@changelog.dup
    rss = RSS::Maker.make("1.0") do | maker |
      maker.channel.about = @changelog.config[:home_url] + @changelog.config[:rss_filename]
      maker.channel.title = @changelog.config[:title]
      maker.channel.link = @changelog.config[:home_url] 
      maker.channel.description = @changelog.config[:title] + '-' + @changelog.config[:subtitle] 
      maker.channel.dc_date = Time.now

      maker.items.do_sort = true

      @changelog.contents.each do |c|
        content_image = '<img src="' + @@changelog.config[:home_url] + @@changelog.config[:path_of][:images] + content[:eyecatch] + '"/>'
        maker.items.new_item do |item|
          item.title = c[:title]
          item.link = c[:permlink]
          item.description = c[:title] + '-' + @changelog.config[:title]
          item.content_encoded = render_this(content_image + c[:contents], c)
          item.dc_date = c[:date]
        end
      end
    end
    File.open(@changelog.config[:output_dir] + @changelog.config[:rss_filename], 'w', :encoding => 'utf-8') do |f|
     f.puts rss.to_s
    end
  end
end
