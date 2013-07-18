require 'minitest/autorun'
require "./gworksheet"

class TestJenkinsClient < MiniTest::Unit::TestCase

  def setup
    @app = Jenkins::GoogleApp.new
  end

  def testClient
    assert_kind_of Google::APIClient, @app.client,
      "The Google client is initialized successfully"
  end

end

class TestSpreadsheet < MiniTest::Unit::TestCase
  def setup
    @spreadsheet = Jenkins::Spreadsheet.new
  end

  def testSpreadsheetList
    assert_kind_of Array, @spreadsheet.list, "Spreadsheet::list is kind of Array"
  end

  def testGetIdByDocId
    id = @spreadsheet.getIdByDocId ENV['GOOGLE_DOC_ID']
    expected = ENV['GOOGLE_SPREADSHEET_ID']
    assert_equal expected, id
      '#getIdByDocId works as expected.'
  end

end

class TestWorkSheet < MiniTest::Unit::TestCase
  def setup
    @worksheet = Jenkins::Worksheet.new ENV['GOOGLE_SPREADSHEET_ID']
  end

  def testWorksheetList
    assert_kind_of Array, @worksheet.list, "Worksheet::list is kind of Array"
  end
end


