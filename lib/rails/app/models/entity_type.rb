###############################################
# EntityType ActiveRecord                     #
#                                             #
# Description:                                #
# Store name to values associated with Entity #
#                                             #
# Attributes:                                 #
#  title:   name of entity type               #
#  description:  description of type          #
#                                             #
###############################################
class EntityType < ActiveRecord::Base
  validates :title, :presence => true,
                   :uniqueness => true

  has_many :entity_type_fields  # EntityTypeFields references EntityType
                                # EntityType can have multiple EntityTypeFields 
                                
                                
  #
  # List
  #
  def self.list(*args)
    
    type_rows = Array.new()
    begin
        # Try to find Types by title
        type_rows = self.find(:all, :order => "title ASC")
        #type_rows.each do |type_row|
        #  type_names.push(type_row['title'])
        #end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Types"
            puts self.inspect
            puts e.message
    end
    
    return type_rows
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    id  = -1
    row = nil
    begin
        # Try to find by title first
        row = self.find(:first, :conditions => { :title => name })
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              puts "[DEBUG] SELECTED type with title #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting type"
            puts self.inspect
            puts e.message
    end
    
    return row
    
  end
  
  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    id   = -1
    type = nil
    begin
        # Try to create with title
        type = self.new("title" => name)
        type.save()
        id = type.id
        puts "[DEBUG] INSERTED type with title #{name}, Id = #{id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Type"
            puts self.inspect
            puts e.message
    end
    
    return type
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    already_retried = false
    id   = -1
    type = nil
    
    begin
        # Try to select Type by title first
        type = self.select(name)
        
        # If not exists then insert
        unless (type.nil?)
            type = self.insert(name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Type entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Type"
            puts self.inspect
            puts e.message
        end
    end
    
    return type    
  
  end
  
  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    name = args[0]
    
    id  = -1
    row = nil
    
    begin
        # Try to find Project by title first
        row = self.find(:first, :conditions => { :title => name })
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              self.delete(id)
              puts "[DEBUG] DELETED project with title #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Type"
            puts self.inspect
            puts e.message
    end
    
    return row
  end
  
                                
end
