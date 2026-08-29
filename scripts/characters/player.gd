class_name Player
extends CharacterBody2D

var enabled := true
var facing := Vector2.DOWN
var speed := 150.0
var appearance_mode:="hero"

func _ready():
 collision_layer=2; collision_mask=1|4
 var shape=CollisionShape2D.new(); var capsule=CapsuleShape2D.new(); capsule.radius=8; capsule.height=18; shape.shape=capsule; shape.position=Vector2(0,8); add_child(shape)
 queue_redraw()
func _physics_process(_delta):
 if not enabled: velocity=Vector2.ZERO; return
 var input=Input.get_vector("move_left","move_right","move_up","move_down")
 velocity=input*speed
 if input.length()>0.15:
  if abs(input.x)>abs(input.y): facing=Vector2(sign(input.x),0)
  else: facing=Vector2(0,sign(input.y))
 move_and_slide(); GameState.player_position=global_position; queue_redraw()
func _draw():
 if appearance_mode=="spacecraft":
  draw_colored_polygon(PackedVector2Array([Vector2(0,-20),Vector2(-15,14),Vector2(0,8),Vector2(15,14)]),Color("d9c06b"));draw_rect(Rect2(-6,-4,12,14),Color("4b88a5"));draw_line(Vector2(-8,14),Vector2(-8,23),Color("79d9e1"),4);draw_line(Vector2(8,14),Vector2(8,23),Color("79d9e1"),4);return
 if appearance_mode in ["ground","boat","aircraft"]:
  var c=Color("b77a48") if appearance_mode=="ground" else (Color("4e8eaa") if appearance_mode=="boat" else Color("c6b86b"));draw_rect(Rect2(-18,-10,36,24),c);draw_colored_polygon(PackedVector2Array([Vector2(-24,2),Vector2(0,-20),Vector2(24,2)]),c.lightened(.15));return
 _draw_oval(Vector2(0,15),Vector2(10,4),Color(0,0,0,0.25))
 draw_rect(Rect2(-9,-5,18,22),Color("315b8a"),true); draw_polygon(PackedVector2Array([Vector2(-11,-4),Vector2(0,-18),Vector2(11,-4)]),PackedColorArray([Color("d6a63d")]))
 draw_circle(Vector2(0,-7),7,Color("f3c89e")); draw_rect(Rect2(-7,-13,14,6),Color("392f45")); draw_line(Vector2(-7,6),Vector2(-8,17),Color("27374f"),5); draw_line(Vector2(7,6),Vector2(8,17),Color("27374f"),5)
 draw_circle(facing*5+Vector2(0,-6),1.4,Color("17212b"))
func _draw_oval(center:Vector2,radii:Vector2,color:Color):
 var pts=PackedVector2Array(); for i in 20: pts.append(center+Vector2(cos(i*TAU/20.0)*radii.x,sin(i*TAU/20.0)*radii.y)); draw_colored_polygon(pts,color)

