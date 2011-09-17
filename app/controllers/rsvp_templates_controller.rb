class RsvpTemplatesController < ApplicationController

  before_filter :authenticate_member!

  def new
    @template = RsvpTemplate.new
  end

  def index
    @templates = RsvpTemplate.order('position ASC').all
  end

  def create
    RsvpTemplate.create!(params[:rsvp_template])
    redirect_to rsvp_templates_path, :notice => "Created Template"
  end

  def edit
    @template = RsvpTemplate.find(params[:id])
  end

  def destroy
    template = RsvpTemplate.find(params['id'])
    template.destroy
    redirect_to(rsvp_templates_path, :notice => "Deleted Template")
  end

  def update
    template = RsvpTemplate.find(params[:id])
    template.update_attributes(params['rsvp_template'])
    template.save
    redirect_to(rsvp_templates_path, :notice => "Updated Template")
  end

  def sort
    params['template'].each_with_index do |id, index|
      RsvpTemplate.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

end
