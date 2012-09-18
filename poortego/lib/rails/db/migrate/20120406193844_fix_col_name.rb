class FixColName < ActiveRecord::Migration
  def up
    rename_column :section_descriptors, :field, :field_name
  end

  def down
  end
end
