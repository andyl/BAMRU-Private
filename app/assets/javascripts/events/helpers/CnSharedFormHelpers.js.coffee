BB.Helpers.CnSharedFormHelpers =

  fSelectTyp: ->
    selected = (target) => if @typ == target then " SELECTED " else ''
    """
      <select id='typSelect' name='typ'>
        <option #{selected('meeting')}   value='meeting'>Meeting</options>
        <option #{selected('operation')} value='operation'>Operation</options>
        <option #{selected('training')}  value='training'>Training</options>
        <option #{selected('community')} value='community'>Community</options>
        <option #{selected('social')}    value='social'>Social</options>
      </select>
    """

  fAllDay: ->
    checked = if @all_day then 'checked' else ''
    lbl = "<label for='ckAllDay'>All day?</label>"
    box = "<input id='ckAllDay' class='formCheck' type='checkbox' name='all_day' value='true' #{checked}>"
    "#{lbl} #{box}"

  fPublished: ->
    checked = if @published then 'checked' else ''
    lbl = "<label for='ckPublished'>Published?</label>"
    box = "<input id='ckPublished' class='formCheck' type='checkbox' name='published' value='true' #{checked}>"
    "#{lbl} #{box}"

  fLeaders: ->
    if @leaders == "" then "TBA" else @leaders

  fLocation: ->
    if @location == "" then "TBA" else @location

  fStart: ->
    return @start unless @all_day
    @start.split(' ')[0] if @start

  fFinish: ->
    return @finish unless @all_day
    @finish.split(' ')[0] if @finish