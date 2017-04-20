class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name
      t.string   :email
      t.string   :avatar_file_name  
      t.string   :avatar_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      t.string   :signature_file_name  
      t.string   :signature_content_type
      t.integer  :signature_file_size
      t.datetime :signature_updated_at

      t.timestamps
    end
  end
end