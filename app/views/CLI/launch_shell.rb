#!/usr/bin/env ruby

current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/console/shell"

begin
   FileUtils.mkdir_p(File.expand_path('~/.poortego'))
   Poortego::Console::Shell.new(Poortego::Console::Shell::DefaultPrompt,
                                        Poortego::Console::Shell::DefaultPromptChar,{'config' => nil}).run
rescue Interrupt
end

