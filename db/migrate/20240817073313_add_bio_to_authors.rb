class AddBioToAuthors < ActiveRecord::Migration[7.1]
  def change
    add_column :authors, :bio, :text
  end
end
