class_name NPCActor
extends CharacterBody2D

var npc_name := "Resident"
var lines:Array[String]=[]
var route:Array[Vector2]=[]
var route_index:=0
var wait_time:=0.0
var move_speed:=42.0
var colors:=[Color("a14e55"),Color("4f7c68"),Color("735b9c")]
var color:=Color("a14e55")
var talking:=false
var facing:=Vector2.DOWN

func setup(def:Dictionary):
 npc_name=def.name; for text in def.lines: lines.append(text)
 color=Color(def.get("color","a14e55")); move_speed=float(def.get("speed",42)); for p in def.get("route",[]): route.append(Vector2(p[0],p[1]))
func _ready():
 collision_layer=4; collision_mask=1|2|4
 var cs=CollisionShape2D.new(); var sh=CircleShape2D.new(); sh.radius=9; cs.shape=sh; cs.position=Vector2(0,7); add_child(cs); queue_redraw()
func _physics_process(delta):
 if talking or route.is_empty(): velocity=Vector2.ZERO; return
 if wait_time>0: wait_time-=delta; velocity=Vector2.ZERO; return
 var target=route[route_index]; if global_position.distance_to(target)<5: route_index=(route_index+1)%route.size(); wait_time=1.0+fmod(global_position.x,1.5); return
 velocity=global_position.direction_to(target)*move_speed;facing=velocity.normalized();move_and_slide();queue_redraw()
func _draw():
 draw_circle(Vector2(0,15),9,Color(0,0,0,0.2));draw_texture_rect_region(PixelAssets.ATLAS,Rect2(-16,-25,32,46),PixelAssets.npc_region(npc_name,facing))
