###
#
# Project ActiveRecord -
# This is the main container which houses sections,
# which in turn house your data (entities, fields, links)    
#                          
# Attributes:              
#  title:        string    
#  description:  text       
#                          
###
class Project < ActiveRecord::Base
  
  validates :title, :presence => true,
                   :uniqueness => true

  has_many :sections
  has_many :entities
  has_many :links
 
  #
  # List projects
  #
  def self.list(*args)
    project_rows = Array.new()
    begin
      project_rows = self.find(:all, :order => "title ASC")
    rescue Exception => e
      puts "Exception listing Project"
      puts self.inspect
      puts e.message
    end
    return project_rows
  end
  
  #
  # Select a project
  #
  def self.select(*args)
    project_row = nil
    begin
      name = args[0]
      project_row = self.find(:first, :conditions => { :title => name })
    rescue Exception => e
      puts "Exception selecting Project"
      puts self.inspect
      puts e.message
    end
    return project_row
  end
  
  #
  # Insert a project
  #
  def self.insert(*args)
    project_row = nil
    begin
      name = args[0]
      project_row = self.new("title" => name)
      project_row.save()  
      puts "[DEBUG] INSERTED project with title #{name}, Id = #{project_row.id}"
    rescue Exception => e
      puts "Exception inserting Project"
      puts self.inspect
      puts e.message
    end
    return project_row
  end
  
  #
  # Select a project if exists, otherwise insert it
  #
  def self.select_or_insert(*args)
    project_row = nil
    begin
      name = args[0]
      # Try to select Project by title first
      project_row = self.select(name)
      # Otherwise insert  
      if (project_row.nil?)
        project_row = self.insert(name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Project"
      puts self.inspect
      puts e.message
    end
    return project_row   
  end
  
  #
  # Delete project by name
  #
  def self.delete_from_name(*args)
    project_row = nil
    begin
      name = args[0]
      # Try to find Project by title first
      project_row = self.find(:first, :conditions => { :title => name })
      unless (project_row.nil?)
        self.delete(project_row.id)
        puts "[DEBUG] DELETED project with title #{name}, Id = #{project_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Project"
      puts self.inspect
      puts e.message
    end
    return project_row
  end
  
end
