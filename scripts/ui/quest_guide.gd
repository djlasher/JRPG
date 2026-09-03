class_name QuestGuide
extends Control
var tracked_player:Node2D
var map_id:String
var interactables:Array[Dictionary]
var world_size:Vector2
func setup(id:String,player_node:Node2D,source:Array[Dictionary],map_size:Vector2):map_id=id;tracked_player=player_node;interactables=source;world_size=map_size;mouse_filter=Control.MOUSE_FILTER_IGNORE;position=Vector2.ZERO;size=Vector2(640,360)
func _process(_delta):queue_redraw()
func _target()->Vector2:
 var quest=GameState.QUESTS.get(GameState.tracked_quest,{})
 if quest.is_empty():return Vector2.INF
 for it in interactables:
  var payload:Dictionary=it.payload;var matches=quest.type=="defeat_specific" and it.kind=="battle" and payload.get("enemy","")==quest.target
  matches=matches or payload.get("id","")==quest.target or payload.get("target","")==quest.target
  if quest.type=="visit" and it.kind=="travel" and payload.get("id","")==quest.target:matches=true
  if matches:return it.position
 return Vector2(world_size.x/2,world_size.y-50)
func _draw():
 if not tracked_player or GameState.tracked_quest=="":return
 var target=_target();if target==Vector2.INF:return
 var delta=target-tracked_player.global_position;var angle=delta.angle();var center=Vector2(size.x/2,24);var direction=Vector2.RIGHT.rotated(angle)
 var tip=center+direction*15;var side=direction.orthogonal()*8;draw_colored_polygon(PackedVector2Array([tip,center-direction*10+side,center-direction*10-side]),Color("ffd45c"));draw_circle(center,22,Color("17223bdd"),false,3);var q=GameState.QUESTS[GameState.tracked_quest];draw_string(ThemeDB.fallback_font,Vector2(12,58),"TRACKED: %s — %dm"%[q.name,int(delta.length()/10)],0,500,13,Color("fff0b0"))

