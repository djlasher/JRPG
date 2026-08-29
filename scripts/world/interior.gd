class_name Interior
extends Node2D

signal interaction_requested(kind:String,payload:Dictionary)
signal exit_requested
var player:Player
var building_id:String
var building_name:String
var merchant:NPCActor
var exit_in_progress:=false
const RESIDENTS={"home1":["Mira","I leave a lamp in the window for travelers. A small light can make a strange town kinder."],"home2":["Tomas","Those flowers outside? My mother planted the first patch after the great rain."],"home3":["Edda","The kettle sings louder when storms come down from the glass hills."],"home4":["Caro","Bluebell Cottage was blue once. The rain has opinions about paint."],"home5":["Rusk","Captain Brann walks the gate route even on his day off. Habit is its own uniform."]}
func setup(id:String,title:String): building_id=id; building_name=title
func _ready(): queue_redraw(); _walls(); player=Player.new(); add_child(player); player.position=Vector2(320,300); _spawn_host()
func _physics_process(_delta):
 # Crossing the open bottom doorway leaves automatically. Interaction remains
 # reserved for people and objects, matching classic top-down RPG expectations.
 if not exit_in_progress and player and player.position.y>318 and abs(player.position.x-320)<55:
  exit_in_progress=true
  player.enabled=false
  exit_requested.emit()
func _walls():
 for r in [Rect2(0,0,640,32),Rect2(0,0,32,360),Rect2(608,0,32,360),Rect2(0,328,270,32),Rect2(370,328,270,32),Rect2(80,95,480,30)]:
  var body=StaticBody2D.new(); var c=CollisionShape2D.new(); var s=RectangleShape2D.new(); s.size=r.size;c.shape=s;c.position=r.position+r.size/2;body.add_child(c);add_child(body)
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
 elif building_id=="church" and probe.distance_to(Vector2(320,65))<55: interaction_requested.emit("landmark",{"name":"Guiding Altar","lines":["A blue flame rests above the brass lantern, steady and warm."]})
func _draw():
 draw_rect(Rect2(0,0,640,360),Color("171522"));var source=PixelAssets.INTERIORS.arcane if building_id=="church" else (PixelAssets.INTERIORS.shop if building_id in ["general","equipment","guild"] else PixelAssets.INTERIORS.wood);draw_texture_rect_region(PixelAssets.ATLAS,Rect2(32,32,576,296),source);draw_rect(Rect2(270,305,100,23),Color("171522"));draw_string(ThemeDB.fallback_font,Vector2(30,24),building_name,HORIZONTAL_ALIGNMENT_LEFT,500,18,Color("f7e5b8"))
 for x in range(80,560,95): draw_rect(Rect2(x,180,55,35),Color("795b43")); draw_rect(Rect2(x+8,187,39,7),Color("d0aa68"))
 if building_id=="inn": for x in [100,220,420,520]: draw_rect(Rect2(x-30,240,60,35),Color("6a86a1"))
 if building_id=="church": for y in [175,225,275]: draw_rect(Rect2(110,y,160,17),Color("745237")); draw_rect(Rect2(370,y,160,17),Color("745237")); draw_circle(Vector2(320,65),14,Color("79dce0"))
