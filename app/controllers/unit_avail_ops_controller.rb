class UnitAvailOpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @fragment_type = cookies['rsa_show'] == 'true' ? "all" : "active"
    unless fragment_exist?(:fragment => "unit_avail_ops_table-#{@fragment_type}")
      if cookies['rsa_show'] == 'true'
        @members = Member.order_by_typ_score.all
      else
        @members = Member.order_by_typ_score.active
      end
    end
  end
end
