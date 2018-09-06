class AddAlertSubscription < ActiveRecord::Migration[5.2]

    def change

      create_table :alert_subscriptions do |t|
        t.string    :event_typ
        t.string    :role_typ
        t.timestamps
      end

    end

end
