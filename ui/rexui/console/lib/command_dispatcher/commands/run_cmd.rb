

module PoortegoCommands
  
  require 'popen4'
  
  #
  # Run command logic
  #
  def cmd_poortego_run(*args)
    if ((args[0] == nil) or (args[0] == 'help'))
      cmd_poortego_run_help
      return
    end
    
    transform_full_path = "#{ENV['POORTEGO_LOCAL_BASE']}/poortego/transforms"
    
    ####
    # TESTING PURPOSES:
    # Ignore the argument, and just kick off a fixed transform to run
    # In this case it is the autotype_transform which will automatically
    # set the entity/link type based on the entity/link values if the
    # entity/link type is not already set
    ####
    #transform_script = "#{transform_full_path}/any_type/autotype_transform.rb"
    
    # TODO: transform_script should be defined from args[0]
    transform_script_name = args[0]
    transform_script      = "#{transform_full_path}/#{transform_script_name}" 
    
    ## TODO: or transform_script could be "ALL"
    
    if (transform_script == 'ALL')
    
          #
          # TODO: logic to handle "run all" transforms to recurse through results
          #  - need to also have a recursion depth set
          #
    
    elsif ((File.exists?(transform_script)) == true)
        
      # Scopes: project, section, entity, link
      scope = @poortego_session.session_values["Current Selection Type"]
      case scope
      when 'entity'
      
        ## Transform run in entity scope
      
        # See: http://ctas.paterva.com/view/Specification#Input_.28Maltego_GUI_-.3E__external_program.29
        # Maltego takes two arguments: EntityName and Fields
        transform_argument_one = @poortego_session.session_values["Current Entity"].title
        transform_argument_two = 'entity#';
        
        unless (@poortego_session.session_values["Current Entity"].entity_type_id.nil?)
          entity_type = PoortegoEntityType.find(@poortego_session.session_values["Current Entity"].entity_type_id)
          unless (entity_type.nil?)
            transform_argument_two << "entityType=#{entity_type.title}#"
          end
        end   
        
        entity_fields = PoortegoEntityField.list(@poortego_session.session_values["Current Entity"].id)
        entity_fields.each {|entity_field|
          arg_name  = "#{entity_field.name}".gsub('#', '%P_ESC%')  # Escape the delimiter # (convert to %P_ESC%)
          arg_value = "#{entity_field.value}".gsub('#', '%P_ESC%')
          if ((!arg_value.nil?) && (arg_value != ''))  # Don't pass fields that don't have a value
            transform_argument_two << "#{arg_name}=#{arg_value}#"
          end 
        }
        
        # Normalize / Sanitize the arguments
        transform_argument_one.gsub!("'", "\\'")
        transform_argument_two.gsub!("'", "\\'")
        transform_argument_two.sub!(/\#$/, '')
        
        #transform_cmd = "/home/missile/.rvm/rubies/ruby-1.9.3-head/bin/ruby #{transform_full_path} #{transform_argument_one} #{transform_argument_two}"
        #transform_cmd = 'ls -la'
        transform_cmd = "#{transform_script} '#{transform_argument_one}' '#{transform_argument_two}'"
        puts "[DEBUG] Running transform commnad: #{transform_cmd}"
        
        status = POpen4::popen4(transform_cmd) do |stdout, stderr, stdin, pid|
          stdin.close

          puts "[PID] #{pid}"
          result_str = "#{stdout.read.strip}"
          puts "[STDOUT] #{result_str}"
          puts "[STDERR] #{stderr.read.strip}"
          
          puts "status     : #{ status.inspect }"
          #puts "exitstatus : #{ status.exitstatus }" 
          
          require "poortego/lib/core/poortego_transform/poortego_transform_responseXML"
          response_obj = PoortegoTransformResponseXML.new(@poortego_session.session_values["Current Project"].id,
                                                          @poortego_session.session_values["Current Section"].id,
                                                          result_str)
             
          
          ## If the response isn't valid, then return
          unless (response_obj.validated)
            puts "[ERROR] Poortego Transform Response XML was invalid!"
            return
          end
          
          transform_result = response_obj.transform 
          ## TODO: move the below transform result logic into the transform file
          ## since this will be called from other things beyond the CLI run command
          
          ## Process newly resulting entities
            ## NOTE: have not made it into the below loop, everything so far is in poortego_transform_responseXML
          transform_result.responseEntities.each do |transform_entity|
            puts "[DEBUG] inside cmd_run loop that processes responseEntities"
            puts "[DEBUG] processing entity: #{transform_entity.inspect}"
            response_entity = PoortegoEntity.new()
            
            ## Title
            if (transform_entity.attributes.include?['title'])
              response_entity.title = transform_entity.attributes['title']
            else
              puts "[ERROR] processing transofrm response entity, no title given"
            end
            
            ## Type
            if (transform_entity.attributes.include?['type'])
              entity_type = PoortegoEntityType.find(:first, :conditions => { :title => transform_entity.attributes['type'] })
              if (entity_type.nil?)
                puts "[ERROR] entity type #{transform_entity.attributes['type']} does not exist."
                puts "Must manually create, or modify run_cmd.rb handler to automatically create type."
                ## TODO? insertion of this new type, or assume that it is an error
              end
              if (entity_type.id > 0)
                puts "[DEBUG] Updating entity type based on transform."
                response_entity.type_id = entity_type.id
              end
            end
            
            ## TODO: Handle inserting new entities versus updated existing entities
            
            transform_entity.additionalFields.each do |field|
            end
              
          end
          
          ## Process result links
          transform_result.responseLinks.each do |transform_link|
            transform_link.attributes.each do |attribute|
            end
            transform_link.additionalFields.each do |field|
            end   
          end
          
          ## Process result messages
          transform_result.responseMessages.each do |message|
            puts "[#{message.type}: #{message.title}] #{message.body}"  
          end
          
          #(response_obj.maltego_transform).resultEntities.each {|entity|
          #  puts "Type #{entity.entityType} Value #{entity.value}" 
            ## Left off here:
            ## Example of running from_domain-to_ip transform for google.com is:
            ## Type CNAME Value www.l.google.com
            
            ## TODO: create entity with title=value
            ## TODO: need to create type detection and easier way of defining entity type
            ## TODO: recurse, e.g., return CNAME, and CNAME has A RCDs
        end
        
      when 'link'
      
        ## TODO: transform run in link scope
      
      when 'section'
      
        ## TODO: transform run in section scope
      
      when 'project'
      
        ## TODO: transform run in project scope
      
      else
        print_error("Invalid transform scope: #{scope}")
        return
      end
    else
      print_error("Transform does not exist: #{transform_full_path}")
    end 
  end
  
  #
  # "Run" command help (TODO)
  #
  def cmd_poortego_run_help(*args)
    print_line "Usage: run <transform>"
    print_line
  end
  
  #
  # Tab completion for connect command
  #
  def cmd_poortego_run_tabs(str, words)
    return [] if words.length > 1
    res = %w{ help }
    Dir.foreach(@transform_directory) do |transform_file|
      unless (transform_file =~ /^\./)
        res.push(transform_file)
      end
    end
    return res
  end
  
end

