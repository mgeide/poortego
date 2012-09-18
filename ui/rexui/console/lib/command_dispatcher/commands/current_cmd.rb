
module PoortegoCommands
  
  #
  # "Current" command logic
  #
  def cmd_poortego_current(*args)
    if (args.length > 0)
      cmd_poortego_current_help
    else
      # Display Dispatcher shared variables in shellinterface.rb
      tbl = Rex::Ui::Text::Table.new('Indent' => 4,
                                   'Columns' => ['Field',
                                                 'Value'   ])
     
      current_values = @poortego_session.get_session_values()
      current_values.each do |key,value|
        tbl << ["#{key} :", "#{value}"]
      end
                                                 
      puts "\n" + tbl.to_s + "\n"
    end
  end
  
  #
  # "Current" command help
  #
  def cmd_poortego_current_help(*args)
    print_status("Command    : current")
    print_status("Description: displays the current system variables related to the state of things.")
    print_status("Usage      : 'current'")
  end
  
end

