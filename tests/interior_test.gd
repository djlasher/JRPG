extends Node

var failures:Array[String]=[]

func _ready():call_deferred("run")

func run():
 for id in ["library","general","equipment","guild","church","inn","home1","home2","home3","home4","home5"]:
  var room=Interior.new();room.setup(id,id);add_child(room);room.player.enabled=false
  await get_tree().physics_frame
  await get_tree().physics_frame
  var space=room.get_world_2d().direct_space_state
  for r in Interior.WALLS:
   if not occupied(space,r.get_center()):failures.append(id+": missing wall collision")
  for piece in room.furniture:
   if not occupied(space,piece.rect.get_center()):failures.append(id+": missing furniture collision")
   if piece.rect.intersects(Rect2(288,156,64,172)):failures.append(id+": blocked center aisle")
  for p in [Vector2(320,300),Vector2(320,220),Vector2(320,170),Vector2(320,332)]:
   if occupied(space,p):failures.append(id+": obstructed entrance or host approach")
  room.player.position=Vector2(320,170);room.player.facing=Vector2.UP
  var requests:Array=[]
  room.interaction_requested.connect(func(kind,payload):requests.append([kind,payload]))
  room.try_interact()
  if requests.size()!=1:failures.append(id+": host unreachable")
  var exits:Array=[]
  room.exit_requested.connect(func():exits.append(true))
  room.player.position=Vector2(320,321);room._physics_process(0);room._physics_process(0)
  if exits.size()!=1:failures.append(id+": automatic exit not emitted exactly once")
  room.queue_free()
  await get_tree().process_frame
 if failures.is_empty():print("INTERIOR TEST PASSED: 11 rooms, solid furniture/walls, clear aisles, host interactions, automatic exits")
 for failure in failures:push_error(failure)
 get_tree().quit(0 if failures.is_empty() else 1)

func occupied(space:PhysicsDirectSpaceState2D,p:Vector2)->bool:
 var query=PhysicsPointQueryParameters2D.new();query.position=p;query.collision_mask=1
 return not space.intersect_point(query).is_empty()

