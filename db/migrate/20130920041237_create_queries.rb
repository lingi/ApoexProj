class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :text
      t.timestamps
    end
  end
end
