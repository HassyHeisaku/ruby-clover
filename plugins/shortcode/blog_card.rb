# -*- coding: utf-8 -*-
require "rubygems"
require "bundler/setup"
require 'nokogiri'
require 'open-uri'
require 'shortcode_plugin'
require 'pp'

class BlogCard < ShortcodePlugin
  def process(parameters,content)
    url = parameters.split(' ')[1]
    charset = ""
    r = open(url) do |f| 
      charset = f.charset
      f.read 
    end 
    soup = Nokogiri::HTML.parse(r,nil,charset)
    meta_list = {
      %q%//meta[@name="description"]/@content% => :description,
      %q%//meta[@name="keywords"]/@content% => :keywords,
      %q%//meta[@name="twitter:card"]/@content% => :tw_card,
      %q%//meta[@name="twitter:site"]/@content% => :tw_site,
      %q%//meta[@property="og:url"]/@content% => :url,
      %q%//meta[@property="og:site"]/@content% => :site,
      %q%//meta[@property="og:title"]/@content% => :title,
      %q%//meta[@property="og:description"]/@content% => :description,
      %q%//meta[@property="og:image"]/@content% => :image,
      %q%//meta[@property="twitter:image" ]/@content% =>:image
    }
    result = {}
    meta_list.each do |k,v|
      if(!soup.xpath(k).empty?) 
        result[v] ||= soup.xpath(k).inner_text
      end
    end
    html_template = <<-"EOS"
  <div class="heisakuCard">
  <img alt="#{result[:title]}" src="#{result[:image]}" style="float:left;" />
  <div class="heisakuCard_content">
   <span class="heisakuCard_title">#{result[:title]}</span><br />
   <span class="heisakuCard_desc">#{result[:description]}</span>
  </div>
  <a href="#{result[:url]}" target="_blank"></a>
  </div>
    EOS
    return html_template
  end

end

