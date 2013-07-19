require 'rake/testtask'

task :default => [:test]

# Add a restart server event to Live Site IT Calendar.
task :add_restart_event do
  event = Jenkins::ITEvent.new 'Live Site - Restarted Server.'
  calendar = Jenkins::ITCalendar.new
  calendar.addEvent @event.getEvent
end

Rake::TestTask.new do |t|
    t.pattern = "tests/*.rb"
end


