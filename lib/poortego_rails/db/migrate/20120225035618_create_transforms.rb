class CreateTransforms < ActiveRecord::Migration
  def change
    create_table :transforms do |t|
      t.string :title
      t.text :description
      t.string :source_file
      t.references :entity_type

      t.timestamps
    end
    add_index :transforms, :entity_type_id
  end
end
