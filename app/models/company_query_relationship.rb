class CompanyQueryRelationship < ActiveRecord::Base
  belongs_to :company
  belongs_to :query
end
