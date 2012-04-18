###
#
# EntityField ActiveRecord -
# Name/Value pairs tied to an entity that you don't want as a separate entity/link                   
#                                             
# Attributes:                                 
#  name:      name of entity field               
#  value:     value associated with field        
#  entity_id: references Entity               
#                                             
###
class EntityField < ActiveRecord::Base
  validates :name, :presence => true
  validates :entity_id, :presence => true

  belongs_to :entity 	# Reference to entities 
			                # Entities can have multiple fields
  #
  # List
  #
  def self.list(*args)
    field_rows = Array.new()
    begin
      entity_id = args[0]
      field_rows = self.find(:all, :conditions => "entity_id=#{entity_id}", :order => "name ASC")
    rescue Exception => e
      puts "Exception listing fields"
      puts self.inspect
      puts e.message
    end
    return field_rows
  end
  
  #
  # Select
  #
  def self.select(*args)
    field_row = nil
    begin
      entity_id = args[0]
      name = args[1]
      field_row = self.find(:first, :conditions => "name='#{name}' AND entity_id=#{entity_id}")
    rescue Exception => e
      puts "Exception selecting field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
  #
  # Insert
  #
  def self.insert(*args)
    field_row = nil
    begin
      entity_id = args[0]
      name      = args[1]
      field_row = self.new("entity_id" => entity_id, "name" => name)
      field_row.save()
      puts "[DEBUG] INSERTED field with Name = #{name}, Id = #{field_row.id}"
    rescue Exception => e
      puts "Exception inserting Field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    field_row = nil
    begin
      entity_id = args[0]
      name      = args[1]
      field_row = self.select(entity_id, name)
      if (field_row.nil?)
        field_row = self.insert(entity_id, name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Field"
      puts self.inspect
      puts e.message
    end  
  end
  
  #
  # Delete by name
  #
  def self.delete_from_name(*args)
    field_row = nil
    begin
      entity_id = args[0]
      name    = args[1]
      field_row = self.find(:first, :conditions => "entity_id=#{entity_id} AND name='#{name}'")
      unless (field_row.nil?)
        self.delete(field_row.id)
        puts "[DEBUG] DELETED field with name #{name}, Id = #{field_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
end
