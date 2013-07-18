require File.dirname(__FILE__) + '/gclient.rb'

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

    def getSpreadsheet(key)
      @app.getFeed "https://spreadsheets.google.com/ccc?key=#{key}"
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






