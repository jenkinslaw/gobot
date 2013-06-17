require 'google/api_client'
require 'xmlsimple'
require 'pp'
require 'yaml'

module Jenkins

  class GoogleApp

    attr_reader :client

    def initialize
      @client = self.getClient
    end

    def getClient
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
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds",
        ],
        :issuer => ENV['GOOGLE_EMAIL'],
        :signing_key => key
      )
      client.authorization.fetch_access_token!
      client
    end

    def getFeed (uri)
      result = @client.execute(:uri => uri)
      if result.status == 200
        result = XmlSimple.xml_in(result.body, 'KeyAttr' => 'name')
        if  result.key? 'entry'
          return result['entry']
        end
        []
      end
    end

    def getSpreadsheet(key)
      getFeed "https://spreadsheets.google.com/ccc?key=#{key}"
    end

  end
end

module Jenkins

  class Spreadsheet
    attr_reader :list
    @@uri = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'

    def initialize
      app = Jenkins::GoogleApp.new
      @list = app.getFeed @@uri
    end

    def getIdByDocId doc_id
      spreadsheet = self.getSpreadsheetByDocId doc_id
      spreadsheet['id'].first.split('/').last
    end
    
    def getSpreadsheetByDocId doc_id
      @list.detect {|s| 
        link = s['link'].detect{|l| l['rel'] == 'alternate'}
        link['href'].include? doc_id
      } 
    end

  end


  class Worksheet

    attr_reader :list

    def initialize id
      app = Jenkins::GoogleApp.new
      @uri ="https://spreadsheets.google.com/feeds/worksheets/#{id}/private/full"  
      @list = app.getFeed @uri
    end
  end

end

app = Jenkins::GoogleApp.new
drive = app.client.discovered_api('drive', 'v2')
calendar = app.client.discovered_api('calendar', 'v3')

result = app.client.execute(:api_method => drive.files.get,
                     :parameters => { 'fileId' => ENV['GOOGLE_WORKSHEET_ID']}
                     )

#puts YAML::dump(result.data)
##doc = app.getFeed('https://spreadsheets.google.com/feeds/spreadsheets/private/full')
#doc = app.getSpreadsheet ENV['GOOGLE_WORKSHEET_ID']


# Getting spreadsheet key.
#key = doc["entry"][0]["id"][0][/full\/(.*)/, 1]
#puts key

# Getting 
#list = getFeed("https://spreadsheets.google.com/feeds/worksheets/#{key}/private/full")
#pp list['entry'].first







