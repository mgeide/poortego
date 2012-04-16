#############################################
# LinkTypeField ActiveRecord                #
#                                           #
# Description:                              #
# Store field name associated with LinkType #
#                                           #
# Attributes:                               #
#  field_name:   name of link field         #
#  link_type_id:    references link_type    #
#                                           #
#############################################
class LinkTypeField < ActiveRecord::Base
  validates :field_name, :presence => true
  validates :link_type_id, :presence => true

  belongs_to :link_type  # Reference to link_type
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    type_id = args[0]
    
    field_names = Array.new()
    begin
        # Try to find Types by title
        field_rows = self.find(:all, :conditions => "link_type_id=#{type_id}", :order => "field_name ASC")
        field_rows.each do |field_row|
          field_names.push(field_row['field_name'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing type fields"
            puts self.inspect
            puts e.message
    end
    
    return field_names
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    type_id = args[0]
    name    = args[1]
    
    id = -1
    begin
        # Try to find by title first
        row = self.find(:first, :conditions => "field_name='#{name}' AND link_type_id=#{type_id}")
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              puts "[DEBUG] SELECTED field type with Name = #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting type field"
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
    type_id = args[0]
    name    = args[1]
    
    id = -1
    begin
        # Try to create with title
        field = self.new("link_type_id" => type_id, "field_name" => name)
        field.save()
        id = field.id
        puts "[DEBUG] INSERTED type field with Name = #{name}, Id = #{id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Type"
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
    type_id = args[0]
    name    = args[1]
    
    already_retried = false
    project_id = -1
    begin
        # Try to select Type by title first
        id = self.select(type_id, name)
        
        # If not exists then insert
        unless (id > -1)
            id = self.insert(type_id, name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Type Field entry"
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
    type_id = args[0]
    name    = args[1]
    
    id = -1
    begin
        # Try to find Project by title first
        row = self.find(:first, :conditions => "link_type_id=#{type_id} AND field_name='#{name}'")
        unless (row.nil?)
            if (row.id > -1)
              id = row.id
              self.delete(id)
              puts "[DEBUG] DELETED type field with name #{name}, Id = #{id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Type"
            puts self.inspect
            puts e.message
    end
    
    return id
  end
  
  
end
