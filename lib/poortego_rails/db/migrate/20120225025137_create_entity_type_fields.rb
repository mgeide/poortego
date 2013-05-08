class CreateEntityTypeFields < ActiveRecord::Migration
  def change
    create_table :entity_type_fields do |t|
      t.string :field_name
      t.references :entity_type

      t.timestamps
    end
    add_index :entity_type_fields, :entity_type_id
  end
end
