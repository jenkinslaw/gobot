require 'google/api_client'
require 'xmlsimple'
require 'pp'
require 'yaml'

module Jenkins

  class GoogleApp

    def self::getClient
      # Change client key path if different.
      key = Google::APIClient::KeyUtils.
        load_from_pkcs12(ENV['HOME'] + '/.ssh/gworksheet.p12', 'notasecret')

      client = Google::APIClient.new(
        :application_name => 'Jenkins Google App',
        :application_version => '0.1'
      )
      client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => "https://accounts.google.com/o/oauth2/token",
        :audience => "https://accounts.google.com/o/oauth2/token",
        :scope => [
          "https://www.googleapis.com/auth/calendar",
          "https://spreadsheets.google.com/feeds",
        ],
        :issuer => ENV['GOOGLE_EMAIL'],
        :signing_key => key
      )
      client.authorization.fetch_access_token!
      client
    end
  end

  Client = GoogleApp::getClient()

end



def getFeed (uri)
  result = Jenkins::Client.execute(:uri => uri)
  XmlSimple.xml_in(result.body, 'KeyAttr' => 'name')
end

  
drive = Jenkins::Client.discovered_api('drive', 'v2')
calendar = Jenkins::Client.discovered_api('calendar', 'v3')

result = Jenkins::Client.execute(:api_method => drive.files.get,
                     :parameters => { 'fileId' => ENV['GOOGLE_WORKSHEET_ID']}
                     )
doc = getFeed('https://spreadsheets.google.com/feeds/spreadsheets/private/full')

# Getting spreadsheet key.
key = doc["entry"][0]["id"][0][/full\/(.*)/, 1]
puts key

# Getting 
list = getFeed("https://spreadsheets.google.com/feeds/worksheets/#{key}/private/full")
pp list







