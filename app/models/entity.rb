############################
# Entity ActiveRecord      #
#                          #
# Description:             #
# Store Entity Object      #
#                          #
# Attributes:              #
#  title:        text      #
#  description:  text      # 
#  entity_type:  reference #      
#  section_id:   reference #
#  project_id:   reference #
#                          #
############################
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
                          
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    project_id = args[0]
    section_id = args[1]
    object_names = Array.new()
    
    begin
        # Try to find Objects by title
        object_rows = self.find(:all, :conditions => "project_id=#{project_id} AND section_id=#{section_id}", :order => "title ASC")
        object_rows.each do |object_row|
          object_names.push(object_row['title'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Objects"
            puts self.inspect
            puts e.message
    end
    
    return object_names
    
  end                       

  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_id = args[1]
    object_name = args[2]
    
    object_id = -1
    begin
        # Try to find Object by title first
        object_row = self.find(:first, :conditions => "title='#{object_name}' AND project_id=#{project_id} AND section_id=#{section_id}")
        unless (object_row.nil?)
            if (object_row.id > -1)
              object_id = object_row.id
              puts "[DEBUG] SELECTED object with title #{object_name}, Id = #{object_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting Object"
            puts self.inspect
            puts e.message
    end
    
    return object_id
    
  end

  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_id = args[1]
    object_name = args[2]
    
    object_id = -1
    begin
        # Try to create Object with title
        object = self.new("title" => object_name, "project_id" => project_id, "section_id" => section_id)
        object.save()
        object_id = object.id
        puts "[DEBUG] INSERTED object with title #{object_name}, Id = #{object_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Object"
            puts self.inspect
            puts e.message
    end
    
    return object_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_id = args[1]
    object_name = args[2]
    
    already_retried = false
    object_id = -1
    begin
        # Try to select Section by title first
        object_id = self.select(project_id, section_id, object_name)
        
        # If not exists then insert
        unless (object_id > -1)
            object_id = self.insert(project_id, section_id, object_name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Object entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Object"
            puts self.inspect
            puts e.message
        end
    end
    
    return object_id    
  
  end

  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_id = args[1]
    object_name = args[2]
    
    object_id = -1
    begin
        # Try to find Section by title first
        object_id = self.select(project_id, section_id, object_name)
        if (object_id > -1)
              self.delete(object_id)
              puts "[DEBUG] DELETED section with title #{object_name}, Id = #{object_id}"
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Section"
            puts self.inspect
            puts e.message
    end
    
    return object_id
  end  
  
  ################################
  # Method: set_type()
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

