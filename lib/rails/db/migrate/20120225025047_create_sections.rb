class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.text :description
      t.references :project

      t.timestamps
    end
    add_index :sections, :project_id
  end
end
