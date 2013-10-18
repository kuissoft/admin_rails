class SignedUploadService
  def encode(name, mime_type)
    config = RockConfig.for("s3")

    expires = Time.now.to_i + 100
    index = name.rindex('.')
    extension = name[index, name.length] unless index.nil?

    id = "???"

    amz_headers = "x-amz-acl:public-read" # check for an example
    stringtosign = "PUT\n\n#{mime_type}\n#{expires}\n#{amz_headers}\n/#{config.bucket}/#{id}#{extension}";
    signature = CGI::escape(Base64.strict_encode64(OpenSSL::HMAC.digest("sha1", config.secret, stringtosign)))

    CGI::escape("https://#{config.bucket}.s3.amazonaws.com/#{resource.id}#{resource.extension}?AWSAccessKeyId=#{config.key}&Expires=#{expires}&Signature=#{signature}")
  end
end
