class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.text :title
      t.references :entity_type
      t.text :description
      t.references :project
      t.references :section

      t.timestamps
    end
    add_index :entities, :entity_type_id
    add_index :entities, :project_id
    add_index :entities, :section_id
  end
end
