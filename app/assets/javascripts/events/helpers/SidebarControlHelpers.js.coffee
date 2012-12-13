BB.Helpers.SidebarControlHelpers =

  # ----- date select -----

  defaultStart  : ->
    @start || moment().subtract('months', 4).strftime("%b-%Y")

  defaultFinish : ->
    @finish || moment().add('months', 12).strftime("%b-%Y")

  firstYear : ->
    window.firstEvent = BB.Collections.events.min (event) ->
      event.get('start')?.split('-')[0]
    eval(firstEvent.get('start').split('-')[0])

  lastYear : ->
    window.lastEvent = BB.Collections.events.max (event) ->
      event.get('start')?.split('-')[0]
    eval(lastEvent.get('start').split('-')[0])

  dateRange: (defaultDate, knockoutDate) ->
    range = (year for year in [@firstYear()..@lastYear()])
    dates = _.map(range, (year) -> mDate("Jan-#{year}")).concat(mDate(defaultDate))
    sortedDates = _.sortBy(dates, (date) -> date.strftime("%y%m"))
    stringDates = _.map(sortedDates, (date) -> date.strftime("%b-%Y"))
    knockoutDates = _.select(stringDates, (date) -> date != knockoutDate)
    uniqDates   = _.uniq(knockoutDates, true)
    uniqDates

  eventRangeSelect: (defaultDate, knockoutDate) ->
    options = _.map @dateRange(defaultDate, knockoutDate), (date) ->
      selected = if date == defaultDate then " selected" else ""
      "<option value='#{date}' #{selected}>#{date}</option>"
    options.join()
    "#{options.join()}"

  # ----- checkboxes -----

  checkBoxParams:
    "meeting":
      heading: "<b>M</b>eetings"
      comment: "General Mtngs, BOD"
    "training":
      heading: "<b>T</b>rainings"
      comment: "Scheduled training"
    "operation":
      heading: "<b>O</b>perations"
      comment: "Live callouts"
    "community":
      heading: "<b>C</b>ommunity"
      comment: "Support for SMSO/MRA/etc."
#    "social":
#      heading: "<b>S</b>ocial"
#      comment: "Non-official, just for fun"

  checkedVal: (name) ->
    if eval("this.#{name}") then " checked" else ""

  genRow: (name, params) ->
    heading = params[name].heading
    comment = params[name].comment
    """
    <tr>
      <td>
        <nobr>
          <input type="checkbox" class='typCk' name='#{name}' id='#{name}-id' #{@checkedVal(name)}>
          <label for='#{name}-id'>#{heading}</label>
        <nobr>
      </td>
      <td style='font-size: 8pt'>
        #{comment}
      </td>
    </tr>
    """

  genAllRows: ->
    rows = _.map Object.keys(@checkBoxParams), (name) => @genRow(name, @checkBoxParams)
    rows.join('\n')



