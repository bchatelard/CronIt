require './lib/cron_it.rb'
require 'terminal-notifier'
require 'github_api'
require 'yaml'
require 'time'

TIME = 5.minutes

class GithubDeamon < CronIt
  every TIME
  run :launch

  def initialize
    credentials = YAML.load_file("config/credentials.yml")[:github]
    @github = Github.new :oauth_token => credentials[:token]
    throw "not authenticated #{@github.inspect}" unless @github.authenticated?
    @github.user = @github.users.get
  end

  def launch
    now = Time.now
    e = []
    @github.orgs.list @github.user.login do |org|
      e += @github.activity.events.user_org(@github.user.login, org.login)
    end
    e += @github.activity.events.list_user_received @github.user.login
    e = e.find_all do |f|
      t = now - DateTime.iso8601(f.created_at).to_time
      t.to_i < TIME
    end
    e.reverse.each do |event|
      case event.type
        when 'WatchEvent'
          TerminalNotifier.notify("##{event.repo.name} - @#{event.actor.login}", :title => "Github - Watch", :open => event.repo.url.sub('api.', '').sub('repos/', ''))
        when 'ForkEvent'
          TerminalNotifier.notify(event.payload.forkee.description, :title => "Github - Fork", :subtitle => "##{event.repo.name} - @#{event.actor.login}", :open => event.payload.forkee.html_url)
        when 'FollowEvent'
          TerminalNotifier.notify("@#{event.actor.login} -> ##{event.payload.target.login}", :title => "Github - Follow", :open => event.payload.target.html_url)
        when 'GistEvent'
          TerminalNotifier.notify(event.payload.gist.description, :title => "Github - Gist", :subtitle => "gist: ##{event.payload.gist.id} @#{event.actor.login}", :open => event.payload.gist.html_url)
        when 'PushEvent'
          msg = event.payload.commits.map {|c| c.message }.join(', ')
          TerminalNotifier.notify(msg, :title => "Github - Push", :subtitle => "#{event.repo.name} @#{event.actor.login}", :open => event.repo.url.sub('api.', '').sub('repos/', ''))
        else
          TerminalNotifier.notify("Unknown event", :title => "Github - #{event.type}")
      end
    end
  end
end

##TerminalNotifier.notify("Wop", :title => "Wtf", :open => "mvim://open?url=file://#{File.expand_path("~/")}.tmp/#{name}.log")
