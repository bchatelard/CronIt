require 'terminal-notifier'
require './lib/cron_it.rb'

class Run < CronIt
  #every :day, :at => "12:30 am"

  run :launch

  def launch
    TerminalNotifier.notify("still running", :title => "Hehe !")
  end
end

##TerminalNotifier.notify("Wop", :title => "Example", :open => "mvim://open?url=file://#{File.expand_path("~/")}.tmp/#{name}.log")
