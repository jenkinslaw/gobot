require 'google/api_client'
require 'xmlsimple'

module Jenkins

  class GoogleApp
    attr_reader :client

    def initialize
      @client = self.getClient
    end

    def getClient
      # Change client key path if different.
      key = Google::APIClient::KeyUtils.
        load_from_pem(ENV['HOME'] + '/.ssh/gworksheet.pem', 'notasecret')

      client = Google::APIClient.new(
        :application_name => 'Jenkins Google App',
        :application_version => '0.1'
      )
      client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => "https://accounts.google.com/o/oauth2/token",
        :audience => "https://accounts.google.com/o/oauth2/token",
        :scope => [
          "https://spreadsheets.google.com/feeds",
          "https://www.googleapis.com/auth/calendar",
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

    def execute command
      result = @client.execute command
      self.processGoogleResult result
    end

    def processGoogleResult result
      if result.status == 200
        return JSON.parse(result.body)
      end
      result
    end
  end

end








