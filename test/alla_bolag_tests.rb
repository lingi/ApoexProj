require "test/unit"
require "nokogiri"
require File.expand_path(File.dirname(__FILE__) + "/../lib/search_alla_bolag")

class TestSuitReader < Test::Unit::TestCase

  def test_extraction_of_OrgNum
    f = File.open("apoex_query.html")
    doc = Nokogiri::HTML(f)
    orgNum = getCompanyOrgNum(0,doc)
    assert_equal("556633-4149",orgNum)
  end
end
