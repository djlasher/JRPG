extends Node

var world:Node2D
var ui:GameUI
var fade:ColorRect
var title_layer:CanvasLayer
var current_building:Dictionary={}
var previous_map_id:="region"

func _ready():ui=GameUI.new();add_child(ui);ui.quit_to_title.connect(show_title);ui.travel_requested.connect(_fast_travel);_make_fade();show_title()
func _make_fade(): fade=ColorRect.new();fade.color=Color.BLACK;fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);fade.mouse_filter=Control.MOUSE_FILTER_IGNORE;fade.modulate.a=0;var c=CanvasLayer.new();c.layer=100;add_child(c);c.add_child(fade)
func show_title():
 if world: world.queue_free(); world=null
 ui.clear(); title_layer=CanvasLayer.new();add_child(title_layer);var bg=ColorRect.new();bg.color=Color("17283a");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);title_layer.add_child(bg)
 var v=VBoxContainer.new();v.position=Vector2(150,72);v.size=Vector2(340,240);v.alignment=BoxContainer.ALIGNMENT_CENTER;title_layer.add_child(v)
 var t=Label.new();t.text="LANTERNS OF LARKSPUR";t.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;t.add_theme_font_size_override("font_size",28);t.add_theme_color_override("font_color",Color("f2c75c"));v.add_child(t)
 var sub=Label.new();sub.text="A quiet road. A steadfast light.";sub.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;v.add_child(sub)
 for option in ["NEW GAME","CONTINUE","QUIT"]:
  var b=Button.new();b.text=option;b.custom_minimum_size.y=38;v.add_child(b)
 v.get_child(2).pressed.connect(_new_game);v.get_child(3).pressed.connect(_continue);v.get_child(3).disabled=not SaveManager.has_save();v.get_child(4).pressed.connect(get_tree().quit);v.get_child(2).grab_focus()
func _new_game(): GameState.reset(); _enter_town()
func _continue():
 if SaveManager.load_game():
  var saved_map=str(GameState.flags.get("map_id","town"))
  if saved_map=="town":_enter_town()
  else:_enter_adventure(saved_map,true)
 else:
  ui.feedback("Continue failed: "+SaveManager.last_error)
func _enter_town():
 if title_layer: title_layer.queue_free();title_layer=null
 if world:world.queue_free()
 world=Town.new();add_child(world);world.interaction_requested.connect(_interaction);var cam=Camera2D.new();world.player.add_child(cam);cam.position=Vector2.ZERO;cam.limit_left=0;cam.limit_top=0;cam.limit_right=1600;cam.limit_bottom=1200;cam.position_smoothing_enabled=true;cam.position_smoothing_speed=7;GameState.current_location="Larkspur";GameState.flags.map_id="town"
func _process(_delta):
 if not world or ui.panel: return
 if Input.is_action_just_pressed("interact"): world.try_interact()
 if Input.is_action_just_pressed("pause"): world.player.enabled=false;ui.pause_menu();ui.dialogue_closed.connect(_unlock,CONNECT_ONE_SHOT)
func _unhandled_input(event):
 # Godot Buttons normally consume ui_accept. This fallback also honors the
 # project's explicit confirm action for controllers with unusual mappings.
 if title_layer and event.is_action_pressed("confirm"):
  var focused=get_viewport().gui_get_focus_owner()
  if focused is Button and not focused.disabled:
   focused.pressed.emit()
   get_viewport().set_input_as_handled()
func _interaction(kind:String,payload:Dictionary):
 world.player.enabled=false
 if kind=="npc" or kind=="landmark": ui.dialogue(payload.get("name",""),payload.get("lines",[]),payload.get("actor"))
 elif kind=="door": current_building=payload; _transition_to_interior()
 elif kind=="shop": ui.shop(payload.id,payload.name)
 elif kind=="inn": ui.inn()
 elif kind=="save": _save_prompt()
 elif kind=="exit": _enter_adventure("region")
 elif kind=="return": _enter_town_from_region()
 elif kind=="return_region": _enter_adventure("region")
 elif kind=="travel": _enter_adventure(payload.id)
 elif kind=="battle": _start_battle(payload.enemy)
 elif kind=="treasure": _open_treasure(payload)
 elif kind=="event": _world_event(payload)
 elif kind=="guild": ui.guild_board(payload.town)
 elif kind=="recruit":GameState.recruit(payload.id);ui.feedback(payload.text+"\n\n%s joined the party."%GameState.PARTY_DEFS[payload.id].name)
 elif kind=="puzzle":GameState.puzzle_states[payload.id]=true;ui.feedback(payload.text)
 if kind!="door": ui.dialogue_closed.connect(_unlock,CONNECT_ONE_SHOT)
func _unlock(): if world: world.player.enabled=true
func _transition_to_interior():
 await _fade_to(1); world.queue_free();var interior=Interior.new();interior.setup(current_building.id,current_building.name);add_child(interior);world=interior;interior.interaction_requested.connect(_interaction);interior.exit_requested.connect(_leave_interior);GameState.current_location=current_building.name;await _fade_to(0)
func _leave_interior():
 await _fade_to(1);world.queue_free();GameState.player_position=Vector2(current_building.get("door",Vector2(750,850)));_enter_town();var b=Town.BUILDINGS.filter(func(x):return x.id==current_building.id)[0];world.player.position=b.door+Vector2(0,35);await _fade_to(0)
func _enter_adventure(id:String,restore_position:=false):
 await _fade_to(1)
 if title_layer:title_layer.queue_free();title_layer=null
 if world:world.queue_free()
 var map=AdventureMap.new();map.setup(id);add_child(map);world=map;map.interaction_requested.connect(_interaction);map.return_requested.connect(_adventure_auto_return)
 if restore_position:map.player.position=GameState.player_position
 var cam=Camera2D.new();map.player.add_child(cam);cam.limit_left=0;cam.limit_top=0;cam.limit_right=int(map.size.x);cam.limit_bottom=int(map.size.y);cam.position_smoothing_enabled=true;cam.position_smoothing_speed=7
 previous_map_id=id;GameState.current_location=map.title;GameState.flags.map_id=id;GameState.discover_location(id);GameState.player_position=map.player.position;await _fade_to(0)
func _fast_travel(id:String):
 get_tree().paused=false;ui.clear()
 if id=="town":_enter_town_from_region()
 else:_enter_adventure(id)
func _adventure_auto_return():
 if previous_map_id=="region":_enter_town_from_region()
 else:_enter_adventure("region")
func _enter_town_from_region():GameState.player_position=Vector2(760,1080);_enter_town()
func _start_battle(enemy:String):
 var battle=BattleUI.new();battle.setup(enemy);add_child(battle);battle.battle_finished.connect(_battle_done)
func _battle_done(victory:bool,enemy:String):
 if enemy=="game_over":ui._base("The Waylight Fades",Vector2(500,220),Vector2(70,80));ui.mode="menu";ui.body.text="Ari's strength is spent. Return to the title and continue from the last Waylight.";var b=Button.new();b.text="Return to title";b.pressed.connect(show_title);ui.buttons.add_child(b);b.grab_focus();return
 if victory and world is AdventureMap:world.remove_near("battle")
 if world:world.player.enabled=true
func _open_treasure(payload:Dictionary):
 if payload.id in GameState.opened_treasures:_unlock();return
 GameState.opened_treasures.append(payload.id);GameState.add_item(payload.item,int(payload.count));GameState.track("interact",payload.id);if world is AdventureMap:world.remove_near("treasure");ui.feedback("Treasure found: %s ×%d"%[GameState.ITEMS[payload.item].name,payload.count]);ui.dialogue_closed.connect(_unlock,CONNECT_ONE_SHOT)
func _world_event(payload:Dictionary):
 if payload.id not in GameState.world_events:GameState.world_events.append(payload.id);GameState.track("visit",payload.get("target",payload.id));GameState.track("interact",payload.get("target",payload.id))
 ui.feedback(payload.text);ui.dialogue_closed.connect(_unlock,CONNECT_ONE_SHOT)
func _fade_to(alpha:float): var tw=create_tween();tw.tween_property(fade,"modulate:a",alpha,.25);await tw.finished
func _save_prompt():
 ui._base("Waylight",Vector2(500,220),Vector2(70,80))
 ui.mode="menu"
 ui.body.text="The waylight remembers where travelers have been. Record your journey?"
 var save_button=Button.new()
 save_button.text="Save journey"
 ui.buttons.add_child(save_button)
 var cancel_button=Button.new()
 cancel_button.text="Not now"
 ui.buttons.add_child(cancel_button)
 save_button.pressed.connect(_do_save)
 cancel_button.pressed.connect(ui._close)
 save_button.grab_focus()
func _do_save():
 var saved=SaveManager.save_game()
 ui.body.text="Your journey is held safely in the waylight." if saved else "The waylight could not record your journey: %s"%SaveManager.last_error
 for child in ui.buttons.get_children():
  child.queue_free()

