require 'terminal-notifier'
require './lib/cron_it.rb'

class Run < PlanIt
  every :day, :at => "12:30 am"

  run :launch

  def launch
    TerminalNotifier.notify("still running", :title => "Hehe !")
  end
end

##TerminalNotifier.notify("Wop", :title => "Wtf", :open => "mvim://open?url=file://#{File.expand_path("~/")}.tmp/#{name}.log")
