extends Node

var world:Node2D
var ui:GameUI
var fade:ColorRect
var title_layer:CanvasLayer
var current_building:Dictionary={}

func _ready(): ui=GameUI.new();add_child(ui);ui.quit_to_title.connect(show_title); _make_fade(); show_title()
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
func _continue(): if SaveManager.load_game(): _enter_town()
func _enter_town():
 if title_layer: title_layer.queue_free();title_layer=null
 world=Town.new();add_child(world);world.interaction_requested.connect(_interaction);var cam=Camera2D.new();world.player.add_child(cam);cam.position=Vector2.ZERO;cam.limit_left=0;cam.limit_top=0;cam.limit_right=1600;cam.limit_bottom=1200;cam.position_smoothing_enabled=true;cam.position_smoothing_speed=7;GameState.current_location="Larkspur"
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
 elif kind=="exit": ui.feedback("The south road beyond Larkspur is not available yet.")
 if kind!="door": ui.dialogue_closed.connect(_unlock,CONNECT_ONE_SHOT)
func _unlock(): if world: world.player.enabled=true
func _transition_to_interior():
 await _fade_to(1); world.queue_free();var interior=Interior.new();interior.setup(current_building.id,current_building.name);add_child(interior);world=interior;interior.interaction_requested.connect(_interaction);interior.exit_requested.connect(_leave_interior);GameState.current_location=current_building.name;await _fade_to(0)
func _leave_interior():
 await _fade_to(1);world.queue_free();GameState.player_position=Vector2(current_building.get("door",Vector2(750,850)));_enter_town();var b=Town.BUILDINGS.filter(func(x):return x.id==current_building.id)[0];world.player.position=b.door+Vector2(0,35);await _fade_to(0)
func _fade_to(alpha:float): var tw=create_tween();tw.tween_property(fade,"modulate:a",alpha,.25);await tw.finished
func _save_prompt():
 ui._base("Waylight",Vector2(500,220),Vector2(70,80));ui.mode="menu";ui.body.text="The waylight remembers where travelers have been. Record your journey?";for text in ["Save journey","Not now"]:var b=Button.new();b.text=text;ui.buttons.add_child(b);ui.buttons.get_child(0).pressed.connect(_do_save);ui.buttons.get_child(1).pressed.connect(ui._close);ui.buttons.get_child(0).grab_focus()
func _do_save(): ui.body.text="Your journey is held safely in the waylight." if SaveManager.save_game() else SaveManager.last_error;for c in ui.buttons.get_children():c.queue_free()
