require 'rake/testtask'
require File.dirname(__FILE__) + '/gevent.rb'

task :default => [:test]

# Add a restart server event the IT Calendar.
task :add_restart_event do
  Rake::Task[:add_event].invoke('Live Site - Restarted Server.')
end

# Add arbitrary events to IT Calendar.
task :add_event, :message do |t, args|
  message = args[:message]
  event = Jenkins::ITEvent.new "#{message}"
  calendar = Jenkins::ITCalendar.new
  calendar.addEvent event.getEvent
end

# Install/Uninstall gobot task.
task :install => :create_gobot_symlink do
  puts 'Installed gobot.'
end

task :create_gobot_symlink do
  gobot = File.dirname(__FILE__) + '/bin/gobot.sh'
  File.symlink(gobot, '/usr/bin/gobot')
end

task :uninstall => :remove_gobot_symlink do
  puts 'Uninstalled gobot.'
end 

task :remove_gobot_symlink do
  if File.symlink? '/usr/bin/gobot'
    File.delete '/usr/bin/gobot'
  end
end

Rake::TestTask.new do |t|
    t.pattern = 'tests/*.rb'
end



