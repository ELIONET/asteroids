calc_game_object_bounds = (game_object) ->
  return if game_object.min_x?
  if game_object.points?
    for p in game_object.points
      game_object.min_x = p.x if !game_object.min_x? || p.x < game_object.min_x
      game_object.max_x = p.x if !game_object.max_x? || p.x > game_object.max_x
      game_object.min_y = p.y if !game_object.min_y? || p.y < game_object.min_y
      game_object.max_y = p.y if !game_object.max_y? || p.y > game_object.max_y
  else
    throw new Error("Dont know how to calculate bounds for #{game_object.type}")


get_guid = (() ->
  guid_idx = 0
  (() ->
    guid_idx += 1
    "#{guid_idx}"))()

@random_polygon_points = (radius, num_sides) ->
  angle_step = Math.PI * 2 / num_sides
  points = []
  angle = - (Math.PI / 2) #0 #angle_step
  for n in [1..num_sides]
    angle_adj = 0.2 * _.random(-angle_step, angle_step)
    radius_adj = 0.20 * _.random(-radius, radius)
    point =
      x: Math.cos(angle + angle_adj) * (radius + radius_adj)
      y: Math.sin(angle + angle_adj) * (radius + radius_adj)
    points.push(point)
    angle += angle_step
  points

@create_particle = (radius, x, y) ->
  particle =
    type    : PARTICLE
    x       : x
    y       : y
    radius  : radius
    hp      : 1
  particle.mass = radius / 100
  particle.guid = get_guid()
  particle.start_time = _.now()
  particle

@create_ship = (x,y) ->
  ship = {type: SHIP, x, y, angle: 0, hp: 25, max_hp: 25, fire_juice: 0}
  ship.guid = get_guid()
  ship.points = [
      {x: 0.75, y: 0}
      #{x: 0.15, y: 1}
      {x: 0, y: 0.25}
      #{x: -0.15, y: 0}
      {x: 0, y: -0.25}
      #{x:0.5, y:-1}
    ]
  calc_game_object_bounds(ship)
  ship

COLOR_PALLETE_1 = ["rgba(233, 244, 0, 0)", "rgba(233, 0, 0, 0)", "rgba(0, 244, 0, 0)", "rgba(0, 0, 255, 0)"]
COLOR_PALETTE_2 = [ '#69D2E7', '#A7DBD8', '#E0E4CC', '#F38630', '#FA6900', '#FF4E50', '#F9D423' ]

@create_bullet = (radius, x, y, source_object_guid) ->
  bullet = {type: BULLET, radius, x, y, source_object_guid, hp: 1, mass : radius}
  bullet.guid = get_guid()
  bullet.start_time = _.now()
  bullet.color = if radius > SMALLEST_BULLET_RADIUS then _.random(COLOR_PALLETE_1) else _.random(COLOR_PALETTE_2)
  bullet



@create_asteroid = (points, x, y, invuln_ticks = 0) ->
  asteroid = {type: ASTEROID, points, x, y, invuln_ticks, hp: 100}
  asteroid.guid = get_guid()
  asteroid.color = _.random(COLOR_PALETTE_2)
  calc_game_object_bounds(asteroid)
  asteroid

@create_jerk = (x, y, invuln_ticks = 0) ->
  jerk = {type: JERK, x, y, invuln_ticks, aim: 0, current_charge_start: null}
  jerk.guid = get_guid()
  jerk.color = '#cd6090'
  jerk.hp = jerk.max_hp = 10
  jerk.points = [
    {x: 1, y: 0}
    {x: 0.6, y: 0.2}
    {x: 0, y: 0.3}
    {x: 0, y:-0.3}
    {x: 0.6, y: -0.2}
    ]
  calc_game_object_bounds(jerk)
  jerk

@create_health_pack = (x, y, amt = 8) ->
  powerup = {type: HEALTH_PACK, x, y, hp:1}
  powerup.guid = get_guid()
  powerup.radius = 0.3
  powerup.color = "#cd5c5c"
  powerup.consume = (ship) ->
    ship.hp = Math.min(ship.hp + amt, ship.max_hp)
  powerup
