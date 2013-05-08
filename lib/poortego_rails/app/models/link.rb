############################
# Link ActiveRecord        #
#                          #
# Description:             #
# Link two entity objects  #
#                          #
# Attributes:              #
#  title:        text      #
#  description:  text      # 
#  entity_a_id:  reference #
#  entity_b_id:  reference #      
#  section_id:   reference #
#  project_id:   reference #
#                          #
############################
class Link < ActiveRecord::Base
  #validates :title, :presence => true
  validates :entity_a_id, :presence => true
  validates :entity_b_id, :presence => true
  validates :section_id, :presence => true
  validates :project_id, :presence => true

  belongs_to :project   # Reference to project
  belongs_to :section   # Reference to section
  belongs_to :entity_a, :class_name => 'Entity', :foreign_key => 'entity_a_id' # Reference to Entity
  belongs_to :entity_b, :class_name => 'Entity', :foreign_key => 'entity_b_id' # Reference to Entity
  has_many :link_fields # Link fields reference Links 
  
  #
  # List
  #
  def self.list(*args)
    link_rows = Array.new()
    begin
      project_id = args[0]
      section_id = args[1]
      if (args.length == 3)
        entity_a_id = args[2]
        link_rows = self.find(:all, :conditions => { :project_id => project_id, :section_id => section_id, :entity_a_id => entity_a_id }, :order => "title ASC")
      else
        link_rows = self.find(:all, :conditions => { :project_id => project_id, :section_id => section_id }, :order => "title ASC")
      end
    rescue Exception => e
      puts "Exception listing Links"
      puts self.inspect
      puts e.message
    end
    return link_rows
  end

  #
  # Select by Name
  #
  def self.select_by_name(*args)
    link_row = nil
    begin
      project_id = args[0]
      section_id = args[1]
      link_name  = args[2]
      link_row   = self.find(:first, :conditions => { :title => link_name, :project_id => project_id, :section_id => section_id })
    rescue Exception => e
      puts "Exception selecting Link"
      puts self.inspect
      puts e.message
    end
    return link_row
  end
  
  #
  # Select
  #
  def self.select(*args)
    link_row = nil
    begin
      project_id = args[0]
      section_id = args[1]
      entityA_name = args[2]
      entityB_name = args[3]
      entityA_obj = Entity.select(project_id, section_id, entityA_name)
      entityB_obj = Entity.select(project_id, section_id, entityB_name)
      
      if (args.length == 5)
        link_name = args[4]
        link_row = self.find(:first, :conditions => { :title => link_name, :project_id => project_id, :section_id => section_id, :entity_a_id => entityA_obj.id, :entity_b_id => entityB_obj.id })
      else
        link_row = self.find(:first, :conditions => { :project_id => project_id, :section_id => section_id, :entity_a_id => entityA_obj.id, :entity_b_id => entityB_obj.id })
      end
      
    rescue Exception => e
      puts "Exception selecting Link"
      puts self.inspect
      puts e.message
    end
    return link_row
  end

  #
  # Insert
  #
  def self.insert(*args)
    link_row = nil
    begin
      project_id   = args[0]
      section_id   = args[1]
      entityA_name = args[2]
      entityB_name = args[3]
      link_name = ''
      if (args.length == 5)
        link_name = args[4]
      else
        link_name = "#{entityA_name} --> #{entityB_name}"
      end
      
      entityA_obj = Entity.select(project_id, section_id, entityA_name)
      entityB_obj = Entity.select(project_id, section_id, entityB_name)  
      link_obj = self.new("title" => link_name, "project_id" => project_id, 
                          "section_id" => section_id, "entity_a_id" => entityA_obj.id, 
                          "entity_b_id" => entityB_obj.id)
      link_obj.save()
      puts "[DEBUG] INSERTED link with Id = #{link_obj.id}"
    rescue Exception => e
      puts "Exception inserting Link"
      puts self.inspect
      puts e.message
    end
    
    return link_obj
  end
  
  #
  # Select link if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    link_obj = nil

    begin
      project_id   = args[0]
      section_id   = args[1]
      entityA_name = args[2]
      entityB_name = args[3]
      link_obj     = nil
      link_name    = ''
      if (args.length == 5)
        link_name  = args[4]
        link_obj = self.select(project_id, section_id, entityA_name, entityB_name, link_name)
      else
        link_obj = self.select(project_id, section_id, entityA_name, entityB_name)
      end
        
      if (link_obj.nil?)
        link_obj = self.insert(project_id, section_id, entityA_name, entityB_name, link_name)
      end
      
    rescue Exception => e
      puts "Exception selecting/inserting Link"
      puts self.inspect
      puts e.message
    end
    return link_obj
  end

  #
  # Delete by name
  #
  def self.delete_from_name(*args)
    link_obj = nil    

    begin
      project_id = args[0]
      section_id = args[1]
      link_name  = args[2]
      
      link_obj = self.select_by_name(project_id, section_id, link_name)
      unless (link_obj.nil?)
        self.delete(link_obj.id)
        puts "[DEBUG] DELETED Link Id = #{link_obj.id}"
      else
        puts "[DEBUG] no link available with that name, nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Link"
      puts self.inspect
      puts e.message
    end
    
    return link_obj
  end  
  
    
end
