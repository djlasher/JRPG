class_name VisualAssets
extends RefCounted

const ATLAS=preload("res://assets/generated/dark_fantasy_atlas.png")

const MONSTERS={
 "mossling":Rect2(450,20,145,175),"briarback":Rect2(600,195,145,175),"gloomwing":Rect2(745,15,150,180),
 "river_wisp":Rect2(595,15,145,180),"stonejaw":Rect2(450,195,145,175),"roadshade":Rect2(150,15,145,180),
 "lantern_moth":Rect2(1190,15,150,180),"hollow_knight":Rect2(295,195,145,175),"glass_fox":Rect2(0,15,150,180),
 "stonewarden":Rect2(895,15,145,180),"mire_hart":Rect2(1045,15,145,180)
}
const SPELLS={
 "ember_lance":Rect2(50,388,95,92),"cinder_wind":Rect2(530,388,95,92),"arc_spark":Rect2(155,388,95,92),
 "chain_glyph":Rect2(625,388,95,92),"rime_lock":Rect2(260,388,95,92),"glacial_ward":Rect2(50,485,95,92),
 "stone_needle":Rect2(770,385,80,85),"bastion_rune":Rect2(465,485,95,92),"waylight_mend":Rect2(255,485,95,92),
 "renewal_mesh":Rect2(360,485,95,92),"sun_packet":Rect2(1425,385,80,85),"cathedral_field":Rect2(465,485,95,92),
 "shade_drain":Rect2(465,585,95,92),"silence_key":Rect2(1260,485,80,82),"aether_scan":Rect2(635,585,95,92),
 "machine_grace":Rect2(255,585,95,92)
}
const WEAPONS={"Sword":Rect2(50,680,100,115),"Great Sword":Rect2(155,680,100,115),"Daggers":Rect2(265,680,100,115),"Spear":Rect2(370,680,100,115),"Axe":Rect2(585,680,100,115),"Hammer":Rect2(690,680,100,115),"Bow":Rect2(800,680,100,115),"Staff":Rect2(900,680,100,115),"Runegun":Rect2(1110,680,100,115),"Accessory":Rect2(1010,680,100,115)}
const ARMOR={"Head":Rect2(50,795,105,115),"Body":Rect2(160,795,105,115),"Hands":Rect2(270,795,105,115),"Feet":Rect2(430,795,105,115),"Accessory1":Rect2(650,795,105,115),"Accessory2":Rect2(650,795,105,115)}
const CHESTS=[Rect2(250,920,145,95),Rect2(405,920,145,95),Rect2(560,920,145,95),Rect2(715,920,145,95),Rect2(875,920,145,95)]

static func icon_for_enemy(id:String)->AtlasTexture:return _icon(MONSTERS.get(id,MONSTERS.mossling))
static func icon_for_spell(id:String)->AtlasTexture:return _icon(SPELLS.get(id,SPELLS.aether_scan))
static func icon_for_item(data:Dictionary)->AtlasTexture:
 var slot=str(data.get("slot",data.get("type","")))
 var weapon_type=str(data.get("weapon_type","Sword"))
 return _icon(WEAPONS.get(weapon_type,WEAPONS.Sword) if slot=="Weapon" else ARMOR.get(slot,ARMOR.Body))
static func chest_region(tier:int)->Rect2:return CHESTS[clampi(tier,0,CHESTS.size()-1)]
static func _icon(region:Rect2)->AtlasTexture:
 var icon=AtlasTexture.new();icon.atlas=ATLAS;icon.region=region;return icon
