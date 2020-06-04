# -*- coding: utf-8 -*-
require 'pp'
require "rubygems"
require "bundler/setup"
require 'nokogiri'
require 'open-uri'


def get_og(url)
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
<style type="text/css">
<!--
 .heisakuCard {height:180px;width:auto;max-width:800px;border: solid 1px #aaa;padding: 5px;box-sizing:content-box;position: relative;}
 .heisakuCard a {position: absolute;top: 0;left: 0;width: 100%;height: 100%;}
 .heisakuCard:hover { opacity: 0.8; }
 .heisakuCard_content {position:absolute; top:5px;left:340px;box-sizing:border-box;width: calc(100% - 350px);}
 .heisakuCard_title {color: #555; font-weight: bold;font-size: 16px;margin-bottom:10px;}
 .heisakuCard_desc {color: #333;font-size: 16px;}
 .heisakuCard img { position: absolute; top: 5px; left: 5px; width: 320px;height:180px; }
 -->
 </style>
 <style media="only screen and (max-device-width:480px)" type="text/css">
 <!--
 .heisakuCard {height:390px;width:320px;border: solid 1px #aaa;padding: 5px;box-sizing:content-box;position: relative;}
 .heisakuCard_desc {font-size: 14px;}
 .heisakuCard_content {position:absolute; top:190px;left:5px;box-sizing:border-box;width: 320px;}
-->
</style>
<div class="heisakuCard">
<img alt="#{result[:title]}" height="90" width="180" src="#{result[:image]}" style="float:left;" />
<div class="heisakuCard_content">
 <span class="heisakuCard_title">#{result[:title]}</span><br />
 <span class="heisakuCard_desc">#{result[:description]}</span>
</div>
<a href="#{result[:url]}" target="_blank"></a>
</div>
  EOS
  return html_template
end

puts(get_og(ARGV[0]))

