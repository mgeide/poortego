class CreateLinkFields < ActiveRecord::Migration
  def change
    create_table :link_fields do |t|
      t.string :name
      t.text :value
      t.references :link

      t.timestamps
    end
    add_index :link_fields, :link_id
  end
end
