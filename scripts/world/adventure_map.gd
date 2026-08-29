class_name AdventureMap
extends Node2D
signal interaction_requested(kind:String,payload:Dictionary)
signal return_requested
var player:Player
var map_id:="region"
var title:="The Lanternvale Reach"
var size:=Vector2(2600,1900)
var interactables:Array[Dictionary]=[]
var exit_locked:=false
const ENCOUNTERS=[
 ["mossling",Vector2(1050,350)],["briarback",Vector2(650,520)],["briarback",Vector2(450,760)],["gloomwing",Vector2(1500,420)],["river_wisp",Vector2(1870,620)],["roadshade",Vector2(950,980)],["stonejaw",Vector2(1650,1120)],["lantern_moth",Vector2(2100,920)],["glass_fox",Vector2(2250,1450)]]
const TREASURES=[
 ["satchel_chest",Vector2(720,400),"sunleaf_tonic",2],["arch_keepsake",Vector2(330,920),"wind_knot",1],["reach_03",Vector2(1350,350),"clearwater_salt",2],["reach_04",Vector2(1940,420),"moon_moss",1],["reach_05",Vector2(2300,720),"sunleaf_tonic",3],["reach_06",Vector2(850,1250),"moon_moss",1],["reach_07",Vector2(1750,1500),"marsh_blade",1],["reach_08",Vector2(2350,1650),"moon_moss",1],
 ["grotto_01",Vector2(170,150),"sunleaf_tonic",2],["grotto_02",Vector2(470,210),"lantern_charm",1],["mine_01",Vector2(180,240),"clearwater_salt",2],["mine_02",Vector2(500,120),"quarry_mail",1],["hollow_01",Vector2(120,120),"sunleaf_tonic",3],["hollow_02",Vector2(520,220),"wind_knot",1]]
func setup(id:String):
 map_id=id
 if id=="region":title="The Lanternvale Reach";size=Vector2(2600,1900)
 elif id=="brackenford":title="Brackenford, Town of Reed Bridges";size=Vector2(1100,800)
 elif id=="mosswick":title="Mosswick Ferry Village";size=Vector2(900,700)
 elif id=="echoing_grotto":title="Echoing Grotto";size=Vector2(700,460)
 elif id=="stillpick_mine":title="Stillpick Mine";size=Vector2(760,520)
 else:title="Floodroot Hollow";size=Vector2(700,500)
func _ready():queue_redraw();_walls();player=Player.new();add_child(player);player.position=Vector2(size.x/2,100 if map_id=="region" else size.y-80);_content()
func _walls():
 for r in [Rect2(0,0,size.x,30),Rect2(0,0,30,size.y),Rect2(size.x-30,0,30,size.y),Rect2(0,size.y-30,size.x/2-60,30),Rect2(size.x/2+60,size.y-30,size.x/2-60,30)]:_wall(r)
 if map_id=="region":for r in [Rect2(0,600,420,80),Rect2(2050,0,120,650),Rect2(1180,700,240,620),Rect2(1550,1550,700,70)]:_wall(r)
func _wall(r:Rect2):var b=StaticBody2D.new();var c=CollisionShape2D.new();var s=RectangleShape2D.new();s.size=r.size;c.shape=s;c.position=r.position+r.size/2;b.add_child(c);add_child(b)
func _content():
 if map_id=="region":
  interactables=[{"position":Vector2(1250,80),"kind":"return","payload":{}},{"position":Vector2(600,1450),"kind":"travel","payload":{"id":"brackenford"}},{"position":Vector2(2180,1200),"kind":"travel","payload":{"id":"mosswick"}},{"position":Vector2(400,1150),"kind":"travel","payload":{"id":"echoing_grotto"}},{"position":Vector2(1500,1420),"kind":"travel","payload":{"id":"stillpick_mine"}},{"position":Vector2(2300,1580),"kind":"travel","payload":{"id":"floodroot_hollow"}},
  {"position":Vector2(1980,850),"kind":"event","payload":{"id":"injured_traveler","text":"A traveler leans against the bridge. Your arrival brings visible relief."}},
  {"position":Vector2(350,900),"kind":"event","payload":{"id":"ghost_light_a","target":"ghost_light","text":"A pale lantern drifts between broken stones, leaving no shadow."}},
  {"position":Vector2(450,980),"kind":"event","payload":{"id":"ghost_light_b","target":"ghost_light","text":"A second ghost light answers with three slow pulses."}},
  {"position":Vector2(530,880),"kind":"event","payload":{"id":"ghost_light_c","target":"ghost_light","text":"The final light folds into the ruined arch and vanishes."}},
  {"position":Vector2(820,700),"kind":"event","payload":{"id":"broken_wagon","text":"A wagon wheel lies neatly beside the road. Small muddy footprints circle it."}},
  {"position":Vector2(1730,420),"kind":"event","payload":{"id":"wind_overlook","text":"From the ridge, Larkspur's brass roofs look like fallen autumn leaves."}},
  {"position":Vector2(2200,780),"kind":"event","payload":{"id":"ferry_camp","text":"A hidden ferry camp still holds warm tea and a map weighted by river stones."}},
  {"position":Vector2(960,1480),"kind":"event","payload":{"id":"old_battlefield","text":"Rustless spearheads mark a battle nobody in the valley remembers winning."}},
  {"position":Vector2(1880,1380),"kind":"event","payload":{"id":"singing_stone","text":"The split standing stone hums the same note as Larkspur's church bell."}},
  {"position":Vector2(2380,1100),"kind":"event","payload":{"id":"rare_tracks","text":"Glass-bright pawprints lead away from the road. A rare fox watches from the reeds."}}]
  for e in ENCOUNTERS:if e[0] not in GameState.defeated_bosses:interactables.append({"position":e[1],"kind":"battle","payload":{"enemy":e[0]}})
 else:
  interactables=[{"position":Vector2(size.x/2,size.y-55),"kind":"return_region","payload":{}},{"position":Vector2(size.x/2,95),"kind":"save","payload":{}}]
  if map_id in ["brackenford","mosswick"]:
   interactables.append({"position":Vector2(250,250),"kind":"guild","payload":{"town":map_id}});interactables.append({"position":Vector2(size.x-250,250),"kind":"shop","payload":{"id":"equipment","name":title+" Outfitters"}});interactables.append({"position":Vector2(size.x/2,320),"kind":"inn","payload":{}});GameState.track("visit",map_id)
  elif map_id=="echoing_grotto":for e in [["gloomwing",Vector2(220,230)],["stonejaw",Vector2(510,300)]]:interactables.append({"position":e[1],"kind":"battle","payload":{"enemy":e[0]}})
  elif map_id=="stillpick_mine":interactables.append({"position":Vector2(200,280),"kind":"event","payload":{"id":"scout_lio","text":"Scout Lio is bruised but alive. He points toward a grinding sound below."}});if "stonewarden" not in GameState.defeated_bosses:interactables.append({"position":Vector2(580,170),"kind":"battle","payload":{"enemy":"stonewarden"}})
  elif "mire_hart" not in GameState.defeated_bosses:interactables.append({"position":Vector2(350,180),"kind":"battle","payload":{"enemy":"mire_hart"}})
 var prefix={"echoing_grotto":"grotto","stillpick_mine":"mine","floodroot_hollow":"hollow"}.get(map_id,"")
 for t in TREASURES:
  var belongs=map_id=="region" and (str(t[0]).begins_with("reach") or t[0] in ["satchel_chest","arch_keepsake"]) or prefix!="" and str(t[0]).begins_with(prefix)
  if belongs and t[0] not in GameState.opened_treasures:interactables.append({"position":t[1],"kind":"treasure","payload":{"id":t[0],"item":t[2],"count":t[3]}})
func try_interact():
 var probe=player.position+player.facing*28;var best=999.0;var chosen={}
 for it in interactables:var d=probe.distance_to(it.position);if d<best and d<55:best=d;chosen=it
 if not chosen.is_empty():interaction_requested.emit(chosen.kind,chosen.payload)
func _physics_process(_delta):
 if not exit_locked and player.position.y>size.y-42 and abs(player.position.x-size.x/2)<65:exit_locked=true;player.enabled=false;return_requested.emit()
func remove_near(kind:String):
 for i in range(interactables.size()-1,-1,-1):if interactables[i].kind==kind and player.position.distance_to(interactables[i].position)<100:interactables.remove_at(i)
 queue_redraw()
func _draw():
 var base=Color("70995b") if map_id in ["region","brackenford","mosswick"] else Color("3e4650");draw_rect(Rect2(Vector2.ZERO,size),base);draw_string(ThemeDB.fallback_font,Vector2(45,65),title,HORIZONTAL_ALIGNMENT_LEFT,600,26,Color("fff0c2"))
 if map_id=="region":
  draw_rect(Rect2(1130,0,260,1900),Color("c2a66a"));draw_rect(Rect2(0,600,420,80),Color("4389a1"));draw_rect(Rect2(2050,0,120,650),Color("4389a1"));draw_rect(Rect2(1180,700,240,620),Color("6b635c"));draw_circle(Vector2(350,900),95,Color("586a57"));draw_string(ThemeDB.fallback_font,Vector2(250,830),"THE GREAT STONE ARCH",0,300,17,Color("f0dbad"))
  for p in [Vector2(700,300),Vector2(350,500),Vector2(500,850),Vector2(1800,350),Vector2(2250,850),Vector2(900,1550)]:_tree(p)
  for loc in [[Vector2(600,1450),"BRACKENFORD"],[Vector2(2180,1200),"MOSSWICK"],[Vector2(400,1150),"GROTTO"],[Vector2(1500,1420),"STILLPICK"],[Vector2(2300,1580),"FLOODROOT"]]:draw_circle(loc[0],38,Color("b48254"));draw_string(ThemeDB.fallback_font,loc[0]+Vector2(-55,60),loc[1],0,130,14,Color("fff0c2"))
 for it in interactables:
  if it.kind=="battle":var c=Color(EnemyDatabase.ENEMIES[it.payload.enemy].color);draw_circle(it.position,18,c);draw_circle(it.position+Vector2(0,-14),10,c.lightened(.2))
  elif it.kind=="treasure":draw_rect(Rect2(it.position-Vector2(16,12),Vector2(32,24)),Color("9d612f"));draw_rect(Rect2(it.position-Vector2(13,9),Vector2(26,5)),Color("e3b651"))
  elif it.kind in ["guild","save"]:draw_circle(it.position,18,Color("82d9d0"))
func _tree(p):draw_circle(p,34,Color("356445"));draw_circle(p+Vector2(18,-12),27,Color("497d4e"));draw_rect(Rect2(p+Vector2(-5,22),Vector2(10,30)),Color("76513a"))

