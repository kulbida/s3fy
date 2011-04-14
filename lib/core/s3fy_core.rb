class S3fyCore < AWS::S3::S3Object
  set_current_bucket_to "#{AWS_CONFIG[:bucket]}"
end