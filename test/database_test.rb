require "test/unit"
require File.expand_path(File.dirname(__FILE__) + "/../lib/search_alla_bolag")
require File.dirname(__FILE__) + '/../test/test_helper'

class TestCompaniesController < ActiveSupport::TestCase

  def test_find_query_in_cache

    search = "apoex"
    query = Query.where(text: search).first_or_create!
    assert_equal(search,query.text)

    testName = "TestName"
    #query.companies << Company.find_or_create_by_identification_no_and_name("123456-1234",testName)
    #assert_equal("123456-1234",query.companies)

    new_query = Company.new :name => testName, :identification_no => 1
    assert new_query.save
    new_query_copy = Company.find(new_query.id)

    assert_equal(new_query.name, new_query_copy.name)
    assert_equal(testName,new_query.name)

    assert new_query.save
    assert new_query.destroy
  end

  def test_search_blank
    search = ""
    query = Query.where(text: search).first_or_create!
    assert_equal(true,query.companies.empty?)
  end

  def test_search_not_found
    search = "xxxx"
    query = Query.where(text: search).first_or_create!
    assert_equal(true,query.companies.empty?)
  end

end