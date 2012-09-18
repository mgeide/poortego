
  #
  # Set prompt
  #
  ## TODO: distinguish msf prompt from cli
  def set_prompt(driver)
     type = @poortego_session.session_values["Current Selection Type"]
     if (type == 'none')
       driver.update_prompt("")
     else
       name = @poortego_session.session_values["Current Object"].title
       driver.update_prompt("%undpoortego%clr (%bld%red"+type+":"+name+"%clr) ", ">", true)
       #driver.update_prompt("%und #{mod.type}(%bld%red#{mod.shortname}%clr) ", prompt_char, true)
     end
  end