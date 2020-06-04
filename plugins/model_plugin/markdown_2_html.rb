# -*- coding: utf-8 -*-
Encoding.default_external = 'utf-8'
require "rubygems"
require "bundler/setup"
require 'kramdown'
require 'model_plugin'
require 'pp'

class Markdown2Html < ModelPlugin
  def process
    @@changelog.contents.each do |content| 
      content[:contents] = Kramdown::Document.new(content[:contents], input: 'GFM').to_html
      content[:notag] = content[:contents].gsub(/<[^>]+>/,"")
    end
  end
end
