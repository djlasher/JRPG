extends Node
signal state_changed
signal quest_updated(id:String)
const HERO_NAME:="Ari"
const ITEMS={
"sunleaf_tonic":{"name":"Sunleaf Tonic","description":"Restores 35 HP.","type":"Consumable","price":18,"hp":35},"clearwater_salt":{"name":"Clearwater Salt","description":"Restores 12 MP.","type":"Consumable","price":12,"mp":12},
"reed_sword":{"name":"Reedsteel Sword","description":"A balanced Larkspur blade.","type":"Weapon","price":90,"attack":4},"ash_staff":{"name":"Ashwood Staff","description":"A brass-capped channeling staff.","type":"Weapon","price":76,"magic":4},"wayfarer_vest":{"name":"Wayfarer Vest","description":"Light road armor.","type":"Armor","price":68,"defense":3},"lantern_charm":{"name":"Lantern Charm","description":"Blue glass steadies its bearer.","type":"Accessory","price":54,"resistance":2,"max_mp":4},
"marsh_blade":{"name":"Marshglass Blade","description":"A keen green sword from Brackenford.","type":"Weapon","price":180,"attack":8},"quarry_mail":{"name":"Quarry Mail","description":"Layered slate-ring protection.","type":"Armor","price":165,"defense":7},"wind_knot":{"name":"Wind-knot Brooch","description":"Rare silver and skyglass.","type":"Accessory","price":240,"speed":5},"moon_moss":{"name":"Moon Moss","description":"Pale moss sought by healers.","type":"Quest","price":0},"guild_seal":{"name":"Wayfarers' Seal","description":"Proof of guild service.","type":"Key","price":0},
"field_bread":{"name":"Field Bread","description":"Restores 18 HP. Cheap road food.","type":"Consumable","price":6,"hp":18,"level":1},"reed_cap":{"name":"Reedweave Cap","description":"Simple protection for a first journey.","type":"Head","slot":"Head","price":28,"defense":1,"rating":6,"level":1},"padded_gloves":{"name":"Padded Gloves","description":"Firm grip and modest protection.","type":"Hands","slot":"Hands","price":32,"attack":1,"rating":7,"level":1},"road_boots":{"name":"Road Boots","description":"Made for Lanternvale's muddy paths.","type":"Feet","slot":"Feet","price":35,"speed":1,"rating":7,"level":1},"copper_charm":{"name":"Copper Waylight Charm","description":"A beginner's ward against road magic.","type":"Accessory","slot":"Accessory1","price":42,"resistance":2,"rating":8,"level":1}}
const SKILLS={"lantern_cut":{"name":"Lantern Cut","description":"A forceful arc of steel.","cost":4,"power":1.6,"kind":"damage"},"ember_spark":{"name":"Ember Spark","description":"A mote of guiding flame.","cost":6,"power":1.8,"kind":"magic"},"waylight_mend":{"name":"Waylight Mend","description":"Restore 45 HP.","cost":7,"power":45,"kind":"heal"}}
const QUESTS={
"first_road":{"name":"Beyond the South Lantern","description":"Reach Brackenford and report to Warden Elowen.","giver":"Captain Brann","type":"visit","target":"brackenford","count":1,"reward":{"crowns":80,"item":"guild_seal"},"category":"Main"},
"lost_satchel":{"name":"Pears by the Wayside","description":"Recover Nessa's satchel from a regional chest.","giver":"Nessa","type":"interact","target":"satchel_chest","count":1,"reward":{"crowns":45,"item":"sunleaf_tonic"},"category":"Side"},
"thorn_problem":{"name":"Thorns at Highmeadow","description":"Clear 3 Thorn Slimes from Highmeadow's irrigation beds.","giver":"Farmer Rell","type":"defeat_specific","target":"briarback","count":3,"reward":{"crowns":75,"item":"wayfarer_vest"},"category":"Guild"},
"cave_wings":{"name":"Wings Below","description":"Drive 4 Cave Bats from Echoing Grotto before they reach the grain stores.","giver":"Larkspur Board","type":"defeat_specific","target":"gloomwing","count":4,"reward":{"crowns":90,"item":"clearwater_salt"},"category":"Guild"},
"medicine_run":{"name":"A Bottle Before Sundown","description":"Reach the injured traveler by the west bridge.","giver":"Sister Alia","type":"visit","target":"injured_traveler","count":1,"reward":{"crowns":55},"category":"Side"},
"mine_silence":{"name":"The Silent Pick","description":"Defeat the Stonewarden in Stillpick Mine.","giver":"Foreman Dena","type":"defeat_specific","target":"stonewarden","count":1,"reward":{"crowns":180,"item":"quarry_mail"},"category":"Main"},
"moon_moss":{"name":"Light in the Moss","description":"Collect 3 clumps of Moon Moss.","giver":"Herbalist Ossa","type":"collect","target":"moon_moss","count":3,"reward":{"crowns":100,"item":"lantern_charm"},"category":"Side"},
"bandit_ledgers":{"name":"Ink on the Old Road","description":"Defeat 3 Roadshades who stole guild ledgers.","giver":"Brackenford Board","type":"defeat_specific","target":"roadshade","count":3,"reward":{"crowns":130,"item":"marsh_blade"},"category":"Guild"},
"ruin_lights":{"name":"Lanterns Without Hands","description":"Examine 3 ghost lights at Glassmere Ruins.","giver":"Scholar Pell","type":"interact","target":"ghost_light","count":3,"reward":{"crowns":95},"category":"Side"},
"lake_beast":{"name":"Teeth Beneath Still Water","description":"Defeat the Mire-Crowned Hart.","giver":"Mosswick Board","type":"defeat_specific","target":"mire_hart","count":1,"reward":{"crowns":260,"item":"wind_knot"},"category":"Guild"},
"missing_scout":{"name":"The Unreturned Scout","description":"Find scout Lio in Stillpick Mine.","giver":"Brackenford Board","type":"visit","target":"scout_lio","count":1,"reward":{"crowns":110},"category":"Guild"},
"old_arch":{"name":"Under the Stone Arch","description":"Find Pip's keepsake beneath the giant arch.","giver":"Pip","type":"interact","target":"arch_keepsake","count":1,"reward":{"crowns":40,"item":"wind_knot"},"category":"Side"},
"slime_samples":{"name":"A Scholar's Slime Samples","description":"Defeat 3 Green Slimes on the safe road.","giver":"Archivist Vale","type":"defeat_specific","target":"mossling","count":3,"reward":{"crowns":36,"item":"field_bread"},"category":"Side"},
"thorn_jelly":{"name":"Jelly in the Furrows","description":"Clear 2 Thorn Slimes near Highmeadow.","giver":"Farmer Rell","type":"defeat_specific","target":"briarback","count":2,"reward":{"crowns":42,"item":"padded_gloves"},"category":"Side"},
"first_camp":{"name":"Tea at the Ferry Camp","description":"Find the hidden ferry camp east of the river road.","giver":"Maeve","type":"interact","target":"ferry_camp","count":1,"reward":{"crowns":30,"item":"clearwater_salt"},"category":"Rumor"},
"singing_stone_job":{"name":"The Note Beneath Stone","description":"Examine the singing standing stone.","giver":"Sister Alia","type":"interact","target":"singing_stone","count":1,"reward":{"crowns":35},"category":"Rumor"},
"bat_wings":{"name":"Soft Wings, Dark Tunnel","description":"Defeat 2 Cave Bats in Echoing Grotto.","giver":"Pip","type":"defeat_specific","target":"gloomwing","count":2,"reward":{"crowns":48,"item":"road_boots"},"category":"Guild"},
"broken_wheel":{"name":"The Patient Wagon","description":"Inspect the broken wagon beside the central road.","giver":"Orin","type":"interact","target":"broken_wagon","count":1,"reward":{"crowns":28,"item":"field_bread"},"category":"Side"}}
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
const PARTY_DEFS={
 "ari":{"name":"Ari","role":"Waylight Warden","color":"315b8a","skills":["lantern_cut","ember_spark","waylight_mend"]},
 "brann":{"name":"Brann","role":"Shield Captain","color":"496b78","skills":["shield_bash","hold_fast"]},
 "lyra":{"name":"Lyra Vale","role":"Tide Scholar","color":"785b9b","skills":["rillflare","tide_mend"]}}
var party:Array[String]=["ari"]
var party_state:Dictionary={"ari":{"level":1,"hp":85,"mp":22,"max_hp":85,"max_mp":22,"attack":16,"defense":11,"magic":10,"speed":10}}
var bestiary:Dictionary={}
var discovered_locations:Array[String]=["town"]
var fast_travel:Array[String]=["town"]
var puzzle_states:Dictionary={}
var guild_reputation:=0
const JOBS={
 "pathguard":{"name":"Pathguard","role":"Balanced arms and protection","mods":{"attack":1.1,"defense":1.1},"unlocks":[[1,"lantern_cut"],[3,"hold_fast"],[6,"shield_bash"]]},
 "flame_scholar":{"name":"Flame Scholar","role":"Offensive elemental magic","mods":{"magic":1.35,"max_mp":1.2},"unlocks":[[1,"ember_spark"],[4,"rillflare"],[7,"starfall"]]},
 "way_mender":{"name":"Way Mender","role":"Healing and spiritual support","mods":{"magic":1.2,"resistance":1.25},"unlocks":[[1,"waylight_mend"],[4,"tide_mend"],[8,"renewal"]]},
 "reed_ranger":{"name":"Reed Ranger","role":"Fast ranged pressure","mods":{"speed":1.3,"attack":1.1},"unlocks":[[1,"quickshot"],[5,"wind_mark"]]},
 "lantern_rogue":{"name":"Lantern Rogue","role":"Speed, tricks, and locks","mods":{"speed":1.4},"unlocks":[[1,"feint"],[4,"open_secret"]]},
 "stone_monk":{"name":"Stone Monk","role":"Durable unarmed fighter","mods":{"max_hp":1.2,"defense":1.15},"unlocks":[[1,"stone_palm"],[6,"still_mind"]]},
 "tide_engineer":{"name":"Tide Engineer","role":"Devices and party support","mods":{"defense":1.1,"magic":1.1},"unlocks":[[1,"field_repair"],[5,"shock_coil"]]},
 "star_priest":{"name":"Star Priest","role":"Light magic and wards","mods":{"max_mp":1.3,"resistance":1.3},"unlocks":[[1,"starlit_prayer"],[5,"ward_circle"]]},
 "beacon_knight":{"name":"Beacon Knight","role":"Advanced protector","advanced":true,"clue":"Master Pathguard and aid Lumenport","mods":{"attack":1.25,"defense":1.4},"unlocks":[[1,"beacon_wall"],[5,"radiant_oath"]]},
 "spellsteel":{"name":"Spellsteel","role":"Advanced weapon magic","advanced":true,"clue":"Study arms and flame","mods":{"attack":1.25,"magic":1.25},"unlocks":[[1,"ember_edge"],[6,"tideblade"]]},
 "sky_corsair":{"name":"Sky Corsair","role":"Aircraft-era speed fighter","advanced":true,"clue":"Acquire the Skydart","mods":{"speed":1.5,"attack":1.2},"unlocks":[[1,"dive_arc"],[5,"gale_salvo"]]},
 "void_cantor":{"name":"Void Cantor","role":"Secret dimensional caster","advanced":true,"secret":true,"clue":"Earn a contract in Hell","mods":{"magic":1.5,"resistance":1.2},"unlocks":[[1,"void_chime"],[7,"black_star"]]},
 "starwright":{"name":"Starwright","role":"Secret ship-support master","advanced":true,"secret":true,"clue":"Defeat a space bounty","mods":{"magic":1.25,"speed":1.25},"unlocks":[[1,"overcharge"],[6,"constellation_drive"]]}}
var job_state:Dictionary={"ari":{"current":"pathguard","levels":{"pathguard":1},"jp":{"pathguard":0},"learned":["lantern_cut"],"equipped":[]}}
var unlocked_jobs:Array[String]=["pathguard","flame_scholar","way_mender","reed_ranger","lantern_rogue","stone_monk","tide_engineer","star_priest"]
var relationships:Dictionary={"ari:brann":{"points":0,"romance":false,"adult":true},"ari:lyra":{"points":0,"romance":false,"adult":true},"brann:lyra":{"points":0,"romance":false,"adult":true}}
var relationship_events:Array[String]=[]
var vehicles:Dictionary={"ground":false,"boat":false,"aircraft":false,"spacecraft":false,"current":"foot"}
var ship:Dictionary={"name":"Waylight Comet","hull":180,"max_hull":180,"shields":70,"max_shields":70,"energy":60,"weapons":22,"armor":9,"speed":12,"upgrades":[]}
var known_planets:Array[String]=[]
var story_branches:Dictionary={}
var lattice_points:Dictionary={"ari":3}
var lattice_active:Dictionary={"ari":["lattice_000"]}
var generated_items:Dictionary={}
var chest_rolls:Dictionary={}
var tracked_quest:=""
var minigame_best:=0
func _process(delta):play_seconds+=delta
func reset():
 crowns=140;inventory={"sunleaf_tonic":2,"clearwater_salt":1,"reed_sword":1,"wayfarer_vest":1};equipment={"Weapon":"reed_sword","Armor":"wayfarer_vest","Accessory":""};current_location="Larkspur";player_position=Vector2(730,850);play_seconds=0;flags={};quests={};opened_treasures=[];defeated_bosses=[];world_events=[];level=1;experience=0;base_stats={"max_hp":85,"max_mp":22,"attack":12,"defense":8,"magic":10,"resistance":7,"speed":10};hp=85;mp=22;party=["ari"];party_state={"ari":{"level":1,"hp":85,"mp":22,"max_hp":85,"max_mp":22,"attack":16,"defense":11,"magic":10,"speed":10}};bestiary={};discovered_locations=["town"];fast_travel=["town"];puzzle_states={};guild_reputation=0;job_state={"ari":{"current":"pathguard","levels":{"pathguard":1},"jp":{"pathguard":0},"learned":["lantern_cut"],"equipped":[]}};unlocked_jobs=["pathguard","flame_scholar","way_mender","reed_ranger","lantern_rogue","stone_monk","tide_engineer","star_priest"];relationships={"ari:brann":{"points":0,"romance":false,"adult":true},"ari:lyra":{"points":0,"romance":false,"adult":true},"brann:lyra":{"points":0,"romance":false,"adult":true}};relationship_events=[];vehicles={"ground":false,"boat":false,"aircraft":false,"spacecraft":false,"current":"foot"};ship={"name":"Waylight Comet","hull":180,"max_hull":180,"shields":70,"max_shields":70,"energy":60,"weapons":22,"armor":9,"speed":12,"upgrades":[]};known_planets=[];story_branches={};state_changed.emit()
 lattice_points={"ari":3};lattice_active={"ari":["lattice_000"]};generated_items={};chest_rolls={};equipment={"Weapon":"reed_sword","Head":"","Body":"wayfarer_vest","Hands":"","Feet":"","Accessory1":"","Accessory2":""};quests["first_road"]={"status":"Active","progress":0};tracked_quest="first_road"
 tracked_quest="";minigame_best=0
func recruit(id:String):
 if id not in PARTY_DEFS or id in party:return
 party.append(id)
 if id=="brann":party_state[id]={"level":maxi(2,level),"hp":120,"mp":12,"max_hp":120,"max_mp":12,"attack":15,"defense":18,"magic":6,"speed":7}
 else:party_state[id]={"level":maxi(2,level),"hp":72,"mp":42,"max_hp":72,"max_mp":42,"attack":8,"defense":8,"magic":20,"speed":13}
 job_state[id]={"current":"pathguard" if id=="brann" else "flame_scholar","levels":{},"jp":{},"learned":[],"equipped":[]};job_state[id].levels[job_state[id].current]=1;job_state[id].jp[job_state[id].current]=0
 state_changed.emit()
func change_job(character:String,job_id:String)->bool:
 if character not in party or job_id not in unlocked_jobs:return false
 job_state[character].current=job_id
 if not job_state[character].levels.has(job_id):job_state[character].levels[job_id]=1;job_state[character].jp[job_id]=0
 state_changed.emit();return true
func gain_job_points(amount:int):
 for character in party:
  var js=job_state[character];var job_id=str(js.current);js.jp[job_id]=int(js.jp.get(job_id,0))+amount
  while int(js.levels.get(job_id,1))<10 and int(js.jp[job_id])>=int(js.levels.get(job_id,1))*30:
   js.jp[job_id]-=int(js.levels.get(job_id,1))*30;js.levels[job_id]=int(js.levels.get(job_id,1))+1
   for unlock in JOBS[job_id].unlocks:if int(unlock[0])<=int(js.levels[job_id]) and unlock[1] not in js.learned:js.learned.append(unlock[1])
func relationship_tier(key:String)->String:
 var points=int(relationships.get(key,{"points":0}).points);return "Kindled" if points>=80 else ("Close" if points>=55 else ("Trusted" if points>=30 else ("Friendly" if points>=12 else "Acquainted")))
func adjust_relationship(key:String,amount:int):if relationships.has(key):relationships[key].points=clampi(int(relationships[key].points)+amount,-50,100)
func discover_enemy(id:String,defeated:=false):
 var record=bestiary.get(id,{"seen":0,"defeated":0})
 record.seen+=1
 if defeated:record.defeated+=1
 bestiary[id]=record
func discover_location(id:String):
 if id not in discovered_locations:discovered_locations.append(id)
 if id not in fast_travel:fast_travel.append(id)
func stat(key:String)->int:
 var value=int(base_stats.get(key,0))
 if job_state.has("ari"):
  var job_id=str(job_state.ari.current);value=int(round(value*float(JOBS.get(job_id,{"mods":{}}).mods.get(key,1.0))))
 for id in equipment.values():
  if id!="":value+=int(item_data(id).get(key,item_data(id).get("stats",{}).get(key,0)))
 var nodes=ProgressionDatabase.build_grid()
 for node_id in lattice_active.get("ari",[]):if nodes.has(node_id) and nodes[node_id].type=="stat" and nodes[node_id].stat==key:value+=int(nodes[node_id].value)
 return value
func item_data(id:String)->Dictionary:return generated_items.get(id,ITEMS.get(id,{}))
func activate_lattice(character:String,node_id:String)->bool:
 var nodes=ProgressionDatabase.build_grid()
 if not nodes.has(node_id) or node_id in lattice_active.get(character,[]):return false
 var adjacent=false
 for active_id in lattice_active.get(character,[]):
  if node_id in nodes[active_id].links:adjacent=true
 var cost=int(nodes[node_id].cost)
 if not adjacent or int(lattice_points.get(character,0))<cost:return false
 lattice_points[character]-=cost
 lattice_active[character].append(node_id)
 if nodes[node_id].spell!="" and nodes[node_id].spell not in job_state[character].learned:
  job_state[character].learned.append(nodes[node_id].spell)
 state_changed.emit()
 return true
func roll_chest(chest_id:String,tier:=1)->Dictionary:
 if chest_rolls.has(chest_id):return generated_items[chest_rolls[chest_id]]
 var item=ProgressionDatabase.generate_loot(chest_id,tier);generated_items[item.instance_id]=item;inventory[item.instance_id]=1;chest_rolls[chest_id]=item.instance_id;state_changed.emit();return item
func equip_instance(id:String)->bool:
 var data=item_data(id);var slot=str(data.get("slot",data.get("type","")));if slot=="Armor":slot="Body";if slot=="Accessory":slot="Accessory1"
 if slot not in equipment:return false
 equipment[slot]=id;state_changed.emit();return true
func buy(id:String,price:int)->bool:
 if crowns<price:return false
 crowns-=price;inventory[id]=inventory.get(id,0)+1;state_changed.emit();return true
func equip(id:String)->bool:
 if inventory.get(id,0)<1:return false
 var slot=str(ITEMS.get(id,{}).get("type",""));if slot not in equipment:return false
 equipment[slot]=id;state_changed.emit();return true
func add_item(id:String,count:=1):inventory[id]=inventory.get(id,0)+count;track("collect",id,count);state_changed.emit()
func accept_quest(id:String):
 if id in QUESTS and id not in quests:quests[id]={"status":"Active","progress":0};if tracked_quest=="":tracked_quest=id;quest_updated.emit(id)
func track_quest(id:String):if id in quests and quests[id].status!="Completed":tracked_quest=id;state_changed.emit()
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
 if id=="first_road" and not quests.has("mine_silence"):
  quests["mine_silence"]={"status":"Active","progress":0};tracked_quest="mine_silence"
 elif tracked_quest==id:tracked_quest=""
 quest_updated.emit(id)
 return true
func gain_rewards(exp:int,money:int)->Array[String]:
 experience+=exp;crowns+=money;var notes:Array[String]=[]
 while experience>=level*60:
  experience-=level*60;level+=1;base_stats.max_hp+=12;base_stats.max_mp+=4;base_stats.attack+=3;base_stats.defense+=2;base_stats.magic+=2;base_stats.resistance+=2;base_stats.speed+=1;hp=stat("max_hp");mp=stat("max_mp");notes.append("Ari reached level %d!"%level)
 state_changed.emit();return notes
func auto_equip()->Array[String]:
 var changes:Array[String]=[]
 for id in inventory:
  if int(inventory[id])<1:continue
  var data=item_data(id);var slot=str(data.get("slot",data.get("type","")));if slot=="Armor":slot="Body";if slot=="Accessory":slot="Accessory1"
  if slot not in equipment:continue
  var current=item_data(equipment[slot]);var score=int(data.get("rating",0));var old_score=int(current.get("rating",0))
  for key in ["attack","defense","magic","resistance","speed","max_hp","max_mp"]:score+=int(data.get("stats",{}).get(key,data.get(key,0)))*3;old_score+=int(current.get("stats",{}).get(key,current.get(key,0)))*3
  if score>old_score:equipment[slot]=id;changes.append(str(data.get("name",id)))
 state_changed.emit();return changes
func serialize()->Dictionary:return {"version":6,"hero":HERO_NAME,"crowns":crowns,"inventory":inventory,"equipment":equipment,"location":current_location,"position":[player_position.x,player_position.y],"play_seconds":play_seconds,"flags":flags,"quests":quests,"opened_treasures":opened_treasures,"defeated_bosses":defeated_bosses,"world_events":world_events,"level":level,"experience":experience,"hp":hp,"mp":mp,"base_stats":base_stats,"party":party,"party_state":party_state,"bestiary":bestiary,"discovered_locations":discovered_locations,"fast_travel":fast_travel,"puzzle_states":puzzle_states,"guild_reputation":guild_reputation,"job_state":job_state,"unlocked_jobs":unlocked_jobs,"relationships":relationships,"relationship_events":relationship_events,"vehicles":vehicles,"ship":ship,"known_planets":known_planets,"story_branches":story_branches,"lattice_points":lattice_points,"lattice_active":lattice_active,"generated_items":generated_items,"chest_rolls":chest_rolls,"tracked_quest":tracked_quest,"minigame_best":minigame_best}
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
 party.clear()
 for member_id in d.get("party",["ari"]):party.append(str(member_id))
 party_state=d.get("party_state",{"ari":{"level":level,"hp":hp,"mp":mp,"max_hp":stat("max_hp"),"max_mp":stat("max_mp"),"attack":stat("attack"),"defense":stat("defense"),"magic":stat("magic"),"speed":stat("speed")}})
 bestiary=d.get("bestiary",{})
 discovered_locations.clear()
 for discovered_id in d.get("discovered_locations",["town"]):discovered_locations.append(str(discovered_id))
 fast_travel.clear()
 for travel_id in d.get("fast_travel",["town"]):fast_travel.append(str(travel_id))
 puzzle_states=d.get("puzzle_states",{})
 guild_reputation=int(d.get("guild_reputation",0))
 job_state=d.get("job_state",job_state);unlocked_jobs.clear();for saved_job_id in d.get("unlocked_jobs",["pathguard","flame_scholar","way_mender","reed_ranger","lantern_rogue","stone_monk","tide_engineer","star_priest"]):unlocked_jobs.append(str(saved_job_id));relationships=d.get("relationships",relationships);relationship_events.clear();for relationship_event_id in d.get("relationship_events",[]):relationship_events.append(str(relationship_event_id));vehicles=d.get("vehicles",vehicles);ship=d.get("ship",ship);known_planets.clear();for planet_id in d.get("known_planets",[]):known_planets.append(str(planet_id));story_branches=d.get("story_branches",{})
 lattice_points=d.get("lattice_points",{"ari":3});lattice_active=d.get("lattice_active",{"ari":["lattice_000"]});generated_items=d.get("generated_items",{});chest_rolls=d.get("chest_rolls",{});var migrated={"Weapon":equipment.get("Weapon",""),"Head":equipment.get("Head",""),"Body":equipment.get("Body",equipment.get("Armor","")),"Hands":equipment.get("Hands",""),"Feet":equipment.get("Feet",""),"Accessory1":equipment.get("Accessory1",equipment.get("Accessory","")),"Accessory2":equipment.get("Accessory2","")};equipment=migrated
 tracked_quest=str(d.get("tracked_quest",""));minigame_best=int(d.get("minigame_best",0))
 state_changed.emit()

