# -*- coding: utf-8 -*-
require 'fileutils'
require 'pp'

class DirConstructor
  def initialize(changelog_conf)
    @config = changelog_conf
  end
  def remove_and_recreate_out_dir
    FileUtils.rm_r(Dir.glob(@config[:output_dir] + '*')) if(File.exists?(@config[:output_dir]))
    FileUtils.mkdir_p(@config[:output_dir] + 'css')
    FileUtils.mkdir_p(@config[:output_dir] + 'javascript')
    FileUtils.mkdir_p(@config[:output_dir] + 'images')
  end
  def cp_theme_static_files
    FileUtils.cp_r(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:css_path], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:css_path]))
    FileUtils.cp_r(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:javascript_path], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:javascript_path]))
    FileUtils.cp_r(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:images_path], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:theme][:dir] + @config[:theme][:images_path]))
  end
  def cp_custom_static_files
    FileUtils.cp_r(@config[:base_dir] + @config[:custom_theme][:dir] + @config[:theme][:css_path], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:custom_theme][:dir] + @config[:theme][:css_path]))
    FileUtils.cp_r(@config[:base_dir] + @config[:custom_theme][:dir] + @config[:theme][:javascript_path], @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:custom_theme][:dir] + @config[:theme][:javascript_path]))
  end
  def cp_static_files
    FileUtils.cp_r(Dir.glob(@config[:base_dir] + @config[:static][:dir] +'*'), @config[:output_dir]) if(File.exists?(@config[:base_dir] + @config[:static][:dir]))
  end
end
