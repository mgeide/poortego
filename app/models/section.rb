############################
# Section ActiveRecord     #
#                          #
# Description:             #
# Store Section Object     #
#                          #
# Attributes:              #
#  title:        string    #
#  description:  text      # 
#  project_id:   reference #
#                          #
############################
class Section < ActiveRecord::Base
  validates :title, :presence => true
  validates :project_id, :presence => true

  belongs_to :project
  has_many :entities
  has_many :links
  
  ################################
  # Method: list()
  ################################
  def self.list(*args)
    
    project_id = args[0]
    section_names = Array.new()
    
    begin
        # Try to find Sections by title
        section_rows = self.find(:all, :conditions => "project_id=#{project_id}", :order => "title ASC")
        section_rows.each do |section_row|
          section_names.push(section_row['title'])
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception listing Sections"
            puts self.inspect
            puts e.message
    end
    
    return section_names
    
  end
  
  ################################
  # Method: select()
  ################################
  def self.select(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_name = args[1]
    
    section_id = -1
    begin
        # Try to find Project by title first
        section_row = self.find(:first, :conditions => "title='#{section_name}' AND project_id=#{project_id}")
        unless (section_row.nil?)
            if (section_row.id > -1)
              section_id = section_row.id
              puts "[DEBUG] SELECTED section with title #{section_name}, Id = #{section_id}"
            end
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting Section"
            puts self.inspect
            puts e.message
    end
    
    return section_id
    
  end
  
  ################################
  # Method: insert()
  ################################
  def self.insert(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_name = args[1]
    
    section_id = -1
    begin
        # Try to create Project with title
        section = self.new("title" => section_name, "project_id" => project_id.to_i)
        section.save()
        section_id = section.id
        puts "[DEBUG] INSERTED section with title #{section_name}, Id = #{section_id}"
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception inserting Section"
            puts self.inspect
            puts e.message
    end
    
    return section_id
    
  end
  
  ################################
  # Method: select_or_insert()
  ################################
  def self.select_or_insert(*args)
    
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_name = args[1]
    
    already_retried = false
    section_id = -1
    begin
        # Try to select Section by title first
        section_id = self.select(project_id, section_name)
        
        # If not exists then insert
        unless (section_id > -1)
            section_id = self.insert(project_id, section_name)
        end
    rescue Exception => e
        #ActiveRecord::Base.connection.reconnect!
        unless already_retried
            already_retried = true
            puts "Retrying Section entry"
            retry
        else
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception selecting/inserting Section"
            puts self.inspect
            puts e.message
        end
    end
    
    return section_id    
  
  end
  
  ################################
  # Method: delete_from_name()
  ################################
  def self.delete_from_name(*args)
        
    ## TODO: add logic to validate argument
    project_id = args[0]
    section_name = args[1]
    
    section_id = -1
    begin
        # Try to find Section by title first
        section_id = self.select(project_id, section_name)
        if (section_id > -1)
              self.delete(section_id)
              puts "[DEBUG] DELETED section with title #{section_name}, Id = #{section_id}"
        end
    rescue Exception => e
            #ActiveRecord::Base.clear_active_connections!
            puts "Exception deleting Section"
            puts self.inspect
            puts e.message
    end
    
    return section_id
  end
  
  
end
