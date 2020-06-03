# -*- coding: utf-8 -*-
require 'fileutils'
require 'pp'

class DirConstructor
  def initialize(changelog_conf)
    @config = changelog_conf
  end
  def remove_and_recreate_out_dir
    FileUtils.rm_r(Dir.glob(@config[:output_dir] + '*')) if(File.exists?(@config[:output_dir]))
    [:css,:javascript,:images].each do |type|
      FileUtils.mkdir_p(@config[:output_dir] + @config[:path_of][type])
    end
  end
  def cp_static_files(location)
    [:css,:javascript,:images].each do |type|
      FileUtils.cp_r(@config[:base_dir] + @config[location][:dir] + @config[:path_of][type], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[location][:dir] + @config[:path_of][type]))
    end
  end
end
