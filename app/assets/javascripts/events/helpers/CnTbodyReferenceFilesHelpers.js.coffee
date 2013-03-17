BB.Helpers.CnTbodyReferenceFilesHelpers =
  genFileRows: ->
    authorLink = (file) ->
      memId  = file.get('member_id')
      member = BB.members.get(memId)
      name   = member.shortName()
      "<a href='/members/#{memId}'>#{name}</a>"
    editLink = (file) ->
      "<a href='#' class='editFile' data-id='#{file.get('id')}'>Edit</a>"
    deleteLink = (file) ->
      "<a href='#' class='deleteFile' data-id='#{file.get('id')}'>Delete</a>"
    rowHtml = (file) ->
      """
      <tr>
        <td><a href="/files/#{file.get('data_file_name')}" target="_blank">#{file.get('data_file_name')}</a></td>
        <td>#{file.get('caption')}</td>
        <td><nobr>#{authorLink(file)}</nobr></td>
        <td><nobr>#{file.get('updated_at')?.split('T')[0]}</nobr></td>
        <td align='center'><nobr>#{editLink(file)} | #{deleteLink(file)}</nobr></td>
       </tr>
       """
    files = _.map @eventFiles.models, (file) -> rowHtml(file)
    files.join('\n')
