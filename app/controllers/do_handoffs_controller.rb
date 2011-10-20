class DoHandoffsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @handoffs = DoHandoff.all
    @quarter = {
            :year      => params["year"].try(:to_i)    || Time.now.year,
            :quarter   => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
  end

  def create
    expire_fragment('footer-table')
    expire_fragment('member_index_table-all')
    expire_fragment('member_index_table-active')
    @org = Org.where(:name => "BAMRU").first
    if @org.update_attributes(params["org"])
      redirect_to do_assignments_path(@org), :notice => "Records Saved"
    else
      render "edit"
    end
    Member.set_do
  end
end
