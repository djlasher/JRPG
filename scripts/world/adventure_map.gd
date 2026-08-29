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
var roam_time:=0.0
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
 elif id=="floodroot_hollow":title="Floodroot Hollow";size=Vector2(700,500)
 elif id=="lumenport":title="Lumenport, City of Seven Lamps";size=Vector2(1800,1300)
 elif id=="sunstep_abbey":title="Sunstep Abbey";size=Vector2(950,720)
 elif id=="tideglass_aqueduct":title="Tideglass Aqueduct";size=Vector2(1000,700)
 elif id=="fallen_observatory":title="The Fallen Observatory";size=Vector2(1050,760)
 elif id=="space":title="The Nearlight Expanse";size=Vector2(2200,1500)
 elif id=="verdant_planet":title="Viridia — Lattice Gardens";size=Vector2(1200,850)
 elif id=="cinder_planet":title="Cyr Ember — Saffron Outpost";size=Vector2(1200,850)
 elif id=="aether_moon":title="Orison Moon — Quiet Array";size=Vector2(1100,800)
 else:title="Cinder Court, City Below";size=Vector2(1300,900)
func _ready():
 queue_redraw()
 _walls()
 player=Player.new()
 add_child(player)
 player.position=Vector2(size.x/2,100 if map_id in ["region","space"] else size.y-80)
 if map_id=="space":
  player.appearance_mode="spacecraft"
  player.speed=230
 elif map_id=="region" and GameState.vehicles.current!="foot":
  player.appearance_mode=GameState.vehicles.current
  player.speed=210
 _content()
 _add_minimap()
func _add_minimap():
 var layer=CanvasLayer.new();layer.layer=5;add_child(layer);var map=MapWidget.new();map.position=Vector2(478,10);map.size=Vector2(152,96);map.setup(map_id,player,size,true);layer.add_child(map)
func _walls():
 for r in [Rect2(0,0,size.x,30),Rect2(0,0,30,size.y),Rect2(size.x-30,0,30,size.y),Rect2(0,size.y-30,size.x/2-60,30),Rect2(size.x/2+60,size.y-30,size.x/2-60,30)]:_wall(r)
 if map_id=="region":for r in [Rect2(0,600,420,80),Rect2(2050,0,120,650),Rect2(1180,700,240,620),Rect2(1550,1550,700,70)]:_wall(r)
func _wall(r:Rect2):var b=StaticBody2D.new();var c=CollisionShape2D.new();var s=RectangleShape2D.new();s.size=r.size;c.shape=s;c.position=r.position+r.size/2;b.add_child(c);add_child(b)
func _content():
 if map_id=="region":
  interactables=[{"position":Vector2(1250,80),"kind":"return","payload":{}},{"position":Vector2(600,1450),"kind":"travel","payload":{"id":"brackenford"}},{"position":Vector2(2180,1200),"kind":"travel","payload":{"id":"mosswick"}},{"position":Vector2(400,1150),"kind":"travel","payload":{"id":"echoing_grotto"}},{"position":Vector2(1500,1420),"kind":"travel","payload":{"id":"stillpick_mine"}},{"position":Vector2(2300,1580),"kind":"travel","payload":{"id":"floodroot_hollow"}},{"position":Vector2(2380,420),"kind":"travel","payload":{"id":"lumenport"}},{"position":Vector2(1780,1710),"kind":"travel","payload":{"id":"sunstep_abbey"}},{"position":Vector2(2060,720),"kind":"travel","payload":{"id":"tideglass_aqueduct"}},{"position":Vector2(900,1700),"kind":"travel","payload":{"id":"fallen_observatory"}},
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
  if not GameState.vehicles.ground:interactables.append({"position":Vector2(1120,1200),"kind":"unlock_vehicle","payload":{"id":"ground","text":"The guild mechanic hands over the reins to the Reedrunner, a swift road wagon."}})
  elif not GameState.vehicles.boat:interactables.append({"position":Vector2(2100,1050),"kind":"unlock_vehicle","payload":{"id":"boat","text":"Mosswick launches the blue-hulled Lanternwake for Ari's party."}})
  elif not GameState.vehicles.aircraft:interactables.append({"position":Vector2(1700,1650),"kind":"unlock_vehicle","payload":{"id":"aircraft","text":"Sunstep's engineers unfold the Skydart's brass wings."}})
  elif not GameState.vehicles.spacecraft:interactables.append({"position":Vector2(2380,500),"kind":"unlock_vehicle","payload":{"id":"spacecraft","text":"Lumenport's sealed hangar opens. The Waylight Comet waits beyond the clouds."}})
  for e in ENCOUNTERS:if e[0] not in GameState.defeated_bosses:interactables.append({"position":e[1],"kind":"battle","payload":{"enemy":e[0]}})
 else:
  interactables=[{"position":Vector2(size.x/2,size.y-55),"kind":"return_region","payload":{}},{"position":Vector2(size.x/2,95),"kind":"save","payload":{}}]
  if map_id in ["brackenford","mosswick"]:
   interactables.append({"position":Vector2(250,250),"kind":"guild","payload":{"town":map_id}});interactables.append({"position":Vector2(size.x-250,250),"kind":"shop","payload":{"id":"equipment","name":title+" Outfitters"}});interactables.append({"position":Vector2(size.x/2,320),"kind":"inn","payload":{}});GameState.track("visit",map_id)
   if map_id=="brackenford" and "brann" not in GameState.party:interactables.append({"position":Vector2(430,440),"kind":"recruit","payload":{"id":"brann","text":"Captain Brann lowers his shield. 'The road has grown teeth. From here, we walk it together.'"}})
  elif map_id=="lumenport":
   interactables.append({"position":Vector2(850,260),"kind":"guild","payload":{"town":"lumenport"}});interactables.append({"position":Vector2(350,430),"kind":"shop","payload":{"id":"general","name":"Seven Lamps Market"}});interactables.append({"position":Vector2(1320,430),"kind":"shop","payload":{"id":"equipment","name":"Lumenport Arsenal"}});interactables.append({"position":Vector2(600,820),"kind":"inn","payload":{}});if "lyra" not in GameState.party:interactables.append({"position":Vector2(1050,780),"kind":"recruit","payload":{"id":"lyra","text":"Lyra closes her tide-chart. 'The aqueduct is singing backward. I need allies who can hear danger without running from it.'"}});GameState.track("visit","lumenport")
  elif map_id=="sunstep_abbey":interactables.append({"position":Vector2(475,250),"kind":"event","payload":{"id":"abbey_blessing","text":"The abbey's mirror pool reflects three lights though only two lamps burn."}});GameState.track("visit","sunstep_abbey")
  elif map_id in ["tideglass_aqueduct","fallen_observatory"]:
   var puzzle_id="aqueduct_gates" if map_id=="tideglass_aqueduct" else "observatory_lenses";interactables.append({"position":Vector2(size.x/2,300),"kind":"puzzle","payload":{"id":puzzle_id,"text":"The mechanism settles into alignment. A sealed route opens."}});interactables.append({"position":Vector2(size.x-180,160),"kind":"battle","payload":{"enemy":"stonewarden" if map_id=="tideglass_aqueduct" else "mire_hart"}})
  elif map_id=="space":
   interactables=[{"position":Vector2(400,350),"kind":"travel","payload":{"id":"verdant_planet"}},{"position":Vector2(1500,350),"kind":"travel","payload":{"id":"cinder_planet"}},{"position":Vector2(1700,1100),"kind":"travel","payload":{"id":"aether_moon"}},{"position":Vector2(900,900),"kind":"travel","payload":{"id":"hell_city"}},{"position":Vector2(1150,600),"kind":"ship_battle","payload":{}}]
  elif map_id in ["verdant_planet","cinder_planet","aether_moon","hell_city"]:
   interactables.append({"position":Vector2(size.x/2,100),"kind":"return_space","payload":{}});interactables.append({"position":Vector2(250,300),"kind":"shop","payload":{"id":"general","name":title+" Exchange"}});interactables.append({"position":Vector2(500,350),"kind":"inn","payload":{}});interactables.append({"position":Vector2(800,280),"kind":"event","payload":{"id":map_id+"_welcome","text":("A horned archivist offers tea and a perfectly ordinary library card." if map_id=="hell_city" else "Local envoys welcome the Waylight travelers and mark nearby ruins on their chart.")}});if map_id=="verdant_planet" and not GameState.story_branches.has("first_contact"):interactables.append({"position":Vector2(950,420),"kind":"branch","payload":{}});if map_id not in GameState.known_planets and map_id!="hell_city":GameState.known_planets.append(map_id)
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
func _physics_process(delta):
 roam_time+=delta
 var moved=false
 for i in interactables.size():
  if interactables[i].kind!="battle":continue
  if not interactables[i].has("roam_origin"):interactables[i].roam_origin=interactables[i].position;interactables[i].roam_phase=float(i)*1.73
  var origin:Vector2=interactables[i].roam_origin;var phase=float(interactables[i].roam_phase)
  interactables[i].position=origin+Vector2(sin(roam_time*.75+phase)*24.0,cos(roam_time*.58+phase)*15.0);moved=true
 if moved:queue_redraw()
 if not exit_locked and player.position.y>size.y-42 and abs(player.position.x-size.x/2)<65:exit_locked=true;player.enabled=false;return_requested.emit()
func remove_near(kind:String):
 for i in range(interactables.size()-1,-1,-1):if interactables[i].kind==kind and player.position.distance_to(interactables[i].position)<100:interactables.remove_at(i)
 queue_redraw()
func _draw():
 var base=Color("70995b") if map_id in ["region","brackenford","mosswick"] else Color("3e4650");draw_rect(Rect2(Vector2.ZERO,size),base);draw_string(ThemeDB.fallback_font,Vector2(45,65),title,HORIZONTAL_ALIGNMENT_LEFT,600,26,Color("fff0c2"))
 if map_id=="region":
  draw_rect(Rect2(1130,0,260,1900),Color("c2a66a"));draw_rect(Rect2(0,600,420,80),Color("4389a1"));draw_rect(Rect2(2050,0,120,650),Color("4389a1"));draw_rect(Rect2(1180,700,240,620),Color("6b635c"));draw_circle(Vector2(350,900),95,Color("586a57"));draw_string(ThemeDB.fallback_font,Vector2(250,830),"THE GREAT STONE ARCH",0,300,17,Color("f0dbad"))
  for p in [Vector2(700,300),Vector2(350,500),Vector2(500,850),Vector2(1800,350),Vector2(2250,850),Vector2(900,1550)]:_tree(p)
  _draw_location(Vector2(600,1450),"BRACKENFORD","town",Color("b96f4f"));_draw_location(Vector2(2180,1200),"MOSSWICK","town",Color("5c8995"));_draw_location(Vector2(400,1150),"ECHOING GROTTO","cave",Color("77717d"));_draw_location(Vector2(1500,1420),"STILLPICK MINE","mine",Color("89755e"));_draw_location(Vector2(2300,1580),"FLOODROOT HOLLOW","cave",Color("477f67"));_draw_location(Vector2(2380,420),"LUMENPORT","town",Color("b08b56"));_draw_location(Vector2(1780,1710),"SUNSTEP ABBEY","town",Color("c69d6e"));_draw_location(Vector2(2060,720),"TIDEGLASS","mine",Color("4f95a0"));_draw_location(Vector2(900,1700),"OBSERVATORY","cave",Color("665f8c"))
 elif map_id in ["brackenford","mosswick"]:_draw_settlement()
 elif map_id=="lumenport":_draw_city()
 elif map_id=="sunstep_abbey":_draw_abbey()
 elif map_id=="space":_draw_space()
 elif map_id in ["verdant_planet","cinder_planet","aether_moon","hell_city"]:_draw_other_world()
 for it in interactables:
  if it.kind=="battle":_draw_enemy(it.position,it.payload.enemy)
  elif it.kind=="treasure":draw_texture_rect_region(VisualAssets.ATLAS,Rect2(it.position-Vector2(24,18),Vector2(48,36)),VisualAssets.chest_region(1))
  elif it.kind=="save":draw_circle(it.position,18,Color("82d9d0"));draw_circle(it.position,9,Color.WHITE);draw_string(ThemeDB.fallback_font,it.position+Vector2(-35,34),"WAYLIGHT",0,90,12,Color.WHITE)
  elif it.kind=="guild":draw_string(ThemeDB.fallback_font,it.position+Vector2(-40,42),"GUILD",0,100,13,Color("fff0c2"))
func _tree(p):draw_circle(p,34,Color("356445"));draw_circle(p+Vector2(18,-12),27,Color("497d4e"));draw_rect(Rect2(p+Vector2(-5,22),Vector2(10,30)),Color("76513a"))
func _draw_location(p:Vector2,label:String,kind:String,color:Color):
 if kind=="town":
  for o in [Vector2(-28,8),Vector2(0,-8),Vector2(28,10)]:draw_rect(Rect2(p+o-Vector2(14,10),Vector2(28,22)),color);draw_colored_polygon(PackedVector2Array([p+o+Vector2(-18,-10),p+o+Vector2(0,-25),p+o+Vector2(18,-10)]),color.darkened(.25))
 else:draw_circle(p,34,color);draw_circle(p+Vector2(0,9),22,Color("171923"));if kind=="mine":draw_line(p+Vector2(-22,-18),p+Vector2(22,20),Color("d3b46c"),5)
 draw_colored_polygon(PackedVector2Array([p+Vector2(-13,35),p+Vector2(13,35),p+Vector2(0,49)]),Color("fff0a8"));draw_string(ThemeDB.fallback_font,p+Vector2(-72,66),label+" — ENTER",0,180,14,Color("fff4cf"))
func _draw_enemy(p:Vector2,id:String):
 var e=EnemyDatabase.ENEMIES[id];var source=PixelAssets.enemy_region(id)
 draw_texture_rect_region(PixelAssets.ATLAS,Rect2(p-Vector2(28,34),Vector2(56,68)),source)
 draw_string(ThemeDB.fallback_font,p+Vector2(-55,38),e.name,0,120,12,Color.WHITE)
func _draw_settlement():
 var water_color=Color("438eaa");if map_id=="brackenford":draw_rect(Rect2(0,520,size.x,95),water_color);draw_rect(Rect2(430,500,240,135),Color("b9955f"))
 else:draw_rect(Rect2(size.x-170,0,170,size.y),water_color);draw_circle(Vector2(size.x-170,420),120,water_color)
 var buildings=[[Vector2(250,250),"WAYFARERS' GUILD",Color("4d7777")],[Vector2(size.x-250,250),"OUTFITTER",Color("b5764e")],[Vector2(size.x/2,320),"INN",Color("607f9b")],[Vector2(170,430),"HOME",Color("9a6b50")],[Vector2(size.x-180,430),"PROVISIONS",Color("7a8d57")],[Vector2(size.x/2,500),"FERRY OFFICE" if map_id=="mosswick" else "MINERS' HALL",Color("796783")]]
 for b in buildings:
  var p:Vector2=b[0];var c:Color=b[2];draw_rect(Rect2(p-Vector2(72,45),Vector2(144,90)),c);draw_colored_polygon(PackedVector2Array([p+Vector2(-82,-45),p+Vector2(0,-95),p+Vector2(82,-45)]),c.darkened(.25));draw_rect(Rect2(p+Vector2(-14,10),Vector2(28,35)),Color("4a352d"));draw_string(ThemeDB.fallback_font,p+Vector2(-65,65),b[1],0,145,13,Color("fff1cf"))
func _draw_city():
 draw_rect(Rect2(0,1000,1800,300),Color("3d8dab"));draw_rect(Rect2(820,150,160,850),Color("3d8dab"));for y in [330,680,920]:draw_rect(Rect2(760,y,280,70),Color("b99a63"))
 var districts=[[Vector2(300,280),"LANTERN MARKET",Color("b97850")],[Vector2(850,260),"GRAND GUILD",Color("4b7778")],[Vector2(1400,280),"HIGH TEMPLE",Color("8a7195")],[Vector2(420,760),"RIVER INN",Color("587d99")],[Vector2(1200,760),"BEACON HALL",Color("9a8258")],[Vector2(1450,560),"ARSENAL",Color("7c6260")],[Vector2(250,570),"APOTHECARY",Color("6f8a5b")]]
 for b in districts:var p:Vector2=b[0];var c:Color=b[2];draw_rect(Rect2(p-Vector2(105,65),Vector2(210,130)),c);draw_colored_polygon(PackedVector2Array([p+Vector2(-120,-65),p+Vector2(0,-125),p+Vector2(120,-65)]),c.darkened(.25));draw_rect(Rect2(p+Vector2(-18,15),Vector2(36,50)),Color("49342c"));draw_string(ThemeDB.fallback_font,p+Vector2(-95,90),b[1],0,200,15,Color("fff1cf"))
func _draw_abbey():draw_circle(Vector2(475,350),150,Color("3d8dab"));draw_circle(Vector2(475,350),115,Color("8bc0bd"));draw_rect(Rect2(300,100,350,170),Color("c4a276"));draw_colored_polygon(PackedVector2Array([Vector2(280,100),Vector2(475,20),Vector2(670,100)]),Color("8e6f67"));draw_string(ThemeDB.fallback_font,Vector2(355,210),"MIRROR-POOL CHAPEL",0,300,17,Color("fff1cf"))
func _draw_space():
 draw_rect(Rect2(Vector2.ZERO,size),Color("070b20"));for x in range(40,int(size.x),110):for y in range(50,int(size.y),95):draw_circle(Vector2(x+(y%43),y),2,Color("dce8ff"));for data in [[Vector2(400,350),Color("58a875"),"VIRIDIA"],[Vector2(1500,350),Color("d27b45"),"CYR EMBER"],[Vector2(1700,1100),Color("a2a8c9"),"ORISON"],[Vector2(900,900),Color("a34d67"),"CINDER GATE"]]:draw_circle(data[0],55,data[1]);draw_circle(data[0]-Vector2(15,12),13,data[1].lightened(.25));draw_string(ThemeDB.fallback_font,data[0]+Vector2(-55,80),data[2],0,130,15,Color.WHITE)
func _draw_other_world():
 var ground=Color("769d72") if map_id=="verdant_planet" else (Color("b66b43") if map_id=="cinder_planet" else (Color("7d82a7") if map_id=="aether_moon" else Color("6f3646")));draw_rect(Rect2(Vector2.ZERO,size),ground);var water=Color("5cc5b0") if map_id=="verdant_planet" else Color("cf6950");draw_rect(Rect2(0,size.y*.68,size.x,size.y*.18),water);for p in [Vector2(250,300),Vector2(500,350),Vector2(800,280)]:draw_rect(Rect2(p-Vector2(65,45),Vector2(130,90)),Color("d0b17a" if map_id!="hell_city" else "58334b"));draw_colored_polygon(PackedVector2Array([p+Vector2(-75,-45),p+Vector2(0,-95),p+Vector2(75,-45)]),Color("825e68"))

