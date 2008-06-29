# Include hook code here
require 'bukkit_keeper/s3'
s3_config = "#{RAILS_ROOT}/config/s3_reporting.yaml"
s3_config = File.dirname(__FILE__) + "/config/s3_reporting_example.yaml" if Rails.env == "test"
if File.exists? s3_config
  s3_settings = YAML::load(IO.read( s3_config ))
  Bukkit::S3::EXPENSES = s3_settings['expenses'].symbolize_keys!
  Bukkit::S3::CHARGES  = s3_settings['charges'].symbolize_keys!
  Bukkit::S3::USAGE_TYPES = s3_settings['usage_types'].symbolize_keys!
  Bukkit::S3::UNITS = s3_settings['units'].symbolize_keys!
  Bukkit::S3::REQUEST_METHODS = s3_settings['request_methods'].symbolize_keys!


end

