class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.text :description
      t.references :project
      t.references :section
      t.integer 'entity_a_id'
      t.integer 'entity_b_id'

      t.timestamps
    end
    add_index :links, :project_id
    add_index :links, :section_id
  end
end
