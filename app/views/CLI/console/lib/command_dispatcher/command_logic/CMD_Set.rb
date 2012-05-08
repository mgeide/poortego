current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/CMD_functions"

class CMD_Set
  attr_accessor :driver

  include Rex::Ui::Text::DispatcherShell::CommandDispatcher

  #
  # Constructor
  #
  def initialize(driver)
    super
    
    self.driver = driver
  end
  
  #
  # "Set" command logic
  #
  def cmd_set(*args)

    type   = driver.interface.working_values["Current Selection Type"]
    object = driver.interface.working_values["Current Object"]
    
    if (args.length < 2)
      print_error("Set command takes a field/value parameter.")
      cmd_set_help()
      return
    end
    
    field = args[0]  
    value = args[1]
    
    # "type" is a special/rsvd field for entities and links
    if (field == 'type')
      if (type == 'entity')
        # Get type obj
        type_obj = EntityType.select(value)
        field    = 'entity_type_id'
        value    = type_obj.id
        # Set type fields
        type_fields = EntityTypeField.list(type_obj.id)
        type_fields.each do |type_field|
          field_obj = EntityField.select_or_insert(object.id, type_field.field_name)
          field_obj.save
          print_status("Including field #{type_field.field_name} into object #{object.title} as part of object type #{type_obj.title}.")
        end 
      elsif (type == 'link')
        # Get type obj
        type_obj = LinkType.select(value)
        field    = 'link_type_id'
        value    = type_obj.id
        # Set type fields
        type_fields = LinkTypeField.list(type_obj.id)
        type_fields.each do |type_field|
          field_obj = LinkField.select_or_insert(object.id, type_field.field_name)
          field_obj.save
          print_status("Including field #{type_field.field_name} into object #{object.title} as part of object type #{type_obj.title}.")
        end 
      else
        print_error("Set 'type' must be for an entity or a link object.")
        return
      end  
    end
    
    # Set attribute or field/descriptor if attribute does not exist
    if (object.respond_to?(field) == false)
      # Object field=value update failed, try others related
      case type
      when 'entity'  # Try Entity Fields
        field_obj = EntityField.select(object.id, field)
        unless (field_obj.nil?)
          field_obj.update_attributes('value' => value)
          field_obj.save
          print_status("Updated #{type} field #{field} to #{value}")
        end 
      when 'link'    # Try Link Fields
        field_obj = LinkField.select(object.id, field)
        unless (field_obj.nil?)
          field_obj.update_attributes('value' => value)
          field_obj.save
          print_status("Updated #{type} field #{field} to #{value}")
        end 
      when 'section' # Try Section Descriptor
        descr_obj = SectionDescriptor.select(object.id, field)
        unless (descr_obj.nil?)
          descr_obj.update_attributes('value' => value)
          descr_obj.save
          print_status("Updated #{type} field #{field} to #{value}")
        end 
      else
        print_error("Invalid: field #{field} does not exist for type #{type}")
        return
      end
    else
      object.update_attributes(field => value)  
      object.save 
      print_status("Updated #{field} to #{value}")
      set_prompt(driver)
    end
    
  end
  
  #
  # "Set" command help
  #
  def cmd_set_help(*args)
    print_status("Command    : set")
    print_status("Description: set a field/value pair for a selected thing.")
    print_status("Usage      : 'set <field> <value>'")
    print_status("Additional Details:")
    print status(" - Field 'type' is a special field for entities/links")
    print_status(" - Attempts will be made to set fields and descriptors")
  end
  
end