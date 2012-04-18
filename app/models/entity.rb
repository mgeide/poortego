###
#
# Entity ActiveRecord -
# This is the main "data" structure
# Can contain links to other entities and name/value fields
#                          
# Attributes:              
#  title:        text      
#  description:  text       
#  entity_type:  reference       
#  section_id:   reference 
#  project_id:   reference 
#                          
###
class Entity < ActiveRecord::Base
  validates :title, :presence => true
  validates :section_id, :presence => true
  validates :project_id, :presence => true

  belongs_to :entity_type # Reference to entity_type
                          # Entities can have one type	

  belongs_to :project     # Reference to project
                          # Entities can belong to multiple projects

  belongs_to :section     # Referecne to section
                          # Entities can belong to multiple sections

  has_many :entity_fields # Entities are referenced by entity_field
                          # Multiple entity_fields may reference an entity  
                          
  #
  # List
  #
  def self.list(*args)
    entity_rows = Array.new()
    begin
      project_id = args[0]
      section_id = args[1]
      entity_rows = self.find(:all, :conditions => "project_id=#{project_id} AND section_id=#{section_id}", :order => "title ASC")
    rescue Exception => e
      puts "Exception listing Entities"
      puts self.inspect
      puts e.message
    end
    return entity_rows
  end                       

  #
  # Select
  #
  def self.select(*args)
    entity_row = nil
    begin
      project_id  = args[0]
      section_id  = args[1]
      entity_name = args[2]
      entity_row  = self.find(:first, :conditions => "title='#{entity_name}' AND project_id=#{project_id} AND section_id=#{section_id}")
    rescue Exception => e
      puts "Exception selecting Entity"
      puts self.inspect
      puts e.message
    end
    return entity_row
  end

  #
  # Insert
  #
  def self.insert(*args)
    entity_row = nil
    begin
      project_id  = args[0]
      section_id  = args[1]
      entity_name = args[2]
      entity_row  = self.new("title" => entity_name, "project_id" => project_id, "section_id" => section_id)
      entity_row.save()
      puts "[DEBUG] INSERTED entity with title #{entity_name}, Id = #{entity_row.id}"
    rescue Exception => e
      puts "Exception inserting Entity"
      puts self.inspect
      puts e.message
    end
    return entity_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    entity_row = nil    
    begin
      project_id  = args[0]
      section_id  = args[1]
      entity_name = args[2]
      entity_row = self.select(project_id, section_id, entity_name)
      if (entity_row.nil?)  
        entity_row = self.insert(project_id, section_id, entity_name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Entity"
      puts self.inspect
      puts e.message
    end
    return entity_row
  end

  #
  # Delete from name
  #
  def self.delete_from_name(*args)
    entity_row = nil    
    begin
      project_id  = args[0]
      section_id  = args[1]
      entity_name = args[2]
      entity_row  = self.select(project_id, section_id, entity_name)
      unless (entity_row.nil?)
        self.delete(entity_row.id)
        puts "[DEBUG] DELETED entity with title #{entity_name}, Id = #{entity_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Entity"
      puts self.inspect
      puts e.message
    end
    return entity_row
  end  
  
  ################################
  # Method: set_type() -- TODO??
  ################################
  def self.set_type(*args)
    project_id = args[0]
    section_id = args[1]
    object_id  = args[2]
    type_name  = args[3]
    
    # TODO: maybe move the logic here from entity_dispatcher
    #  Get the field names tied to the entity type
    #  Loop through these and add fields with default values to entity
    
  end
                          
end

