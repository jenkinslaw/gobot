require 'minitest/autorun'
require "./gevent"
require 'yaml'

class TestEvent < Minitest::Test
  def setup
    @calendar = Jenkins::ITCalendar.new
    @event = Jenkins::ITEvent.new 'Test Event'
  end

  def test_Id
    id = 'jenkinslaw.org_6qa5or8067ukkqs70dsf4bvpf4@group.calendar.google.com'
    assert_equal id, @calendar.id
  end

  def test_ITEvent
      datetime = DateTime.now
      assert_equal @event.startDateTime, @event.endDateTime,
        'ITEvent start and end time are the same.'
      assert_equal @event.startDateTime, datetime.rfc3339,
        'ITEvent has the expected start time.'
      assert_equal @event.summary, 'Test Event',
        'ITEvent has the expected summary.'
  end

  def test_Event
    event = @event.getEvent
    expected = JSON.dump({
        'summary' => @event.summary,
        'timezone' => @event.timezone,
        'start' => { 'dateTime' => @event.startDateTime },
        'end' => { 'dateTime' => @event.endDateTime },
      })
    assert_equal event, expected,
      'ITEvent::getEvent() works as expected.'
  end

  def test_AddDeleteEvent
    event = @calendar.addEvent @event.getEvent
    assert event.key?('id'),
      'An event has been added to the IT Event Calendar.'

    if event.key? 'id'
      result = @calendar.deleteEvent event['id']
      assert_equal result.status, 204,
        'The event has been successfully deleteted from the IT Calendar.'
    end

  end
end

