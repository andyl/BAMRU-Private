module FormatNums
  def prc
    self.to_s.reverse().split(//).inject() {|x,i| (x.gsub(/ /,"").length % 3 == 0 ) ? x + "," + i : x + i}.reverse()
  end
end

class Fixnum
  include FormatNums
end

module ReportHelpers

  def start_day;  day_gen(start);  end
  def finish_day; day_gen(finish); end

  def trn_lst; Event.trainings.between(start, finish)    ; end
  def opr_lst; Event.operations.between(start, finish)   ; end
  def mtg_lst; Event.meetings.between(start, finish)     ; end
  def com_lst; Event.communities.between(start, finish)  ; end

  def training_list;  @tl ||= trn_lst.all; end
  def operation_list; @ol ||= opr_lst.all; end
  def meeting_list;   @ml ||= mtg_lst.all; end
  def community_list; @cl ||= com_lst.all; end

  def num_events
    training_list.count + operation_list.count + meeting_list.count + community_list.count
  end

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

  def training_hours;  @th ||= cat_hours(training_list);  end
  def operation_hours; @oh ||= cat_hours(operation_list); end
  def meeting_hours;   @mh ||= cat_hours(meeting_list);   end
  def community_hours; @ch ||= cat_hours(community_list); end

  def total_hours
    result = training_hours + operation_hours + meeting_hours + community_hours
    result.prc
  end
  
  private

  def day_gen(date); date.strftime("%Y-%m-%d"); end

end