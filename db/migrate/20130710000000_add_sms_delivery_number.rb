class AddSmsDeliveryNumber < ActiveRecord::Migration

    def change

      add_column :outbound_mails, :sms_member_number,     :string
      add_column :outbound_mails, :sms_service_number,    :string
      add_index  :outbound_mails, :sms_member_number
      add_index  :outbound_mails, :sms_service_number

    end

end
