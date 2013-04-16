###
This is jQuery code that manages the
table sorting on the unit_certs/index page.

Table sorter plugin at: http://tablesorter.com
###

# for debugging
showCoords = (coords, d = {}) ->
  round = (input) -> Math.round(input)
  msg = """
    x:#{round coords.x}<br/>
    y:#{round coords.y}<br/>
    w:#{round coords.w}<br/>
    h:#{round coords.h}<br/>
    bx:#{round boundx}<br/>
    by:#{round boundy}<br/>
    d.Width :#{d.Width}<br/>
    d.Height:#{d.Height}<br/>
    d.MarginLeft:#{d.MarginLeft}<br/>
    d.MarginTop :#{d.MarginTop}<br/>
  """
  $('#coordDisp').html(msg)

# Create variables (in this scope) to hold the API and image size
jcrop_api = undefined
boundx = undefined
boundy = undefined

submitCroppedImage = (ev) ->
  ev?.preventDefault()
  $('#uploadNotice').show()
  srcImg = $('#cropImg')[0]
  imgTyp = srcImg.src.split(',')[0].split(':')[1].split(';')[0]
  canvas = document.createElement('canvas')
  canvas.width = coords.w
  canvas.height = coords.h
  contxt = canvas.getContext('2d')
  contxt.drawImage(srcImg, coords.x, coords.y, coords.w, coords.h,0,0,coords.w,coords.h)
  dataUrl = canvas.toDataURL(imgTyp)
  $('#cropSend').val(dataUrl)
  $('#cropForm').submit()

initUpdate = ->
  initCoords =
    x: 10
    y: 10
    w: 240
    h: 180
  updatePreview(initCoords)
  $('#loadingMsg').hide()
  $('#imgHolder').show()

updatePreview = (coords) ->
  window.coords = coords
  if parseInt(coords.w) > 0
    rx = 100 / coords.w
    ry = 100  / coords.h
    d = {}
    d.Width  = Math.round(rx * boundx) + "px"
    d.Height = Math.round(ry * boundy) + "px"
    d.MarginLeft = "-" + Math.round(rx * coords.x) + "px"
    d.MarginTop  = "-" + Math.round(ry * coords.y) + "px"
    $("#imgPreview").css
      width:  d.Width
      height: d.Height
      marginLeft: d.MarginLeft
      marginTop:  d.MarginTop

setupJcrop = ->
  opts =
    boxWidth:  350
    boxHeight: 350
    onChange: updatePreview
    onSelect: updatePreview
    aspectRatio: 1
    minSize: [50,50]
    setSelect: [10,10,200,200]
  $("#cropImg").Jcrop opts, ->
    bounds = @getBounds()
    boundx = bounds[0]
    boundy = bounds[1]
    jcrop_api = this
    setTimeout(initUpdate, 250)

displayCropSource = (event) ->
  baseImg = new Image()
  baseImg.id  = "cropImg"
  baseImg.src = event.target.result
  imgHolder.innerHTML = ""
  imgHolder.appendChild baseImg

displayCropThumb = (event) ->
  prevImg = new Image()
  prevImg.id = "imgPreview"
  prevImg.src = event.target.result
  $('#imgPreviewDiv').html("")
  $('#imgPreviewDiv').append(prevImg)

displaySelectedImage = (ev) ->
  $('#loadingMsg').show()
  $('#imgHolder').hide()
  ev?.preventDefault()
  file = fileChooser.files[0]
  reader = new FileReader()
  reader.onload = (event) ->
    displayCropSource(event)
    displayCropThumb(event)
    setTimeout(setupJcrop, 250)
  reader.readAsDataURL file
  $('#uploadBtn').show()

$(document).ready ->
  if typeof window.FileReader is "undefined"
    $('#ieBrowser').show()
  else
    $('#webkitBrowser').show()
  $('#uploadBtn').hide()
  fileChooser = $("#fileChooser")
  imgHolder   = $("#imgHolder")
  fileChooser.change -> displaySelectedImage()
  $('#uploadBtn').click submitCroppedImage