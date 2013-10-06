require "test/unit"
require 'open-uri'
require "nokogiri"
require File.expand_path(File.dirname(__FILE__) + "/../lib/search_alla_bolag")

class TestSuitAllaBolag < Test::Unit::TestCase

  def test_find_company_orgnum
    f = File.open("apoex_query.html")
    doc = Nokogiri::HTML(f)
    orgNum = findCompanyOrgNum(0,doc)
    assert_equal("556633-4149",orgNum)
  end

  def test_find_company_name
    f = File.open("apoex_query.html")
    doc = Nokogiri::HTML(f)
    firstCompanyName = findCompanyName(0,doc)
    assert_equal("ApoEx AB",firstCompanyName)
    secondCompanyName = findCompanyName(1,doc)
    assert_equal("ApoEx System AB",secondCompanyName)
  end

  def test_find_number_of_companies
    f = File.open("apoex_query.html")
    doc = Nokogiri::HTML(f)
    numberOfCompaniesFound = findNumberOfCompanies(doc)
    assert_equal(10,numberOfCompaniesFound)
  end

  def test_create_search_url
    searchURL = createSearchURL("http://www.allabolag.se?what=","Tele2")
    assert_equal("http://www.allabolag.se?what=Tele2",searchURL)
  end

end
