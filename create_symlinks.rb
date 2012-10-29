#!/usr/bin/env ruby

require 'fileutils'

include FileUtils

HOME = ENV['HOME']

dot_files_path = %Q_#{HOME}/.dotfiles_

dot_files = Dir["#{dot_files_path}/*"]

# All (non hidden) files contained in $HOME/.dotfiles will be symlinked to $HOME/
dot_files.each do |dot_file|

  #don't symlink the script itself
  unless dot_file =~ /#{__FILE__}/ or dot_file =~ /README.md/
    dot_file_basename = File.basename(dot_file)
    dot_file_dest = "#{HOME}/.#{dot_file_basename}"

    if File.exist?(dot_file_dest)
      if File.symlink?(dot_file_dest)
        print "\033[1;31mSkipping: \033[1;m"
        puts "\033[47;30m.#{dot_file_basename}\033[1;m"
      else
        puts "\n\033[1;31mStop! \033[1;m"
        print "\033[47;30m.#{dot_file_basename}\033[1;m is not a symlink! "
        puts "Remove or backup this file before running this scripts again"
        exit 1
      end
    else
      print "\033[1;32mCreating: \033[1;m"
      puts "\033[47;30m.#{dot_file_basename}\033[1;m"
      ln_s dot_file, dot_file_dest
    end
  end
end

puts