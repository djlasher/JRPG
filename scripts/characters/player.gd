class_name Player
extends CharacterBody2D

var enabled := true
var facing := Vector2.DOWN
var speed := 150.0
var appearance_mode:="hero"
var walk_time:=0.0

func _ready():
 collision_layer=2; collision_mask=1|4
 var shape=CollisionShape2D.new(); var capsule=CapsuleShape2D.new(); capsule.radius=8; capsule.height=18; shape.shape=capsule; shape.position=Vector2(0,8); add_child(shape)
 queue_redraw()
func _physics_process(delta):
 if not enabled: velocity=Vector2.ZERO; return
 var input=Input.get_vector("move_left","move_right","move_up","move_down")
 velocity=input*speed
 if input.length()>0.15:
  walk_time+=delta*8.0
  if abs(input.x)>abs(input.y): facing=Vector2(sign(input.x),0)
  else: facing=Vector2(0,sign(input.y))
 move_and_slide(); GameState.player_position=global_position; queue_redraw()
func _draw():
 if appearance_mode!="hero":draw_texture_rect_region(PixelAssets.ATLAS,Rect2(-30,-25,60,50),PixelAssets.vehicle_region(appearance_mode));return
 _draw_oval(Vector2(0,15),Vector2(10,4),Color(0,0,0,0.25));var bob=1.0 if velocity.length()>1 and int(walk_time)%2==0 else 0.0;draw_texture_rect_region(PixelAssets.ATLAS,Rect2(-17,-27+bob,34,48),PixelAssets.hero_region(facing))
func _draw_oval(center:Vector2,radii:Vector2,color:Color):
 var pts=PackedVector2Array()
 for i in 20:pts.append(center+Vector2(cos(i*TAU/20.0)*radii.x,sin(i*TAU/20.0)*radii.y))
 draw_colored_polygon(pts,color)

