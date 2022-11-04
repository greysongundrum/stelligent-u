require "aws-sdk-kms"  # v2: require 'aws-sdk'
require 'aws-sdk-s3'

# ARN of the AWS KMS key.
#
# Replace the fictitious key ARN with a valid key ID

sdk_creds = Aws::SharedCredentials.new(path: '/Users/greyson.gundrum/.aws/sdk_credentials')
Aws.config.update(credentials:sdk_creds)

keyId = "0ba55975-4335-47ce-9afa-17e812faf1a6"
bucketname = 'greysongundrumgeneralsubucket'
text = "1234567890"
objectbucketkey = 'supersecret.txt'
response_target = './IHAVEBEENDOWNLOADED'

s3_encryption_client = Aws::S3::EncryptionV2::Client.new(
    region: 'us-west-2',
    kms_key_id: keyId,
    key_wrap_schema: :kms_context,
    content_encryption_schema: :aes_gcm_no_padding,
    security_profile: :'v2'
   )

   s3_encryption_client.put_object(
    bucket: bucketname,
    key: objectbucketkey,
    body: 'Woah I am super duper secret'
  )

  response = s3_encryption_client.get_object(
    response_target: response_target,
    bucket: bucketname,
    key: objectbucketkey
  )

  s3_client = Aws::S3::Client.new(
    region: 'us-west-2'
)

  encrypted_data_cipher = s3_client.get_object(
    bucket: bucketname,
    key: objectbucketkey
  )

  puts "This is the contents of the file after it has been decrypted" + "\n" + response.body.read + " We have written this file locally to" + " #{response_target}"
  puts "This is the encrypted data cipher" + "\n" + encrypted_data_cipher.body.read
  File.open("log.txt", "w") { |f| f.write "WHO KNOWS" }