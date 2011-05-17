class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
  end

  def test
  end
end
