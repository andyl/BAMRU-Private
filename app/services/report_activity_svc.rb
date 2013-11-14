require File.dirname(__FILE__) + '/report_helpers'

class ReportActivitySvc

  include ReportHelpers

  attr_accessor :start, :finish

  def initialize(start = "", finish = "")
    @start  = start.blank? ? Time.now - 1.year : Time.parse(start)
    @finish = finish.blank? ? Time.now : Time.parse(finish)
    @ev_hrs = {}
    @mem_par = {}
  end

  def periods_for(events)
    event_ids = events.pluck(:id)
    Period.where(event_id: event_ids)
  end

  def participants_for(periods)
    period_ids = periods.pluck(:id)
    Participant.where(period_id: period_ids)
  end

  # ----- participant_counts -----

  def participant_count(event_list)
    participants_for(periods_for(event_list)).count
  end
  
  def unit_opr_count; @uoc ||= participant_count opr_lst; end
  def unit_trn_count; @utc ||= participant_count trn_lst; end
  def unit_mtg_count; @umc ||= participant_count mtg_lst; end
  def unit_com_count; @ucc ||= participant_count com_lst; end

  def total_count
    result = unit_opr_count + unit_trn_count + unit_mtg_count + unit_com_count
    result.prc
  end

  # ----- participant hours -----

  def trn_p; @tp ||= Period.where(event_id: trn_lst.pluck(:id)); end
  def opr_p; @op ||= Period.where(event_id: opr_lst.pluck(:id)); end
  def mtg_p; @mp ||= Period.where(event_id: mtg_lst.pluck(:id)); end
  def com_p; @cp ||= Period.where(event_id: com_lst.pluck(:id)); end

  def par_for(per, mem)
    Participant.where(period_id: per.pluck(:id), member_id: mem.id)
  end

  def trn_m(mem); @mem_par["t#{mem.id}"] ||= par_for(trn_p, mem); end
  def opr_m(mem); @mem_par["o#{mem.id}"] ||= par_for(opr_p, mem); end
  def mtg_m(mem); @mem_par["m#{mem.id}"] ||= par_for(mtg_p, mem); end
  def com_m(mem); @mem_par["c#{mem.id}"] ||= par_for(com_p, mem); end
  def all_m(mem)
    @mem_par["a#{mem.id}"] ||= trn_m(mem) + opr_m(mem) + mtg_m(mem) + com_m(mem)
  end

  def participations(participant_list)
    participant_list.count
  end

  def participation_hrs(participant_list)
    mins = participant_list.reduce(0) do |acc, participant|
      acc + participant.report_minutes
    end
    (mins.to_f / 60).round
  end

  # ----- members -----

  def members
    memdata = Member.active.all.map do |mem|
      {
        id:   mem.id,
        name: mem.short_name,
        lname: mem.last_name,
        trn_cnt: participations(trn_m(mem)),
        opr_cnt: participations(opr_m(mem)),
        mtg_cnt: participations(mtg_m(mem)),
        com_cnt: participations(com_m(mem)),
        all_cnt: participations(all_m(mem)),
        trn_hrs: th = participation_hrs(trn_m(mem)),
        opr_hrs: oh = participation_hrs(opr_m(mem)),
        mtg_hrs: mh = participation_hrs(mtg_m(mem)),
        com_hrs: ch = participation_hrs(com_m(mem)),
        all_hrs: th + oh + mh + ch
      }
    end
    memdata.sort {|x,y| y[:all_hrs] <=> x[:all_hrs]}
  end


end