# -*- coding: utf-8 -*-
require 'erb'
require 'template_plugin'
require 'pp'

class SitemapFile < TemplatePlugin
  def initialize
    super('sitemap/sitemap.erb')
  end
  def process
    @changelog = @@changelog.dup
    content = nil
    for_render = []
    @changelog.contents.each do |c|
      for_render << {:permlink => c[:permlink], :date => c[:date].strftime("%Y-%m-%dT%H:%M:%S%:z")}
    end
    File.open(@changelog.config[:output_dir] + "sitemap.xml" , 'w', :encoding => 'utf-8') do |f|
      f.puts @erb.result(binding)
    end
    puts "processed! sitemap.xml"
  end
end
