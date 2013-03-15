BB.Helpers.CnTbodyReferenceFilesHelpers =
  genFileRows: ->
    authorLink = (link) ->
      memId  = link.get('member_id')
      member = BB.members.get(memId)
      name   = member.shortName()
      "<a href='/members/#{memId}'>#{name}</a>"
    editLink = (link) ->
      "<a href='#' class='editLink' data-id='#{link.get('id')}'>Edit</a>"
    deleteLink = (link) ->
      "<a href='#' class='deleteLink' data-id='#{link.get('id')}'>Delete</a>"
    rowHtml = (link) ->
      """
      <tr>
        <td><a href="/files/#{link.get('data_file_name')}" target="_blank">#{link.get('data_file_name')}</a></td>
        <td>#{link.get('caption')}</td>
        <td><nobr>#{authorLink(link)}</nobr></td>
        <td><nobr>#{link.get('updated_at')?.split('T')[0]}</nobr></td>
        <td align='center'><nobr>#{editLink(link)} | #{deleteLink(link)}</nobr></td>
       </tr>
       """
    links = _.map @eventFiles.models, (link) -> rowHtml(link)
    links.join('\n')
