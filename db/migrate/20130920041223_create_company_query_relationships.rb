#to create query relationships in database
class CreateCompanyQueryRelationships < ActiveRecord::Migration
  def change
    create_table :company_query_relationships do |t|
      t.integer :query_id
      t.integer :company_id
      t.timestamps
    end
  end
end
