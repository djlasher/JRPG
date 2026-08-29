extends Node
signal state_changed
signal quest_updated(id:String)
const HERO_NAME:="Ari"
const ITEMS={
"sunleaf_tonic":{"name":"Sunleaf Tonic","description":"Restores 35 HP.","type":"Consumable","price":18,"hp":35},"clearwater_salt":{"name":"Clearwater Salt","description":"Restores 12 MP.","type":"Consumable","price":12,"mp":12},
"reed_sword":{"name":"Reedsteel Sword","description":"A balanced Larkspur blade.","type":"Weapon","price":90,"attack":4},"ash_staff":{"name":"Ashwood Staff","description":"A brass-capped channeling staff.","type":"Weapon","price":76,"magic":4},"wayfarer_vest":{"name":"Wayfarer Vest","description":"Light road armor.","type":"Armor","price":68,"defense":3},"lantern_charm":{"name":"Lantern Charm","description":"Blue glass steadies its bearer.","type":"Accessory","price":54,"resistance":2,"max_mp":4},
"marsh_blade":{"name":"Marshglass Blade","description":"A keen green sword from Brackenford.","type":"Weapon","price":180,"attack":8},"quarry_mail":{"name":"Quarry Mail","description":"Layered slate-ring protection.","type":"Armor","price":165,"defense":7},"wind_knot":{"name":"Wind-knot Brooch","description":"Rare silver and skyglass.","type":"Accessory","price":240,"speed":5},"moon_moss":{"name":"Moon Moss","description":"Pale moss sought by healers.","type":"Quest","price":0},"guild_seal":{"name":"Wayfarers' Seal","description":"Proof of guild service.","type":"Key","price":0}}
const SKILLS={"lantern_cut":{"name":"Lantern Cut","description":"A forceful arc of steel.","cost":4,"power":1.6,"kind":"damage"},"ember_spark":{"name":"Ember Spark","description":"A mote of guiding flame.","cost":6,"power":1.8,"kind":"magic"},"waylight_mend":{"name":"Waylight Mend","description":"Restore 45 HP.","cost":7,"power":45,"kind":"heal"}}
const QUESTS={
"first_road":{"name":"Beyond the South Lantern","description":"Reach Brackenford and report to Warden Elowen.","giver":"Captain Brann","type":"visit","target":"brackenford","count":1,"reward":{"crowns":80,"item":"guild_seal"},"category":"Main"},
"lost_satchel":{"name":"Pears by the Wayside","description":"Recover Nessa's satchel from a regional chest.","giver":"Nessa","type":"interact","target":"satchel_chest","count":1,"reward":{"crowns":45,"item":"sunleaf_tonic"},"category":"Side"},
"thorn_problem":{"name":"Thorns at Highmeadow","description":"Defeat 3 Briarbacks near the farms.","giver":"Farmer Rell","type":"defeat_specific","target":"briarback","count":3,"reward":{"crowns":75,"item":"wayfarer_vest"},"category":"Guild"},
"cave_wings":{"name":"Wings Below","description":"Defeat 4 Gloomwings in Echoing Grotto.","giver":"Larkspur Board","type":"defeat_specific","target":"gloomwing","count":4,"reward":{"crowns":90,"item":"clearwater_salt"},"category":"Guild"},
"medicine_run":{"name":"A Bottle Before Sundown","description":"Reach the injured traveler by the west bridge.","giver":"Sister Alia","type":"visit","target":"injured_traveler","count":1,"reward":{"crowns":55},"category":"Side"},
"mine_silence":{"name":"The Silent Pick","description":"Defeat the Stonewarden in Stillpick Mine.","giver":"Foreman Dena","type":"defeat_specific","target":"stonewarden","count":1,"reward":{"crowns":180,"item":"quarry_mail"},"category":"Main"},
"moon_moss":{"name":"Light in the Moss","description":"Collect 3 clumps of Moon Moss.","giver":"Herbalist Ossa","type":"collect","target":"moon_moss","count":3,"reward":{"crowns":100,"item":"lantern_charm"},"category":"Side"},
"bandit_ledgers":{"name":"Ink on the Old Road","description":"Defeat 3 Roadshades who stole guild ledgers.","giver":"Brackenford Board","type":"defeat_specific","target":"roadshade","count":3,"reward":{"crowns":130,"item":"marsh_blade"},"category":"Guild"},
"ruin_lights":{"name":"Lanterns Without Hands","description":"Examine 3 ghost lights at Glassmere Ruins.","giver":"Scholar Pell","type":"interact","target":"ghost_light","count":3,"reward":{"crowns":95},"category":"Side"},
"lake_beast":{"name":"Teeth Beneath Still Water","description":"Defeat the Mire-Crowned Hart.","giver":"Mosswick Board","type":"defeat_specific","target":"mire_hart","count":1,"reward":{"crowns":260,"item":"wind_knot"},"category":"Guild"},
"missing_scout":{"name":"The Unreturned Scout","description":"Find scout Lio in Stillpick Mine.","giver":"Brackenford Board","type":"visit","target":"scout_lio","count":1,"reward":{"crowns":110},"category":"Guild"},
"old_arch":{"name":"Under the Stone Arch","description":"Find Pip's keepsake beneath the giant arch.","giver":"Pip","type":"interact","target":"arch_keepsake","count":1,"reward":{"crowns":40,"item":"wind_knot"},"category":"Side"}}
var crowns:=140
var inventory:Dictionary={"sunleaf_tonic":2,"clearwater_salt":1,"reed_sword":1,"wayfarer_vest":1}
var equipment:Dictionary={"Weapon":"reed_sword","Armor":"wayfarer_vest","Accessory":""}
var current_location:="Larkspur"
var player_position:=Vector2(730,850)
var play_seconds:=0.0
var flags:Dictionary={}
var quests:Dictionary={}
var opened_treasures:Array[String]=[]
var defeated_bosses:Array[String]=[]
var world_events:Array[String]=[]
var level:=1
var experience:=0
var hp:=85
var mp:=22
var base_stats:Dictionary={"max_hp":85,"max_mp":22,"attack":12,"defense":8,"magic":10,"resistance":7,"speed":10}
func _process(delta):play_seconds+=delta
func reset():
 crowns=140;inventory={"sunleaf_tonic":2,"clearwater_salt":1,"reed_sword":1,"wayfarer_vest":1};equipment={"Weapon":"reed_sword","Armor":"wayfarer_vest","Accessory":""};current_location="Larkspur";player_position=Vector2(730,850);play_seconds=0;flags={};quests={};opened_treasures=[];defeated_bosses=[];world_events=[];level=1;experience=0;base_stats={"max_hp":85,"max_mp":22,"attack":12,"defense":8,"magic":10,"resistance":7,"speed":10};hp=85;mp=22;state_changed.emit()
func stat(key:String)->int:
 var value=int(base_stats.get(key,0))
 for id in equipment.values():
  if id!="":value+=int(ITEMS.get(id,{}).get(key,0))
 return value
func buy(id:String,price:int)->bool:
 if crowns<price:return false
 crowns-=price;inventory[id]=inventory.get(id,0)+1;state_changed.emit();return true
func equip(id:String)->bool:
 if inventory.get(id,0)<1:return false
 var slot=str(ITEMS.get(id,{}).get("type",""));if slot not in equipment:return false
 equipment[slot]=id;state_changed.emit();return true
func add_item(id:String,count:=1):inventory[id]=inventory.get(id,0)+count;track("collect",id,count);state_changed.emit()
func accept_quest(id:String):
 if id in QUESTS and id not in quests:quests[id]={"status":"Active","progress":0};quest_updated.emit(id)
func track(type:String,target:String,amount:=1):
 for id in quests:
  var q=QUESTS.get(id,{});var s=quests[id]
  if s.status=="Active" and q.type==type and q.target==target:s.progress=min(int(q.count),int(s.progress)+amount);if s.progress>=int(q.count):s.status="Ready";quest_updated.emit(id)
func turn_in(id:String)->bool:
 if not quests.has(id) or quests[id].status!="Ready":return false
 var reward=QUESTS[id].reward
 crowns+=int(reward.get("crowns",0))
 if reward.has("item"):add_item(reward.item)
 quests[id].status="Completed"
 quest_updated.emit(id)
 return true
func gain_rewards(exp:int,money:int)->Array[String]:
 experience+=exp;crowns+=money;var notes:Array[String]=[]
 while experience>=level*60:
  experience-=level*60;level+=1;base_stats.max_hp+=12;base_stats.max_mp+=4;base_stats.attack+=3;base_stats.defense+=2;base_stats.magic+=2;base_stats.resistance+=2;base_stats.speed+=1;hp=stat("max_hp");mp=stat("max_mp");notes.append("Ari reached level %d!"%level)
 state_changed.emit();return notes
func serialize()->Dictionary:return {"version":2,"hero":HERO_NAME,"crowns":crowns,"inventory":inventory,"equipment":equipment,"location":current_location,"position":[player_position.x,player_position.y],"play_seconds":play_seconds,"flags":flags,"quests":quests,"opened_treasures":opened_treasures,"defeated_bosses":defeated_bosses,"world_events":world_events,"level":level,"experience":experience,"hp":hp,"mp":mp,"base_stats":base_stats}
func restore(d:Dictionary):
 crowns=int(d.get("crowns",140))
 inventory=d.get("inventory",{})
 equipment=d.get("equipment",{"Weapon":"","Armor":"","Accessory":""})
 current_location=str(d.get("location","Larkspur"))
 var saved_position=d.get("position",[730,850])
 player_position=Vector2(float(saved_position[0]),float(saved_position[1]))
 play_seconds=float(d.get("play_seconds",0))
 flags=d.get("flags",{})
 quests=d.get("quests",{})
 opened_treasures.clear()
 for treasure_id in d.get("opened_treasures",[]):opened_treasures.append(str(treasure_id))
 defeated_bosses.clear()
 for boss_id in d.get("defeated_bosses",[]):defeated_bosses.append(str(boss_id))
 world_events.clear()
 for event_id in d.get("world_events",[]):world_events.append(str(event_id))
 level=int(d.get("level",1))
 experience=int(d.get("experience",0))
 var saved_stats=d.get("base_stats",{})
 for key in saved_stats:base_stats[key]=int(saved_stats[key])
 hp=int(d.get("hp",stat("max_hp")))
 mp=int(d.get("mp",stat("max_mp")))
 state_changed.emit()

