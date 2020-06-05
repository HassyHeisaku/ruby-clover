# -*- coding: utf-8 -*-
require 'model_plugin'
require 'pp'

class ToC < ModelPlugin
  def process
    @@changelog.contents.each do |content| 
      toc = ""
      content_after = ""
      count = 0
      content[:contents].each_line do |l|
        l.chomp!
        if((all,hx_title = /\#{1,3} +(.*?) *$/.match(l).to_a)[0] != nil)
          content_after += l + " {#a#{count}}\n"
          toc += "- [#{hx_title}](#a#{count})\n"
          count +=1
        else
          content_after += l + "\n"
        end
      end
      content_after.gsub!('%TOC%',toc)  #if no '%TOC%', ToC will no be inserted
      content[:contents] = content_after
    end
  end
end
