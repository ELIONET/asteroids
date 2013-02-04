COLORS = [ '#69D2E7', '#A7DBD8', '#E0E4CC', '#F38630', '#FA6900', '#FF4E50', '#F9D423' ]

class Player
  constructor : (@x, @y) ->
    @guid = "player" #get_guid()
    @points = [
      {x: 0.75, y: 0}
      #{x: 0.15, y: 1}
      {x: 0, y: 0.25}
      #{x: -0.15, y: 0}
      {x: 0, y: -0.25}
      #{x:0.5, y:-1}
    ]
    @angle = 0

  update : (state) ->
    @x = state.x
    @y = state.y
    @angle = state.angle

  draw : (ctx) ->
    ctx.save()
    ctx.globalCompositeOperation = "lighter"
    #ctx.globalAlpha = 0.6
    ctx.translate(@x * SCALE, @y * SCALE)
    ctx.rotate(@angle)
    ctx.translate(-(@x) * SCALE, -(@y) * SCALE)
    ctx.fillStyle = 'yellow'

    ctx.beginPath()
    ctx.moveTo((@x + @points[0].x) * SCALE, (@y + @points[0].y) * SCALE)
    for point in @points
       ctx.lineTo((point.x + @x) * SCALE, (point.y + @y) * SCALE)
    ctx.lineTo((@x + @points[0].x) * SCALE, (@y + @points[0].y) * SCALE)
    ctx.closePath()
    ctx.fill()
    ctx.stroke()
    ctx.restore()

@Player = Player
