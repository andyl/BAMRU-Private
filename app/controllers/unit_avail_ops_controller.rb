class UnitAvailOpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    if params['refresh'] == 'true'
      expire_fragment("member_index_table-#{current_member.id}")
      expire_fragment("unit_certs_table-#{current_member.id}")
      expire_fragment("unit_avail_ops_table-#{current_member.id}")
    end
    unless fragment_exist?(:fragment => "unit_avail_ops_table-#{current_member.id}")
      if cookies['rsa_show'] == 'true'
        @members = Member.order_by_last_name.all
      else
        @members = Member.order_by_last_name.active
      end
    end
  end
end
