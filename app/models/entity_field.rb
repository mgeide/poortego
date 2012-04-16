###############################################
# EntityField ActiveRecord                    #
#                                             #
# Description:                                #
# Store name to values associated with Entity #
#                                             #
# Attributes:                                 #
#  name:   name of entity field               #
#  value:  value associated with field        #
#  entity_id: references Entity               #
#                                             #
###############################################
class EntityField < ActiveRecord::Base
  validates :name, :presence => true
  validates :entity_id, :presence => true

  belongs_to :entity 	# Reference to entities 
			# Entities can have multiple fields
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    entity_id = args[0]
    
    field_names = Array.new()
    begin
        # Try to find Types by title
        field_rows = self.find(:all, :conditions => "entity_id=#{entity_id}", :order => "name ASC")
        field_rows.each do |field_row|
          field_names.push(field_row['name'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing fields"
            puts self.inspect
            puts e.message
    end
    
    return field_names
    
  end
  
  ################################
  # Method: list_with_values()
  ################################
  def self.list_with_values(*args)
    entity_id = args[0]
    
    fields = Hash.new()
    begin
        # Try to find Types by title
        field_rows = self.find(:all, :conditions => "entity_id=#{entity_id}", :order => "name ASC")
        field_rows.each do |field_row|
          fields[field_row['name']] = field_row['value']
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing fields"
            puts self.inspect
            puts e.message
    end
    
    return fields
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    entity_id = args[0]
    name = args[1]
    
    id = -1
    begin
        # Try to find by title first
        row = self.find(:first, :conditions => "name='#{name}' AND entity_id=#{entity_id}")
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              puts "[DEBUG] SELECTED field with Name = #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting field"
            puts self.inspect
            puts e.message
    end
    
    return id
    
  end
  
  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    entity_id = args[0]
    name    = args[1]
    
    id = -1
    begin
        # Try to create with title
        field = self.new("entity_id" => entity_id, "name" => name)
        field.save()
        id = field.id
        puts "[DEBUG] INSERTED type field with Name = #{name}, Id = #{id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Field"
            puts self.inspect
            puts e.message
    end
    
    return id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    entity_id = args[0]
    name      = args[1]
    
    puts "[DEBUG] select_Or_insert for Field of name #{name}"
    
    already_retried = false
    id = -1
    begin
        # Try to select Type by title first
        id = self.select(entity_id, name)
        
        # If not exists then insert
        unless (id > -1)
            id = self.insert(entity_id, name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Field entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Type"
            puts self.inspect
            puts e.message
        end
    end
    
    return id    
  
  end
  
  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    entity_id = args[0]
    name    = args[1]
    
    id = -1
    begin
        # Try to find Project by title first
        row = self.find(:first, :conditions => "entity_id=#{entity_id} AND name='#{name}'")
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              self.delete(id)
              puts "[DEBUG] DELETED type field with name #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Field"
            puts self.inspect
            puts e.message
    end
    
    return id
  end
  
end
