class_name MapWidget
extends Control
var map_id:="region"
var tracked_player:Node2D
var world_size:=Vector2(2600,1900)
var compact:=true
const LOCATIONS={
 "region":[[.23,.76,"town","Brackenford"],[.84,.62,"town","Mosswick"],[.15,.60,"cave","Echoing Grotto"],[.58,.74,"mine","Stillpick Mine"],[.90,.83,"cave","Floodroot"],[.92,.22,"town","Lumenport"],[.68,.90,"temple","Sunstep Abbey"],[.80,.38,"mine","Tideglass"],[.35,.89,"cave","Observatory"]],
 "brackenford":[[.23,.31,"guild","Guild"],[.50,.40,"inn","Inn"],[.77,.31,"shop","Outfitter"],[.16,.55,"home","Homes"],[.84,.55,"shop","Provisions"]],
 "mosswick":[[.28,.35,"guild","Guild"],[.50,.46,"inn","Inn"],[.72,.35,"shop","Outfitter"],[.22,.65,"home","Homes"],[.68,.68,"dock","Ferry"]],
 "echoing_grotto":[[.31,.50,"enemy","Gloomwings"],[.73,.64,"enemy","Stonejaw"],[.24,.33,"chest","Treasure"],[.67,.45,"chest","Treasure"]],
 "stillpick_mine":[[.26,.54,"npc","Lio"],[.76,.33,"boss","Stonewarden"],[.24,.46,"chest","Treasure"],[.66,.23,"chest","Treasure"]],
 "floodroot_hollow":[[.50,.36,"boss","Mire Hart"],[.18,.24,"chest","Treasure"],[.74,.44,"chest","Treasure"]],
 "town":[[.18,.22,"shop","General"],[.38,.20,"shop","Equipment"],[.74,.22,"inn","Inn"],[.80,.62,"church","Church"],[.72,.42,"guild","Guild"],[.58,.70,"save","Waylight"]],
 "lumenport":[[.18,.25,"market","Market"],[.48,.20,"guild","Grand Guild"],[.78,.27,"temple","Temple"],[.30,.62,"inn","Inn"],[.68,.66,"palace","Beacon Hall"]]
 ,"space":[[.18,.23,"town","Viridia"],[.68,.23,"town","Cyr Ember"],[.77,.73,"town","Orison"],[.41,.60,"cave","Cinder Gate"],[.52,.40,"enemy","Voidcraft"]],
 "verdant_planet":[[.21,.35,"shop","Exchange"],[.42,.41,"inn","Rest Grove"],[.68,.33,"guild","Ranger Office"]],
 "cinder_planet":[[.21,.35,"shop","Caravan"],[.42,.41,"inn","Shade House"],[.68,.33,"guild","Expedition Board"]],
 "aether_moon":[[.22,.36,"shop","Array Store"],[.46,.43,"inn","Pressure Lodge"],[.73,.35,"guild","Signal Office"]],
 "hell_city":[[.20,.34,"shop","Ember Exchange"],[.40,.40,"inn","Quiet Furnace"],[.66,.32,"guild","Contract Board"]]
}
func setup(id:String,player:Node2D,map_size:Vector2,is_compact:=true):map_id=id;tracked_player=player;world_size=map_size;compact=is_compact
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE;set_process(tracked_player!=null);queue_redraw()
func _process(_delta):queue_redraw()
func _draw():
 draw_rect(Rect2(Vector2.ZERO,size),Color("10192cee"),true);draw_rect(Rect2(Vector2.ZERO,size),Color("e1bd69"),false,2);var pad=Vector2(8,8);var inner=size-Vector2(16,16);_geography(pad,inner)
 for entry in LOCATIONS.get(map_id,[]):_marker(Vector2(entry[0],entry[1]),entry[2],entry[3],pad,inner)
 if tracked_player:
  var n=Vector2(clamp(tracked_player.position.x/world_size.x,0.0,1.0),clamp(tracked_player.position.y/world_size.y,0.0,1.0));var p=pad+n*inner;draw_circle(p,5 if compact else 7,Color.WHITE);draw_colored_polygon(PackedVector2Array([p+Vector2(0,-7),p+Vector2(-5,5),p+Vector2(5,5)]),Color("e5b94d"))
func _geography(pad:Vector2,inner:Vector2):
 if map_id=="region":draw_line(pad+Vector2(.50,0)*inner,pad+Vector2(.54,1)*inner,Color("c5a76b"),8 if compact else 14);_water(Rect2(.0,.28,.17,.06),pad,inner);_water(Rect2(.81,0,.06,.31),pad,inner)
 elif map_id=="brackenford":_water(Rect2(0,.65,1,.18),pad,inner);draw_rect(Rect2(pad+Vector2(.38,.61)*inner,Vector2(.24,.26)*inner),Color("b99a62"))
 elif map_id=="mosswick":_water(Rect2(.78,0,.22,1),pad,inner);_water(Rect2(.62,.55,.38,.22),pad,inner)
 elif map_id=="town":_water(Rect2(.88,.22,.1,.25),pad,inner)
 elif map_id=="lumenport":_water(Rect2(0,.76,1,.24),pad,inner);_water(Rect2(.45,.30,.10,.46),pad,inner)
 elif map_id=="space":draw_rect(Rect2(pad,inner),Color("070b20"))
 elif map_id in ["verdant_planet","cinder_planet","aether_moon","hell_city"]:_water(Rect2(0,.68,1,.18),pad,inner)
 else:draw_rect(Rect2(pad+Vector2(.08,.15)*inner,Vector2(.84,.7)*inner),Color("3d4655"));draw_line(pad+Vector2(.5,.85)*inner,pad+Vector2(.5,.15)*inner,Color("7b7467"),7)
func _water(r:Rect2,pad:Vector2,inner:Vector2):draw_rect(Rect2(pad+r.position*inner,r.size*inner),Color("3d8dab"))
func _marker(n:Vector2,kind:String,label:String,pad:Vector2,inner:Vector2):
 var p=pad+n*inner;var s=5.0 if compact else 9.0
 if kind in ["town","home","shop","guild","inn","church","temple","market","palace"]:draw_rect(Rect2(p-Vector2(s,s*.2),Vector2(s*2,s*1.3)),Color("d49a5b"));draw_colored_polygon(PackedVector2Array([p+Vector2(-s*1.3,-s*.2),p+Vector2(0,-s*1.4),p+Vector2(s*1.3,-s*.2)]),Color("a95f4a"))
 elif kind in ["cave","mine"]:draw_circle(p,s,Color("777482"));draw_circle(p+Vector2(0,s*.3),s*.62,Color("111624"))
 elif kind in ["enemy","boss"]:draw_colored_polygon(PackedVector2Array([p+Vector2(-s,0),p+Vector2(0,-s),p+Vector2(s,0),p+Vector2(0,s)]),Color("cf5d62"))
 elif kind=="chest":draw_rect(Rect2(p-Vector2(s,s*.55),Vector2(s*2,s*1.1)),Color("bb7436"))
 elif kind=="save":draw_circle(p,s,Color("80e4df"));draw_circle(p,s*.45,Color.WHITE)
 else:draw_circle(p,s,Color("e3ce83"))
 if not compact:draw_string(ThemeDB.fallback_font,p+Vector2(-38,20),label,0,82,11,Color.WHITE)

