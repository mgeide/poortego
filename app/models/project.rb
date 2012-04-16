############################
# Project ActiveRecord     #
#                          #
# Description:             #
# Store Project Object     #
#                          #
# Attributes:              #
#  title:        string    #
#  description:  text      # 
#                          #
############################
class Project < ActiveRecord::Base
  #attr_accessor :title
  
  validates :title, :presence => true,
                   :uniqueness => true

  has_many :sections
  has_many :entities
  has_many :links

  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    project_names = Array.new()
    begin
        # Try to find Projects by title
        project_rows = self.find(:all, :order => "title ASC")
        project_rows.each do |project_row|
          project_names.push(project_row['title'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Projecst"
            puts self.inspect
            puts e.message
    end
    
    return project_names
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    project_id = -1
    begin
        # Try to find Project by title first
        project_row = self.find(:first, :conditions => "title='#{name}'")
        unless (project_row.nil?)
            if (project_row.id > -1)
              project_id = project_row.id
              puts "[DEBUG] SELECTED project with title #{name}, Id = #{project_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting Project"
            puts self.inspect
            puts e.message
    end
    
    return project_id
    
  end
  
  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    project_id = -1
    begin
        # Try to create Project with title
        project = self.new("title" => name)
        project.save()
        project_id = project.id
        puts "[DEBUG] INSERTED project with title #{name}, Id = #{project_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Project"
            puts self.inspect
            puts e.message
    end
    
    return project_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    name = args[0]
    
    already_retried = false
    project_id = -1
    begin
        # Try to select Project by title first
        project_id = self.select(name)
        
        # If not exists then insert
        unless (project_id > -1)
            project_id = self.insert(name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Project entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Project"
            puts self.inspect
            puts e.message
        end
    end
    
    return project_id    
  
  end
  
  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    name = args[0]
    
    project_id = -1
    begin
        # Try to find Project by title first
        project_row = self.find(:first, :conditions => "title='#{name}'")
        unless (project_row.nil?)
            if (project_row.id > -1)
              project_id = project_row.id
              self.delete(project_id)
              puts "[DEBUG] DELETED project with title #{name}, Id = #{project_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Project"
            puts self.inspect
            puts e.message
    end
    
    return project_id
  end
  
end
