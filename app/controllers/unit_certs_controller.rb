class UnitCertsController < ApplicationController

  before_filter :authenticate_member!

  def index
    if params['refresh'] == 'true'
      expire_fragment("member_index_table-#{current_member.id}")
      expire_fragment("unit_certs_table-#{current_member.id}")
      expire_fragment("unit_avail_ops_table-#{current_member.id}")
    end
    unless fragment_exist?(:fragment => "unit_certs_table-#{current_member.id}")
      if cookies['rsa_show'] == 'true'
        @members = Member.order_by_role_score.all
      else
        @members = Member.order_by_role_score.active
      end
    end
  end
end
