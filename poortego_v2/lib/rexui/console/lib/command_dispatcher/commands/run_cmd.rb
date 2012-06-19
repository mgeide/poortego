module Commands
  
   #
  # Run command logic
  #
  def cmd_run(*args)
    if ((args[0] == nil) or (args[0] == 'help'))
      cmd_run_help
      return
    end
    
    transform_full_path = "#{@transform_directory}#{args[0]}"
    if ((File.exists?(transform_full_path)) == true)
      # Scopes: project, section, entity, link
      scope = driver.interface.working_values["Current Selection Type"]
      case scope
      when 'entity'
        # See: http://ctas.paterva.com/view/Specification#Input_.28Maltego_GUI_-.3E__external_program.29
        # Maltego takes two arguments: EntityName and Fields
        transform_argument_one = driver.interface.working_values["Current Entity"].title
        transform_argument_two = '';
        
        entity_fields = PoortegoEntityField.list(driver.interface.working_values["Current Entity"].id)
        entity_fields.each {|entity_field|
          arg_name  = "#{entity_field.name}".gsub(/\#/, '\#')
          arg_value = "#{entity_field.value}".gsub(/\#/, '\#') 
          transform_argument_two = "#{transform_argument_two}#{arg_name}=#{arg_value}#" 
        }
        transform_argument_two.sub!(/\#$/, '')
        
        #transform_cmd = "/home/missile/.rvm/rubies/ruby-1.9.3-head/bin/ruby #{transform_full_path} #{transform_argument_one} #{transform_argument_two}"
        #transform_cmd = 'ls -la'
        transform_cmd = "#{transform_full_path} #{transform_argument_one} #{transform_argument_two}"
        status = POpen4::popen4(transform_cmd) do |stdout, stderr, stdin, pid|
          stdin.close

          puts "[PID] #{pid}"
          result_str = "#{stdout.read.strip}"
          puts "[STDOUT] #{result_str}"
          puts "[STDERR] #{stderr.read.strip}"
          
          puts "status     : #{ status.inspect }"
          #puts "exitstatus : #{ status.exitstatus }" 
          
          response_obj = PoortegoTransformResponseXML.new(result_str)
          
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
      when 'section'
      when 'project'
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
  def cmd_run_help(*args)
    print_line "Usage: run <transform>"
    print_line
  end
  
  #
  # Tab completion for connect command
  #
  def cmd_run_tabs(str, words)
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