require 'spec_helper'

describe MembersController do

  def valid_attributes
    {:user_name => "joe_smith", :password => "asdfqwer"}
  end

  before(:each) do
    controller.stub(:authenticate_member!).and_return true
  end

  describe "GET index" do
    it "assigns all members as @members" do
      member = Member.create! valid_attributes
      get :index2
      assigns(:members).should eq([member])
    end
  end

  describe "GET show" do
    it "assigns the requested member as @member" do
      member = Member.create! valid_attributes
      get :show, :id => member.id.to_s
      assigns(:member).should eq(member)
    end
  end

  describe "GET new" do
    it "assigns a new member as @member" do
      get :new
      assigns(:member).should be_a_new(Member)
    end
  end

  describe "GET edit" do
    it "assigns the requested member as @member" do
      member = Member.create! valid_attributes
      get :edit, :id => member.id.to_s
      assigns(:member).should eq(member)
    end
  end

  describe "POST create" do
    describe "with valid params" do
#      it "creates a new Member" do
#        expect {
#          post :create, :member => valid_attributes
#        }.to change(Member, :count).by(1)
#      end

#      it "assigns a newly created member as @member" do
#        post :create, :member => valid_attributes
#        assigns(:member).should be_a(Member)
#        assigns(:member).should be_persisted
#      end

#      it "redirects to the created member" do
#        post :create, :member => valid_attributes
#        response.should redirect_to(Member.last)
#      end
    end

    describe "with invalid params" do
#xx
      
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested member" do
#        member = Member.create! valid_attributes
#        # Assuming there are no other members in the database, this
#        # specifies that the Member created on the previous line
#        # receives the :update_attributes message with whatever params are
#        # submitted in the request.
#        Member.any_instance.should_receive(:update_attributes).with({:ham => 'KQED'})
#        put :update, :id => member.id, :member => {:ham => 'KQED'}
      end

      it "assigns the requested member as @member" do
        member = Member.create! valid_attributes
        put :update, :id => member.id, :member => valid_attributes
        assigns(:member).should eq(member)
      end

      it "redirects to the member" do
#        member = Member.create! valid_attributes
#        put :update, :id => member.id, :member => valid_attributes
#        response.should redirect_to(member_path(member))
      end
    end

    describe "with invalid params" do
      it "assigns the member as @member" do
        member = Member.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Member.any_instance.stub(:save).and_return(false)
        put :update, :id => member.id.to_s, :member => {}
        assigns(:member).should eq(member)
      end

      it "re-renders the 'edit' template" do
#        member = Member.create! valid_attributes
#        # Trigger the behavior that occurs when invalid params are submitted
#        Member.any_instance.stub(:update_attributes).and_return(false)
#        put :update, :id => member.id.to_s, :member => {}
#        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
#    it "destroys the requested member" do
#      member = Member.create! valid_attributes
#      expect {
#        delete :destroy, :id => member.id.to_s
#      }.to change(Member, :count).by(-1)
#    end

#    it "redirects to the members list" do
#      member = Member.create! valid_attributes
#      delete :destroy, :id => member.id.to_s
#      response.should redirect_to(members_url)
#    end
  end

end
