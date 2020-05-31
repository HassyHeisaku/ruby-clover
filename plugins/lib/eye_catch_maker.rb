# -*- coding: utf-8 -*-
require "rubygems"
require "bundler/setup"
require "mini_magick"

class EyeCatchMaker
  def initialize(template_dir)
    @template_dir = template_dir
  end

  def make_blank()
    MiniMagick::Tool::Convert.new do | i |
      i.size   "1200x675"
      i.xc "white"
      i << @template_dir + "blank_template.jpg"
    end
  end
  def put_title(title,output,template="blank")
    if(File.exist?(@template_dir + template + '_template.jpg'))
      @img = MiniMagick::Image.open(@template_dir + template + '_template.jpg')
    else
      make_blank()
      @img = MiniMagick::Image.open(@template_dir + 'blank_template.jpg')
    end
    @img.combine_options do |i|
      i.font File.dirname(__FILE__) + "/freefont.ttc"
      i.gravity 'Center'
      i.pointsize 66 
      i.draw "text 0,0 '#{title}'"
      i.fill ("#525252")
    end
    @img.write(output)
  end
end
