require 'minitest/autorun'
require "./gworksheet"

class TestJenkinsClient < Minitest::Test
  def setup
    @app = Jenkins::GoogleApp.new
  end

  def test_Client
    assert_kind_of Google::APIClient, @app.client,
      "The Google client is initialized successfully"
  end
end

class TestSpreadsheet < Minitest::Test
  def setup
    @spreadsheet = Jenkins::Spreadsheet.new
  end

  def test_SpreadsheetList
    assert_kind_of Array, @spreadsheet.list, "Spreadsheet::list is kind of Array"
  end

  def test_GetIdByDocId
    id = @spreadsheet.getIdByDocId ENV['GOOGLE_DOC_ID']
    expected = ENV['GOOGLE_SPREADSHEET_ID']
    assert_equal expected, id
      '#getIdByDocId works as expected.'
  end
end

class TestWorkSheet < Minitest::Test
  def setup
    @worksheet = Jenkins::Worksheet.new ENV['GOOGLE_SPREADSHEET_ID']
  end

  def test_WorksheetList
    assert_kind_of Array, @worksheet.list, "Worksheet::list is kind of Array"
  end
end


