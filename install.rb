require 'fileutils'
puts 'Copying configuration file.'
FileUtils.copy(File.dirname(__FILE__)+'/config/s3fy.yml', "#{RAILS_ROOT}/config/s3fy.yml")