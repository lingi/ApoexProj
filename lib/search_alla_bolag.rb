module SearchAllaBolag
  require 'open-uri'
  require 'nokogiri'

  # companyName = search phrase
  # returns an ActiveRecord::Relation of companies
  def self.search companyName
    query_template = "http://www.allabolag.se?what="
    raise ArgumentError.new("You must specify search criteria. A company name for example.") if  companyName.nil? or companyName.blank?

    query = find_query_in_cache(companyName)
    if(query.blank?)
      return Company.none
    end
    if(!query.companies.empty?)
      return query.companies
    end

    searchURL = createSearchURL(query_template , companyName)
    searchResult = readHTMLSourceFromURL(searchURL)
    if(searchResult.blank?)
      return Company.none
    end

    #Go through all hitListLink field to extract company name and org.num
    numberOfCompaniesFound = findNumberOfCompanies(searchResult)

    for i in 0..numberOfCompaniesFound-1
      orgNum = getCompanyOrgNum(i,searchResult)
      orgName = getCompanyName(i,searchResult)
      query.companies << Company.find_or_create_by_identification_no_and_name(orgNum, orgName)
    end
    return query.companies
  end

  def self.findNumberOfCompanies(doc)
    numberOfCompaniesFound = doc.css('.hitlistLink').length
  end
  def self.createSearchURL(queryURLTemplate,companyName)
    searchURL = "#{queryURLTemplate}#{companyName}"
  end

  def self.find_query_in_cache(search)
    query = []
    return query if search.blank? or search.nil? #in case of empty search just return
    begin
      query = Query.where(text: search).first_or_create!
    rescue
      Rails.logger.info "\n*** Error, cannot open database, use command: create database db_allabolag; ***"
      Rails.logger.info "*** to setup database use command: rake db:migrate RAILS_ENV=development ***\n"

      raise "Error, cannot open database"
    end
  end

end


def readHTMLSourceFromURL(url)
  begin
    doc = Nokogiri::HTML(open(url.sub(/ /,'+')))#opens url, replacing possible space with "+"
  rescue
    Rails.logger.info "\n*** Error, cannot open URL (#{url}) *** \n"
    return doc = []
  end
end

def getCompanyOrgNum(i,doc)
  begin #getting the standard nnnnnn-nnnn structure:
    orgNum = doc.css('.text11grey6')[i].content.match(/Org\.nummer: (\d+-\d+)/)[1]
  rescue #many org.nummer has nnnnnn-XXXX endings so this needs to be accounted for:
    orgNum = doc.css('.text11grey6')[i].content.match(/Org\.nummer: (\d+-\w)/)[1]
  ensure
    orgNum = []
  end
end

def getCompanyName(i,doc)
  orgName = doc.css('.hitlistLink')[i].content
end