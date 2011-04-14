require 'fileutils'
puts 'Removing configuration file.'
FileUtils.remove("#{RAILS_ROOT}/config/s3fy.yml")
puts 'Plugin has been uninstalled.'