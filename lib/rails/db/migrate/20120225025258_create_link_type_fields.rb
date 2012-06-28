class CreateLinkTypeFields < ActiveRecord::Migration
  def change
    create_table :link_type_fields do |t|
      t.string :field_name
      t.references :link_type

      t.timestamps
    end
    add_index :link_type_fields, :link_type_id
  end
end
