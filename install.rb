require 'fileutils'
puts 'Copying configuration file.'
FileUtils.copy(File.dirname(__FILE__)+'/config/s3fy.yml', "#{RAILS_ROOT}/config/s3fy.yml")
puts 'Removing default configuration file.'
FileUtils.remove(File.dirname(__FILE__)+'/config/s3fy.yml')
Dir.remove(File.dirname(__FILE__)+'/config')
puts 'Plugin has been installed'