###
#
# LinkField ActiveRecord -
# Store name/value pairs associated with the Link
#                                           
# Attributes:                               
#  name:      name of link field               
#  value:     value associated with field      
#  link_id:   references link               
#                                           
###
class LinkField < ActiveRecord::Base
  validates :name, :presence => true
  validates :link_id, :presence => true

  belongs_to :link  # Reference to link
                    # Links can have multiple fields
                    
  #
  # List
  #
  def self.list(*args)
    field_rows = Array.new()
    begin
      link_id = args[0]
      field_rows = self.find(:all, :conditions => { :link_id => link_id }, :order => "name ASC")
    rescue Exception => e
      puts "Exception listing fields"
      puts self.inspect
      puts e.message
    end
    return field_rows
  end
  
  #
  # Select
  #
  def self.select(*args)
    field_row = nil
    begin
      link_id = args[0]
      name    = args[1]
      field_row = self.find(:first, :conditions => { :name => name, :link_id => link_id })
    rescue Exception => e
      puts "Exception selecting field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
  #
  # Insert
  #
  def self.insert(*args)
    field_row = nil
    begin
      link_id = args[0]
      name    = args[1]
      field_row = self.new("link_id" => link_id, "name" => name)
      field_row.save()
      puts "[DEBUG] INSERTED field with Name = #{name}, Id = #{field_row.id}"
    rescue Exception => e
      puts "Exception inserting Field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    field_row = nil
    begin
      link_id = args[0]
      name    = args[1]
      field_row = self.select(link_id, name)
      if (field_row.nil?)
        field_row = self.insert(link_id, name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Type"
      puts self.inspect
      puts e.message
    end
    return field_row    
  end
  
  #
  # Delete from name
  #
  def self.delete_from_name(*args)
    field_row = nil
    begin
      link_id = args[0]
      name    = args[1]
      field_row = self.find(:first, :conditions => { :link_id => link_id, :name => name })
      unless (field_row.nil?)
        self.delete(field_row.id)
        puts "[DEBUG] DELETED field with name #{name}, Id = #{id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Field"
      puts self.inspect
      puts e.message
    end
    return field_row
  end
  
end
