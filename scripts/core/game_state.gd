extends Node

signal state_changed
const HERO_NAME := "Ari"
const ITEMS := {
 "sunleaf_tonic":{"name":"Sunleaf Tonic","description":"A bright herbal restorative for a road-worn traveler.","type":"Consumable","price":18},
 "clearwater_salt":{"name":"Clearwater Salt","description":"Sharp-smelling salts carried by marsh guides.","type":"Consumable","price":12},
 "reed_sword":{"name":"Reedsteel Sword","description":"A balanced local blade with a woven green grip.","type":"Weapon","price":90},
 "ash_staff":{"name":"Ashwood Staff","description":"A sturdy staff capped in river-polished brass.","type":"Weapon","price":76},
 "wayfarer_vest":{"name":"Wayfarer Vest","description":"Light leather armor sewn for long journeys.","type":"Armor","price":68},
 "lantern_charm":{"name":"Lantern Charm","description":"A tiny blue-glass lantern said to guide travelers home.","type":"Accessory","price":54}
}
var crowns := 140
var inventory := {"sunleaf_tonic":2,"clearwater_salt":1}
var current_location := "Larkspur"
var player_position := Vector2(730, 850)
var play_seconds := 0.0
var flags := {}

func _process(delta): play_seconds += delta
func reset():
 crowns=140; inventory={"sunleaf_tonic":2,"clearwater_salt":1}; current_location="Larkspur"; player_position=Vector2(730,850); play_seconds=0; flags={}; state_changed.emit()
func buy(id:String, price:int)->bool:
 if crowns < price: return false
 crowns -= price; inventory[id]=inventory.get(id,0)+1; state_changed.emit(); return true
func serialize()->Dictionary:
 return {"version":1,"hero":HERO_NAME,"crowns":crowns,"inventory":inventory,"location":current_location,"position":[player_position.x,player_position.y],"play_seconds":play_seconds,"flags":flags}
func restore(data:Dictionary):
 crowns=int(data.get("crowns",140)); inventory=data.get("inventory",{}); current_location=str(data.get("location","Larkspur")); var p=data.get("position",[730,850]); player_position=Vector2(float(p[0]),float(p[1])); play_seconds=float(data.get("play_seconds",0)); flags=data.get("flags",{}); state_changed.emit()
