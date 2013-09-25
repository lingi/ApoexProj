class Company < ActiveRecord::Base

  validates_uniqueness_of :identification_no #Validates whether the value of the specified attributes are unique
  has_many :company_query_relationships      #one-to-many connection with company
  has_many :queries, through: :company_query_relationships

  # Returns the URL to the company on allabolag.se in a string.
  def get_url
    "http://www.allabolag.se/#{self.identification_no.gsub("-","")}"
  end
end
