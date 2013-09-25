class Query < ActiveRecord::Base
  has_many :company_query_relationships, dependent: :destroy #each query has a set of companies
  has_many :companies, through: :company_query_relationships
end
