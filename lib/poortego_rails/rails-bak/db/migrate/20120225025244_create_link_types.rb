class CreateLinkTypes < ActiveRecord::Migration
  def change
    create_table :link_types do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
