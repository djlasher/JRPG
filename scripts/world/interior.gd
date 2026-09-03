class_name Interior
extends Node2D

signal interaction_requested(kind:String,payload:Dictionary)
signal exit_requested
var player:Player
var building_id:String
var building_name:String
var merchant:NPCActor
var exit_in_progress:=false
var furniture:Array[Dictionary]=[]
const WALLS=[Rect2(24,32,592,40),Rect2(24,72,16,256),Rect2(600,72,16,256),Rect2(24,328,248,16),Rect2(368,328,248,16)]
const RESIDENTS={"home1":["Mira","I leave a lamp in the window for travelers. A small light can make a strange town kinder."],"home2":["Tomas","Those flowers outside? My mother planted the first patch after the great rain."],"home3":["Edda","The kettle sings louder when storms come down from the glass hills."],"home4":["Caro","Bluebell Cottage was blue once. The rain has opinions about paint."],"home5":["Rusk","Captain Brann walks the gate route even on his day off. Habit is its own uniform."]}
func setup(id:String,title:String): building_id=id; building_name=title
func _ready():
 _layout();_walls();player=Player.new();add_child(player);player.position=Vector2(320,300);_spawn_host();queue_redraw()
func _layout():
 furniture.clear()
 if building_id=="library":
  for x in [64,208,416]:_furnish(Rect2(x,80,112,36),"books")
  for x in [72,440]:_furnish(Rect2(x,172,128,48),"table")
 elif building_id in ["general","equipment","guild"]:
  for x in [64,432]:_furnish(Rect2(x,80,144,36),"books" if building_id=="guild" else "shelf")
  _furnish(Rect2(96,180,136,40),"table")
  _furnish(Rect2(440,180,112,40),"shelf")
 elif building_id=="church":
  _furnish(Rect2(280,80,80,32),"altar")
  for y in [168,228]:
   for x in [88,392]:_furnish(Rect2(x,y,160,24),"bench")
 elif building_id=="inn":
  for x in [64,448]:_furnish(Rect2(x,84,112,72),"bed")
  _furnish(Rect2(72,216,144,40),"table")
  _furnish(Rect2(448,216,112,40),"table")
 else:
  _furnish(Rect2(64,84,112,72),"bed")
  _furnish(Rect2(440,84,128,36),"shelf")
  _furnish(Rect2(416,204,128,48),"table")
func _furnish(rect:Rect2,kind:String):furniture.append({"rect":rect,"kind":kind})
func _physics_process(_delta):
 # Crossing the open bottom doorway leaves automatically. Interaction remains
 # reserved for people and objects, matching classic top-down RPG expectations.
 if not exit_in_progress and player and player.position.y>318 and abs(player.position.x-320)<55:
  exit_in_progress=true
  player.enabled=false
  exit_requested.emit()
func _walls():
 for r in WALLS:_solid(r)
 for piece in furniture:_solid(piece.rect)
func _solid(r:Rect2):
 var body=StaticBody2D.new();body.collision_layer=1;body.collision_mask=2|4
 var c=CollisionShape2D.new();var s=RectangleShape2D.new();s.size=r.size;c.shape=s;c.position=r.get_center();body.add_child(c);add_child(body)
func _spawn_host():
 var info=_host_info(); merchant=NPCActor.new(); merchant.setup({"name":info[0],"lines":info[1],"color":info[2]}); add_child(merchant); merchant.position=Vector2(320,135)
func _host_info():
 if building_id=="general": return ["Sella",["Welcome to Sun & Sprig. Everything here is road-tested, mostly by accident."],"b56b49"]
 if building_id=="equipment": return ["Bram",["Riverforge work lasts. We make tools for journeys, not display cases."],"647a8c"]
 if building_id=="inn": return ["Maeve",["The Resting Heron has hot bread, clean sheets, and no questions before breakfast."],"a35763"]
 if building_id=="church": return ["Sister Alia",["May the Guiding Flame keep your road visible, Ari.","We do not ask the flame for answers—only enough light to choose honestly."],"7c6f9a"]
 if building_id=="library": return ["Archivist Vale",["Every map is a promise that the world can be understood. Most are charming liars."],"567263"]
 if building_id=="guild": return ["Guildmaster Sen",["The south road is open again. Take a posting, keep your lamp trimmed, and return in one piece."],"477b77"]
 var r=RESIDENTS.get(building_id,["Resident","Welcome. Mind the good rug."]); return [r[0],[r[1]],"7b6b55"]
func try_interact():
 var probe=player.position+player.facing*28
 if probe.distance_to(merchant.position)<42:
  if building_id in ["general","equipment"]: interaction_requested.emit("shop",{"id":building_id,"name":building_name,"actor":merchant})
  elif building_id=="inn": interaction_requested.emit("inn",{"actor":merchant})
  elif building_id=="guild": interaction_requested.emit("guild",{"town":"larkspur"})
  else: interaction_requested.emit("npc",{"name":merchant.npc_name,"lines":merchant.lines,"actor":merchant})
 elif building_id=="church" and probe.distance_to(Vector2(320,96))<55: interaction_requested.emit("landmark",{"name":"Guiding Altar","lines":["A blue flame rests above the brass lantern, steady and warm."]})
func _draw():
 draw_rect(Rect2(0,0,640,360),Color("171522"))
 draw_rect(Rect2(40,72,560,256),Color("645043"))
 for y in range(80,328,24):draw_line(Vector2(40,y),Vector2(600,y),Color("705b49"),1)
 draw_rect(Rect2(284,144,72,184),Color("526b69"))
 for r in WALLS:
  draw_rect(r,Color("393b47"));draw_rect(Rect2(r.position,Vector2(r.size.x,5)),Color("777282"))
 for piece in furniture:_draw_furniture(piece.rect,piece.kind)
 draw_rect(Rect2(272,328,96,16),Color("b59a70"))
 draw_string(ThemeDB.fallback_font,Vector2(298,341),"EXIT",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("25252d"))
 draw_string(ThemeDB.fallback_font,Vector2(30,24),building_name,HORIZONTAL_ALIGNMENT_LEFT,580,18,Color("f7e5b8"))
func _draw_furniture(r:Rect2,kind:String):
 draw_rect(r,Color("49342e"));draw_rect(r.grow(-3),Color("94704b"))
 if kind=="books" or kind=="shelf":
  draw_rect(Rect2(r.position+Vector2(6,7),r.size-Vector2(12,14)),Color("392e30"))
  for x in range(10,int(r.size.x)-10,12):draw_rect(Rect2(r.position+Vector2(x,10),Vector2(7,r.size.y-20)),Color("738c83") if kind=="books" else Color("c6ad73"))
 elif kind=="bed":
  draw_rect(Rect2(r.position+Vector2(6,6),Vector2(r.size.x-12,18)),Color("e3d6b8"));draw_rect(Rect2(r.position+Vector2(6,28),r.size-Vector2(12,34)),Color("657f9e"))
 elif kind=="altar":draw_circle(r.get_center(),9,Color("79dce0"))
 elif kind=="table":draw_rect(r.grow(-10),Color("b39262"))

