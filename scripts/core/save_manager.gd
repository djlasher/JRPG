extends Node

const SAVE_PATH := "user://larkspur_save.json"
var last_error := ""
func has_save()->bool: return FileAccess.file_exists(SAVE_PATH)
func save_game()->bool:
 var f=FileAccess.open(SAVE_PATH,FileAccess.WRITE)
 if f==null: last_error="Could not open save file."; return false
 f.store_string(JSON.stringify(GameState.serialize(),"  ")); last_error=""; return true
func load_game()->bool:
 if not has_save(): last_error="No save found."; return false
 var f=FileAccess.open(SAVE_PATH,FileAccess.READ)
 if f==null:last_error="The save file could not be opened.";return false
 var parsed=JSON.parse_string(f.get_as_text())
 if not parsed is Dictionary or int(parsed.get("version",0))<1 or int(parsed.get("version",0))>6: last_error="The save is unreadable or incompatible."; return false
 if not parsed.has("inventory") or not parsed.has("position"):last_error="The save is incomplete.";return false
 GameState.restore(parsed);last_error="";return true

