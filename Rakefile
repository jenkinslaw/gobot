require 'rake/testtask'

task :default => [:test]

# Add a restart server event to Live Site IT Calendar.
task :add_restart_event do
  event = Jenkins::ITEvent.new 'Live Site - Restarted Server.'
  calendar = Jenkins::ITCalendar.new
  calendar.addEvent @event.getEvent
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



