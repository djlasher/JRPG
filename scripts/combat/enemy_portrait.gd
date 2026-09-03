class_name EnemyPortrait
extends Control
var enemy_id:String
var enemy_color:Color
func setup(id:String,color:Color):enemy_id=id;enemy_color=color;custom_minimum_size=Vector2(125,160);mouse_filter=Control.MOUSE_FILTER_IGNORE;queue_redraw()
func _draw():
 var p=Vector2(size.x/2,size.y*.58);_draw_oval(p+Vector2(0,38),Vector2(42,10),Color(0,0,0,.3))
 if enemy_id in ["mossling","briarback","river_wisp"]:
  draw_circle(p,40,enemy_color);draw_circle(p+Vector2(-20,-18),24,enemy_color.lightened(.12));draw_circle(p+Vector2(20,-18),24,enemy_color.lightened(.12));draw_circle(p+Vector2(-13,-10),5,Color.WHITE);draw_circle(p+Vector2(13,-10),5,Color.WHITE);draw_circle(p+Vector2(-13,-10),2,Color("17212b"));draw_circle(p+Vector2(13,-10),2,Color("17212b"))
 elif enemy_id in ["gloomwing","lantern_moth"]:
  draw_colored_polygon(PackedVector2Array([p+Vector2(-55,0),p+Vector2(-15,-35),p,p+Vector2(15,-35),p+Vector2(55,0),p+Vector2(0,28)]),enemy_color);draw_circle(p,18,enemy_color.lightened(.2));draw_circle(p+Vector2(-6,-3),3,Color.WHITE);draw_circle(p+Vector2(6,-3),3,Color.WHITE)
 elif enemy_id=="stonejaw":
  draw_circle(p,38,enemy_color);for x in [-30,-12,12,30]:draw_line(p+Vector2(x,18),p+Vector2(x+sign(x)*18,40),enemy_color.lightened(.2),8);draw_circle(p+Vector2(-14,-18),5,Color.WHITE);draw_circle(p+Vector2(14,-18),5,Color.WHITE)
 else:
  draw_rect(Rect2(p-Vector2(30,45),Vector2(60,90)),enemy_color);draw_circle(p+Vector2(0,-52),25,enemy_color.lightened(.15));draw_line(p+Vector2(-25,35),p+Vector2(-42,64),enemy_color,10);draw_line(p+Vector2(25,35),p+Vector2(42,64),enemy_color,10)
func _draw_oval(center:Vector2,radii:Vector2,color:Color):
 var points=PackedVector2Array();for i in 24:points.append(center+Vector2(cos(i*TAU/24.0)*radii.x,sin(i*TAU/24.0)*radii.y));draw_colored_polygon(points,color)

