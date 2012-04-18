###
#
# EntityTypeField ActiveRecord -
# Describes the entity fields to use for specific entity types                
#                                             
# Attributes:                                 
#  field_name:     name of entity field         
#  entity_type_id: references entity_type     
#                                             
###
class EntityTypeField < ActiveRecord::Base
  validates :field_name, :presence => true
  validates :entity_type_id, :presence => true

  belongs_to :entity_type  # Reference to EntityType
                           # EntityType can have multiple EntityTypeFields
  #
  # List
  #
  def self.list(*args)
    field_rows = Array.new()
    begin
      type_id = args[0]
      field_rows = self.find(:all, :conditions => "entity_type_id=#{type_id}", :order => "field_name ASC")
    rescue Exception => e
      puts "Exception listing type fields"
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
      type_id = args[0]
      name    = args[1]
      field_row = self.find(:first, :conditions => "field_name='#{name}' AND entity_type_id=#{type_id}")
    rescue Exception => e
      puts "Exception selecting type field"
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
      type_id = args[0]
      name    = args[1]
      field_row = self.new("entity_type_id" => type_id, "field_name" => name)
      field_row.save()
      puts "[DEBUG] INSERTED type field with Name = #{name}, Id = #{field_row.id}"
    rescue Exception => e
      puts "Exception inserting Type Field"
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
      type_id = args[0]
      name    = args[1]
      field_row = self.select(type_id, name)
      if (field_row.nil?)
        field_row = self.insert(type_id, name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Type Field"
      puts self.inspect
      puts e.message
    end
    return field_row    
  end
  
  #
  # Delete from Name
  #
  def self.delete_from_name(*args)
    field_row = nil
    begin
      type_id = args[0]
      name    = args[1]
      field_row = self.find(:first, :conditions => "entity_type_id=#{type_id} AND field_name='#{name}'")
      unless (field_row.nil?)
        self.delete(field_row.id)
        puts "[DEBUG] DELETED type field with name #{name}, Id = #{field_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Type Field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end

end
