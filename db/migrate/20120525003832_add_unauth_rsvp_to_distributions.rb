class AddUnauthRsvpToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :unauth_rsvp_token,      :string
    add_column :distributions, :unauth_rsvp_expires_at, :datetime
    add_index  :distributions, :unauth_rsvp_token,      :unique => true
  end
end
