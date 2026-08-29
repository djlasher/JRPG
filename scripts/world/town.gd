class_name Town
extends Node2D

signal interaction_requested(kind:String,payload:Dictionary)
var player:Player
var npcs:Array[NPCActor]=[]
var interactables:Array[Dictionary]=[]
const SIZE:=Vector2(1600,1200)
const BUILDINGS=[
 {"id":"general","name":"Sun & Sprig Goods","rect":Rect2(160,150,250,170),"door":Vector2(285,320),"color":"c97c54"},
 {"id":"equipment","name":"Riverforge Outfitters","rect":Rect2(480,130,260,190),"door":Vector2(610,320),"color":"8b6265"},
 {"id":"inn","name":"The Resting Heron","rect":Rect2(1040,150,290,190),"door":Vector2(1185,340),"color":"526f91"},
 {"id":"church","name":"Church of the Guiding Flame","rect":Rect2(1150,650,280,220),"door":Vector2(1290,870),"color":"7a7192"},
 {"id":"home1","name":"Mira's Home","rect":Rect2(110,720,190,145),"door":Vector2(205,865),"color":"b76d4d"},
 {"id":"home2","name":"Tomas's Home","rect":Rect2(340,800,190,145),"door":Vector2(435,945),"color":"aa7951"},
 {"id":"home3","name":"Willow House","rect":Rect2(90,960,190,145),"door":Vector2(185,1105),"color":"708d61"},
 {"id":"home4","name":"Bluebell Cottage","rect":Rect2(350,1010,190,145),"door":Vector2(445,1155),"color":"657f99"},
 {"id":"home5","name":"Gatekeeper's Home","rect":Rect2(1050,950,190,145),"door":Vector2(1145,1095),"color":"9b6754"},
 {"id":"library","name":"Larkspur Archive","rect":Rect2(720,760,250,180),"door":Vector2(845,940),"color":"6c7f58"}
 ,{"id":"guild","name":"Wayfarers' Guild","rect":Rect2(1050,430,250,160),"door":Vector2(1175,590),"color":"476f73"}
]
const NPC_DATA=[
 {"name":"Captain Brann","lines":["The east road stays quiet, but quiet roads deserve the sharpest watch.","Larkspur was built around the old beacon. We still light it when travelers vanish in the mist."],"color":"365f78","route":[[760,1040],[760,650],[720,460]],"speed":48},
 {"name":"Pip","lines":["I can run all the way around the fountain without stepping on a blue stone!","Well... almost without stepping on one."],"color":"d56c4c","route":[[660,470],[830,470],[830,610],[660,610]],"speed":70},
 {"name":"Nessa","lines":["Fresh river pears! The crooked ones taste best, no matter what my brother says."],"color":"79944d","route":[[500,500],[420,610],[510,680]],"speed":38},
 {"name":"Orin","lines":["Crates to the archive, ledgers to the market. Everything in Larkspur travels twice."],"color":"8c6248","route":[[570,380],[850,500],[850,750]],"speed":45},
 {"name":"Old Fen","lines":["The church bell once rang by itself before a flood. These days it only complains about the wind."],"color":"746a7d","route":[[1120,610],[1280,610],[1330,720]],"speed":25},
 {"name":"Sable","lines":["The inn has warm bread and softer beds than the road deserves.","Tomorrow I head north, toward the glass hills—if the fog permits."],"color":"9d526d","route":[[1210,390],[970,500],[760,980]],"speed":43},
 {"name":"Ivo","lines":["You are new, aren't you? Larkspur is small enough that unfamiliar boots sound louder."],"color":"557c92"},
 {"name":"Mara","lines":["Mayor Vale keeps the oldest town maps in the archive. Some show a bridge that no longer exists."],"color":"945a68"},
 {"name":"Jun","lines":["The fountain fish is called Lord Bubbles. I named him, so it's official."],"color":"5f92a4"}
]

func _ready():
 queue_redraw(); _build_collisions(); _spawn_player(); _spawn_npcs(); _build_interactables()
func _spawn_player(): player=Player.new(); add_child(player); player.global_position=GameState.player_position
func _spawn_npcs():
 for i in NPC_DATA.size(): var n=NPCActor.new(); n.setup(NPC_DATA[i]); add_child(n); n.global_position=Vector2(560+i*70,560+(i%3)*65); npcs.append(n)
func _build_collisions():
 for b in BUILDINGS: _wall(b.rect)
 _wall(Rect2(0,0,1600,55)); _wall(Rect2(0,1145,620,55)); _wall(Rect2(900,1145,700,55)); _wall(Rect2(0,0,55,1200)); _wall(Rect2(1545,0,55,1200)); _wall(Rect2(1400,300,145,260))
 for p in [Vector2(85,390),Vector2(145,440),Vector2(1450,920),Vector2(980,1080),Vector2(1020,600)]: _wall(Rect2(p-Vector2(22,22),Vector2(44,44)))
func _wall(rect:Rect2):
 var body=StaticBody2D.new(); var cs=CollisionShape2D.new(); var shape=RectangleShape2D.new(); shape.size=rect.size; cs.shape=shape; cs.position=rect.position+rect.size/2; body.add_child(cs); add_child(body)
func _build_interactables():
 for b in BUILDINGS: interactables.append({"position":b.door,"kind":"door","payload":{"id":b.id,"name":b.name}})
 interactables.append({"position":Vector2(750,520),"kind":"landmark","payload":{"name":"Beacon Fountain","lines":["Clear water circles an old brass lantern. Its flame never seems to go out."]}})
 interactables.append({"position":Vector2(940,620),"kind":"save","payload":{}}); interactables.append({"position":Vector2(760,1130),"kind":"exit","payload":{}})
func try_interact():
 var probe=player.global_position+player.facing*28; var best=999.0; var chosen={}
 for n in npcs:
  var d=probe.distance_to(n.global_position); if d<best and d<38: best=d; chosen={"kind":"npc","payload":{"name":n.npc_name,"lines":n.lines,"actor":n}}
 for it in interactables:
  var d=probe.distance_to(it.position); if d<best and d<48: best=d; chosen=it
 if not chosen.is_empty(): interaction_requested.emit(chosen.kind,chosen.payload)
func _draw():
 draw_rect(Rect2(Vector2.ZERO,SIZE),Color("79a85b"));draw_rect(Rect2(620,0,300,1200),Color("c7a96a"));draw_rect(Rect2(0,420,1600,240),Color("c7a96a"));draw_rect(Rect2(1400,300,145,260),Color("3f88a2"))
 for x in range(0,1600,32): for y in range(0,1200,32): if (x+y)%96==0: draw_circle(Vector2(x+12,y+18),2,Color("d7d06a"))
 for b in BUILDINGS: _draw_building(b)
 for p in [Vector2(85,390),Vector2(145,440),Vector2(1450,920),Vector2(980,1080),Vector2(1020,600)]: _draw_tree(p)
 draw_circle(Vector2(750,540),80,Color("d7d4bd")); draw_circle(Vector2(750,540),63,Color("4e9db3")); draw_circle(Vector2(750,540),30,Color("8a8d78")); draw_rect(Rect2(740,485,20,70),Color("c7b663"))
 draw_circle(Vector2(940,620),18,Color("8ee7e1")); draw_circle(Vector2(940,620),10,Color("e7ffff")); draw_string(ThemeDB.fallback_font,Vector2(900,655),"WAYLIGHT",HORIZONTAL_ALIGNMENT_LEFT,100,12,Color("ecffff"))
 draw_rect(Rect2(620,1125,300,75),Color("ad8c58")); draw_string(ThemeDB.fallback_font,Vector2(695,1170),"SOUTH ROAD",HORIZONTAL_ALIGNMENT_LEFT,200,18,Color("493b30"))
func _draw_building(b):
 var r:Rect2=b.rect;var visual=Rect2(b.door-Vector2(r.size.x/2,r.size.y+35),r.size+Vector2(0,35));draw_texture_rect_region(PixelAssets.ATLAS,visual,PixelAssets.building_region(b.id));draw_rect(Rect2(b.door-Vector2(19,30),Vector2(38,30)),Color("16111bd0"));draw_rect(Rect2(b.door-Vector2(22,33),Vector2(44,36)),Color("f2c866"),false,3);draw_colored_polygon(PackedVector2Array([b.door+Vector2(-11,9),b.door+Vector2(11,9),b.door+Vector2(0,20)]),Color("fff0a8"));draw_string(ThemeDB.fallback_font,b.door+Vector2(-r.size.x/2,38),b.name+" — ENTER",HORIZONTAL_ALIGNMENT_CENTER,r.size.x,14,Color("fff1d0"))
func _draw_tree(p): draw_circle(p+Vector2(0,10),24,Color("315f43")); draw_circle(p+Vector2(-14,-4),20,Color("477c4c")); draw_circle(p+Vector2(14,-5),20,Color("4f8b52")); draw_rect(Rect2(p+Vector2(-5,18),Vector2(10,25)),Color("76523b"))

