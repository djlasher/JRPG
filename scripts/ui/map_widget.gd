class_name MapWidget
extends Control
var map_id:="region"
var tracked_player:Node2D
var world_size:=Vector2(2600,1900)
var compact:=true
func setup(id:String,player:Node2D,size:Vector2,is_compact:=true):map_id=id;tracked_player=player;world_size=size;compact=is_compact
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE;set_process(true);queue_redraw()
func _process(_delta):queue_redraw()
func _draw():
 draw_rect(Rect2(Vector2.ZERO,size),Color("10192cdd"),true);draw_rect(Rect2(Vector2.ZERO,size),Color("e1bd69"),false,2)
 var pad=Vector2(8,8);var inner=size-Vector2(16,16)
 if map_id=="region":
  _road(Vector2(.48,0),Vector2(.55,1),pad,inner);_water(Rect2(.0,.28,.17,.06),pad,inner);_water(Rect2(.81,0,.06,.31),pad,inner)
  _place(Vector2(.23,.76),"town",Color("d48a55"),pad,inner);_place(Vector2(.84,.62),"town",Color("62a5b3"),pad,inner)
  _place(Vector2(.15,.60),"cave",Color("76717f"),pad,inner);_place(Vector2(.58,.74),"cave",Color("8c795e"),pad,inner);_place(Vector2(.90,.83),"cave",Color("477f67"),pad,inner)
 else:
  _place(Vector2(.23,.36),"house",Color("bd7651"),pad,inner);_place(Vector2(.50,.38),"guild",Color("58a4a0"),pad,inner);_place(Vector2(.76,.36),"shop",Color("d5a04f"),pad,inner);_place(Vector2(.5,.14),"save",Color("8de8e0"),pad,inner)
 if tracked_player:
  var normalized=Vector2(clamp(tracked_player.position.x/world_size.x,0.0,1.0),clamp(tracked_player.position.y/world_size.y,0.0,1.0));var p=pad+normalized*inner;draw_circle(p,4 if compact else 7,Color.WHITE);draw_circle(p,2 if compact else 4,Color("e3b74e"))
func _road(a:Vector2,b:Vector2,pad:Vector2,inner:Vector2):draw_line(pad+a*inner,pad+b*inner,Color("c5a76b"),8 if compact else 16)
func _water(r:Rect2,pad:Vector2,inner:Vector2):draw_rect(Rect2(pad+r.position*inner,r.size*inner),Color("418baa"))
func _place(n:Vector2,kind:String,color:Color,pad:Vector2,inner:Vector2):
 var p=pad+n*inner
 if kind in ["town","house","shop","guild"]:draw_rect(Rect2(p-Vector2(6,2),Vector2(12,9)),color);draw_colored_polygon(PackedVector2Array([p+Vector2(-8,-2),p+Vector2(0,-9),p+Vector2(8,-2)]),color.darkened(.2))
 elif kind=="cave":draw_circle(p,8,color);draw_circle(p+Vector2(0,3),5,Color("171923"))
 else:draw_circle(p,6,color);draw_circle(p,3,Color.WHITE)

