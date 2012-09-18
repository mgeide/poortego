
module PoortegoCommands
  
  #
  # Export command logic
  #
  def cmd_poortego_export(*args)
    if (args.length < 1)
      cmd_poortego_export_help
      return
    end
    
    format_type = args[0]
    case format_type
    when "-h", "-?"
      cmd_poortego_export_help
      return
    when "graphviz"
      require "poortego/exporters/graphviz_exporter"
      gv_generator = GraphvizExporter.new(@poortego_session.session_values)

      if (args.include?(1)) # Pass export path as optional argument 2
        print_status("Exporting to #{args[1]}")
        gv_generator.export(args[1])
      else
        gv_generator.export()
      end
    else
      print_error("Invalid export format.")
      return
    end
    
    
  end
  
  #
  # Export command help
  #
  def cmd_poortego_export_help(*args)
    print_status("Export things at and below current selection into a format.")
    print_status("Command    : export")
    print_status("Description: export things that are at and below the current selection into another format.")
    print_status("Usage      : 'export <format>'")
  end
  
  
end
