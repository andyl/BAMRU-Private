BB.Helpers.CnTbodyReferencePhotosHelpers =
  genPhotoRows: ->
    authorLink = (photo) ->
      memId  = photo.get('member_id')
      member = BB.members.get(memId)
      name   = member.shortName()
      "<a href='/members/#{memId}'>#{name}</a>"
    editLink = (photo) ->
      "<a href='#' class='editPhoto' data-id='#{photo.get('id')}'>Edit</a>"
    deleteLink = (photo) ->
      "<a href='#' class='deletePhoto' data-id='#{photo.get('id')}'>Delete</a>"
    rowHtml = (photo) ->
      """
      <tr>
        <td><img style='display:block' src="#{photo.get('icon_url')}"/></td>
        <td>#{photo.get('caption')}</td>
        <td><nobr>#{authorLink(photo)}</nobr></td>
        <td><nobr>#{photo.get('updated_at')?.split('T')[0]}</nobr></td>
        <td align='center'><nobr>#{editLink(photo)} | #{deleteLink(photo)}</nobr></td>
       </tr>
       """
    photos = _.map @eventPhotos.models, (photo) -> rowHtml(photo)
    photos.join('\n')
