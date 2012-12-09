BB.Helpers.CnTbodyReportsHelpers =
  genReportsRows: ->
    authorReport = (link) ->
      memId  = link.get('member_id')
      member = BB.members.get(memId)
      name   = member.shortName()
      "<a href='/members/#{memId}'>#{name}</a>"
    reportTitle = (link) ->
      title = link.get('title')
      id    = link.get('id')
      "<a href='/event_reports/#{id}' target='_blank'>#{title}</a>"
    editReport = (link) ->
      linkClass = switch link.get('typ')
        when 'smso_aar' then "editReportSMSO"
        else "editReport"
      "<a href='#' class='#{linkClass}' data-id='#{link.get('id')}'>Edit</a>"
    reportTyp = (link) ->
      typ = link.get('typ')
      switch typ
        when "smso_aar" then "SMSO AAR"
        else "UNKNOWN"
    deleteReport = (link) ->
      "<a href='#' class='deleteReport' data-id='#{link.get('id')}'>Delete</a>"
    reportActions = (link) ->
      if link.get('typ') == "smso_aar"
        "#{editReport(link)}"
      else
        "#{editReport(link)} | #{deleteReport(link)}"
    rowHtml = (link) ->
      """
      <tr>
        <td>#{reportTyp(link)}</td>
        <td>#{reportTitle(link)}</td>
        <td><nobr>#{link.get('updated_at')?.split('T')[0]}</nobr></td>
        <td align='center'><nobr>#{reportActions(link)}</nobr></td>
       </tr>
       """
    links = _.map @eventReports.models, (link) -> rowHtml(link)
    links.join('\n')
