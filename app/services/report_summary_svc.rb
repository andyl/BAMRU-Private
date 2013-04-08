module FormatNums
  def prc
    self.to_s.reverse().split(//).inject() {|x,i| (x.gsub(/ /,"").length % 3 == 0 ) ? x + "," + i : x + i}.reverse()
  end
end

class Fixnum
  include FormatNums
end

class ReportSummarySvc

  attr_accessor :start, :finish

  def initialize(start = "", finish = "")
    @start  = start.blank? ? Time.now - 1.year : Time.parse(start)
    @finish = finish.blank? ? Time.now : Time.parse(finish)
    @ev_hrs = {}
  end

  def start_day;  day_gen(start);  end
  def finish_day; day_gen(finish); end

  def training_list;  @tl ||= Event.trainings.between(start, finish).all;   end
  def operation_list; @ol ||= Event.operations.between(start, finish).all;  end
  def meeting_list;   @ml ||= Event.meetings.between(start, finish).all;    end
  def community_list; @cl ||= Event.communities.between(start, finish).all; end

  def event_hours(event)
    return @ev_hrs[event.id] if @ev_hrs[event.id]
    periods = event.periods
    mins = periods.sum do |per|
      per.participants.all.sum {|par| par.report_minutes}
    end
    @ev_hrs[event.id] = (mins.to_f / 60).round
  end

  def cat_hours(list)
    list.sum {|ev| event_hours(ev)}
  end

  def summary_totals
    num_events = training_list.count + operation_list.count + meeting_list.count + community_list.count
    num_hours  = training_hours + operation_hours + meeting_hours + community_hours
    "#{num_events} Events (#{num_hours.prc} hours)"
  end

  def training_hours;  @th ||= cat_hours(training_list);  end
  def operation_hours; @oh ||= cat_hours(operation_list); end
  def meeting_hours;   @mh ||= cat_hours(meeting_list);   end
  def community_hours; @ch ||= cat_hours(community_list); end
  
  def training_header
    @thd ||= "#{training_list.count} Trainings (#{training_hours.prc} hours)"
  end
  
  def operation_header
    @ohd ||= "#{operation_list.count} Operations (#{operation_hours.prc} hours)"
  end
  
  def meeting_header
    @mhd ||= "#{meeting_list.count} Meetings (#{meeting_hours.prc} hours)"
  end
  
  def community_header
    @chd ||= "#{community_list.count} Community Events (#{community_hours.prc} hours)"
  end

  def summary_html
    <<-EOF
      #{training_header},
      #{operation_header},
      #{meeting_header},
      #{community_header}
    EOF

  end

  def event_detail(event_list)
    list = event_list.sort_by {|x| -1 * event_hours(x)}.map do |ev|
      <<-EOF
      <tr>
        <td style='border: 0px solid white;'>#{event_hours(ev).prc} hours</td>
        <td style='border: 0px solid white;'>#{ev.start.strftime("%b %d")}</td>
        <td style='border: 0px solid white;'>
          <a href='/events/#{ev.id}' target='_blank'>#{ev.title}</a>
        </td>
      </tr>
      EOF
    end.join
    "<table class='xTable' style='font-size: 10px;'>#{list}</table>"
  end

  private

  def day_gen(date); date.strftime("%Y-%m-%d"); end

end