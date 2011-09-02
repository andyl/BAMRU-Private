class UnitCertsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @fragment_type = cookies['rsa_show'] == 'true' ? "all" : "active"
    unless fragment_exist?(:fragment => "unit_certs_table-#{@fragment_type}")
      if cookies['rsa_show'] == 'true'
        @members = Member.order_by_role_score.all
      else
        @members = Member.order_by_role_score.active
      end
    end
  end
end
