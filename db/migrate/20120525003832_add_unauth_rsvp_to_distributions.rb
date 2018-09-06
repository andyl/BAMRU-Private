class AddUnauthRsvpToDistributions < ActiveRecord::Migration[5.2]
  def change
    add_column :distributions, :unauth_rsvp_token,      :string
    add_column :distributions, :unauth_rsvp_expires_at, :datetime
    add_index  :distributions, :unauth_rsvp_token,      :unique => true
  end
end
