module SearchAllaBolag
  require 'open-uri'
  require 'nokogiri'
  # search = search phrase
  # returns an ActiveRecord::Relation of companies
  def self.search search
    return Company.none if search.blank? or search.nil? #in case of empty search just return

    begin
      query = find_query_in_cache(search)
      return query.companies unless query.companies.empty?#if query found then return with results
    rescue
      Rails.logger.info "\n*** Error, cannot open database, use command: create database db_allabolag; ***"
      Rails.logger.info "*** to setup database use command: rake db:migrate RAILS_ENV=development ***\n"
      return Company.none
    end

    url = "http://www.allabolag.se?what=#{search}" #go to allabolag.se and fetch data

    begin
      doc = Nokogiri::HTML(open(url.sub(/ /,'+')))#opens url, replacing possible space with "+"
    rescue
      Rails.logger.info "\n*** Error, cannot open URL (#{url}) *** \n"
      return Company.none
    end

    #Go through all hitListLink field to extract company name and org.num
    for i in 0..doc.css('.hitlistLink').length-1

      begin #getting the standard nnnnnn-nnnn structure:
        orgNum = doc.css('.text11grey6')[i].content.match(/Org\.nummer: (\d+-\d+)/)[1]
      rescue #many org.nummer has nnnnnn-XXXX endings so this needs to be accounted for:
        orgNum = doc.css('.text11grey6')[i].content.match(/Org\.nummer: (\d+-\w)/)[1]
      end

      orgName = doc.css('.hitlistLink')[i].content
      query.companies << Company.find_or_create_by_identification_no_and_name(orgNum, orgName)
    end
    query.companies
  end
end

def find_query_in_cache(search)
  query = Query.where(text: search).first_or_create!
end