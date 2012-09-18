class CreateSectionDescriptors < ActiveRecord::Migration
  def change
    create_table :section_descriptors do |t|
      t.string :field
      t.text :value
      t.references :section

      t.timestamps
    end
    add_index :section_descriptors, :section_id
  end
end
