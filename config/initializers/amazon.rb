Amazon::Ecs.configure do |options|
  options[:associate_tag] = ENV['ASSOCIATE_TAG']
  options[:AWS_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
  options[:AWS_secret_key] = ENV['AWS_SECRET_KEY']

end
