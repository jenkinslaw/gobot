require 'google/api_client'

# Change client key path if different.
key = Google::APIClient::KeyUtils.
  load_from_pkcs12(ENV['HOME'] + '/.ssh/gworksheet.p12', 'notasecret')

client = Google::APIClient.new(
  :application_name => 'Jenkins Google Worksheet',
  :application_version => '0.1'
)
client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => "https://accounts.google.com/o/oauth2/token",
  :audience => "https://accounts.google.com/o/oauth2/token",
  :scope => ["https://www.googleapis.com/auth/drive", "https://www.googleapis.com/auth/calendar"],
  :issuer => ENV['GOOGLE_EMAIL'],
  :signing_key => key
)
client.authorization.fetch_access_token!


drive = client.discovered_api('drive', 'v2')
calendar = client.discovered_api('calendar', 'v3')

result = client.execute(:api_method => drive.files.get,
                     :parameters => { 'fileId' => ENV['GOOGLE_WORKSHEET_ID']}
                     )

if (result.status == 200)
  file = result.data
  puts "Title: #{file.title}"
  puts "Description: #{file.description}"
  puts "MIME type: #{file.mime_type}"
end
