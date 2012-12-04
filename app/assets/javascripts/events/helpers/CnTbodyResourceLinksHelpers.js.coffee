BB.Helpers.CnTbodyMediaLinksHelpers =
  genLinkRows: ->
    authorLink = (link) ->
      memId  = link.get('member_id')
      member = BB.members.get(memId)
      name   = member.shortName()
      "<a href='/members/#{memId}'>#{name}</a>"
    pdfLink  = (link) ->
      url = link.get('backup_url')
      return "" unless url && url != "/link_backups/original/missing.png"
      " (<a href='#{url}' target='_blank'>pdf</a>)"
    editLink = (link) ->
      "<a href='#' class='editLink' data-id='#{link.get('id')}'>Edit</a>"
    deleteLink = (link) ->
      "<a href='#' class='deleteLink' data-id='#{link.get('id')}'>Delete</a>"
    rowHtml = (link) ->
      """
      <tr>
        <td><a target='_blank' href='#{link.get('site_url')}'>#{link.site()}</a>#{pdfLink(link)}</td>
        <td>#{link.get('caption')}</td>
        <td><nobr>#{authorLink(link)}</nobr></td>
        <td><nobr>#{link.get('updated_at')?.split('T')[0]}</nobr></td>
        <td align='center'><nobr>#{editLink(link)} | #{deleteLink(link)}</nobr></td>
       </tr>
       """
    links = _.map @eventLinks.models, (link) -> rowHtml(link)
    links.join('\n')

