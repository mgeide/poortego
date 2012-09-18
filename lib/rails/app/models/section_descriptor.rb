###
#
# SectionDescriptor ActiveRecord -
#  Store descriptors or notes about section 
#                                
# Attributes:                    
#  field:      string               
#  value:      text                 
#  section_id: reference         
#                                
###
class SectionDescriptor < ActiveRecord::Base
  validates :field_name, :presence => true
  validates :section_id, :presence => true

  belongs_to :section
  
  #
  # List
  #
  def self.list(*args)
    descriptor_rows = Array.new()    
    begin
      section_id = args[0]
      descriptor_rows = self.find(:all, :conditions => { :section_id => section_id }, :order => "field_name ASC")
    rescue Exception => e
      puts "Exception listing Descriptors"
      puts self.inspect
      puts e.message
    end
    return descriptor_rows
  end                       

  #
  # Select
  #
  def self.select(*args)
    descriptor_row = nil
    begin
      section_id = args[0]
      descriptor_name = args[1]
      descriptor_row = self.find(:first, :conditions => { :field_name => descriptor_name, :section_id => section_id })
    rescue Exception => e
      puts "Exception selecting descriptor"
      puts self.inspect
      puts e.message
    end
    return descriptor_row
  end

  #
  # Insert
  #
  def self.insert(*args)
    descriptor_row = nil
    begin
      section_id = args[0]
      descriptor_name = args[1]
      descriptor_row = self.new("field_name" => descriptor_name, "section_id" => section_id)
      descriptor_row.save()
      puts "[DEBUG] INSERTED descriptor #{descriptor_name}, Id = #{descriptor_row.id}"
    rescue Exception => e
      puts "Exception inserting Descriptor"
      puts self.inspect
      puts e.message
    end
    return descriptor_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    descriptor_row = nil
    begin
      section_id = args[0]
      descriptor_name = args[1]
      descriptor_row = self.select(section_id, descriptor_name)
      if (descriptor_row.nil?)
        descriptor_row = self.insert(section_id, descriptor_name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Descriptor"
      puts self.inspect
      puts e.message
    end
    return descriptor_row     
  end

  #
  # Delete from name
  #
  def self.delete_from_name(*args)
    descriptor_row = nil    
    begin
      section_id = args[0]
      descriptor_name = args[1]
      descriptor_row = self.select(section_id, descriptor_name)
      unless (descriptor_row.nil?)
        self.delete(descriptor_row.id)
        puts "[DEBUG] DELETED descriptor #{descriptor_name}, Id = #{descriptor_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Descriptor"
      puts self.inspect
      puts e.message
    end
    return descriptor_row
  end  
  
end
