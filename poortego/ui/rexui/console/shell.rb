#!/usr/bin/env ruby

require 'rex'
require 'rex/ui'

module Poortego
module Console

class Shell

  DefaultPrompt     = "%undPoortego%clr"
  DefaultPromptChar = "%clr>"

  include Rex::Ui::Text::DispatcherShell  

  def initialize(prompt = DefaultPrompt, prompt_char = DefaultPromptChar, opts = {})

    current_dir = File.expand_path(File.dirname(__FILE__))
    require "#{current_dir}/lib/readline_compatible"
    require "#{current_dir}/lib/command_dispatcher"
    require "#{current_dir}/lib/shellinterface"

    self.jobs = Rex::JobContainer.new
    self.interface = Poortego::Console::ShellInterface.new 

    super(prompt, prompt_char, File.expand_path('~/.poortego/history')) # Initialize from Rex::Ui::Text:DispatcherShell

    input = Rex::Ui::Text::Input::Stdio.new
    output = Rex::Ui::Text::Output::Stdio.new

    init_ui(input,output)

    # This loads in the command dispatcher for "core" (lib/command_dispatcher/core.rb)
    enstack_dispatcher(CommandDispatcher::HomeDispatcher)

  end

  def stop
    super
  end

  attr_accessor :config
  attr_accessor :jobs
  attr_accessor :interface
end

end end
