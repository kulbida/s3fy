require 'open-uri'
require 'aws/s3'
AWS_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/s3fy.yml")[RAILS_ENV].symbolize_keys
require 'acts_as_s3fy'
require 'core/s3fy_core'