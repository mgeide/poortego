class CreateEntityFields < ActiveRecord::Migration
  def change
    create_table :entity_fields do |t|
      t.string :name
      t.text :value
      t.references :entity

      t.timestamps
    end
    add_index :entity_fields, :entity_id
  end
end
