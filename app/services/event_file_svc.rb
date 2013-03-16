class EventFileSvc

  def self.create(params)
    @member_id = params["member_id"]
    @event_id  = params["event_id"]
    @data      = params["data"]
    @filepath  = params["filepath"]
    @caption   = params["caption"]
    gen_event_file
  end

  def gen_event_file
    df_obj = gen_data_file
    opts = {
        data_file_id: df_obj.id,
        event_id:     @event_id,
        caption:      @caption
    }
    EventFile.create opts
  end

  private

  def gen_data_file
    DataFile.create(data: @data || File.new(@filepath), member_id: @member_id)
  end

end

