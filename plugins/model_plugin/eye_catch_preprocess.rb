# -*- coding: utf-8 -*-
require 'model_plugin'
require 'eye_catch_maker'
require 'pp'

class EyeCatchPreprocess < ModelPlugin
  def process
    ecm = EyeCatchMaker.new(@@changelog.config[:base_dir] + @@changelog.config[:custom_theme][:dir] + @@changelog.config[:custom_theme][:eyecatch_template_path])
    @@changelog.contents.each do |content| 
      content[:eyecatch] = "title_#{content[:filename]}.jpg"
      unless(File.exist?(@@changelog.config[:images_dir] + content[:eyecatch]))
        ecm.put_title(content[:title],@@changelog.config[:images_dir] + content[:eyecatch], (content[:eye])? content[:eye]:"blank")
      end
    end
  end
end
