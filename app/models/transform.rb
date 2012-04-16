class Transform < ActiveRecord::Base
  belongs_to :entity_type
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    transform_names = Array.new()
    begin
        # Try to find Transforms by title
        transform_rows = self.find(:all, :order => "title ASC")
        transform_rows.each do |transform_row|
          transform_names.push(transform_row['title'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Transform"
            puts self.inspect
            puts e.message
    end
    
    return transform_names
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    transform_id = -1
    begin
        # Try to find Project by title first
        transform_row = self.find(:first, :conditions => "title='#{name}'")
        unless (transform_row.nil?)
            if (transform_row.id > -1)
              transform_id = transform_row.id
              puts "[DEBUG] SELECTED transform with title #{name}, Id = #{transform_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting Transform"
            puts self.inspect
            puts e.message
    end
    
    return transform_id
    
  end
  
  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    transform_id = -1
    begin
        # Try to create Project with title
        project = self.new("title" => name)
        project.save()
        transform_id = project.id
        puts "[DEBUG] INSERTED project with title #{name}, Id = #{transform_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Transform"
            puts self.inspect
            puts e.message
    end
    
    return transform_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    already_retried = false
    transform_id = -1
    begin
        # Try to select Project by title first
        transform_id = self.select(name)
        
        # If not exists then insert
        unless (transform_id > -1)
            transform_id = self.insert(name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Transform entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Transform"
            puts self.inspect
            puts e.message
        end
    end
    
    return transform_id    
  
  end
  
  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    name = args[0]
    
    transform_id = -1
    begin
        # Try to find Project by title first
        transform_row = self.find(:first, :conditions => "title='#{name}'")
        unless (transform_row.nil?)
            if (transform_row.id > -1)
              transform_id = transform_row.id
              self.delete(transform_id)
              puts "[DEBUG] DELETED project with title #{name}, Id = #{transform_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Transform"
            puts self.inspect
            puts e.message
    end
    
    return transform_id
  end
  
  
end
