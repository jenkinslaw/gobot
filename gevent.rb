require File.dirname(__FILE__) + '/gclient.rb'
require 'json'

module Jenkins

  class ITCalendar 
    attr_reader :id

    def initialize
      @id = 'jenkinslaw.org_6qa5or8067ukkqs70dsf4bvpf4@group.calendar.google.com'
      @app = Jenkins::GoogleApp.new
      @calendar = @app.client.discovered_api('calendar', 'v3')
    end

    def addEvent(event)
      command = {
        :api_method => @calendar.events.insert,
        :parameters => { 'calendarId' => @id },
        :body => event,
        :headers => {'Content-Type' => 'application/json'},
      }

      @app.execute command
    end

    def deleteEvent(eventId)
      command = {
        :api_method => @calendar.events.delete,
        :parameters => { 'calendarId' => @id, 'eventId' => eventId },
      }
      @app.execute command
    end
  end

  class ITEvent
    attr_reader :timezone, :startDateTime, :endDateTime, :summary

    def initialize summary, body = ''
      datetime = DateTime.now
      @timezone = 'America/New_York'
      @startDateTime = @endDateTime = datetime.rfc3339
      @summary = summary
    end

    def getEvent
     event =  {
        'summary' => self.summary,
        'timezone' => self.timezone,
        'start' => { 'dateTime' => self.startDateTime },
        'end' => { 'dateTime' => self.endDateTime },
      }
     JSON.dump(event)
    end
  end

end

