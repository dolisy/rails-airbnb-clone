ASIN::Configuration.configure do |config|
  config.secret        = ENV['AWS_SECRET_KEY']
  config.key           = ENV['AWS_ACCESS_KEY_ID']
  config.associate_tag = ENV['ASSOCIATE_TAG']
end
