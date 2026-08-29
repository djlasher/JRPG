class_name PixelAssets
extends RefCounted

const ATLAS=preload("res://assets/generated/master_pixel_atlas.png")
const HERO_SAFE=Rect2(3,3,38,49)
const VEHICLES={"ground":Rect2(1040,790,105,72),"boat":Rect2(806,805,110,85),"aircraft":Rect2(1110,760,180,95),"spacecraft":Rect2(1125,840,210,105)}
const BUILDINGS=[Rect2(1180,0,135,105),Rect2(1310,0,125,115),Rect2(1415,0,120,115),Rect2(1180,105,145,130),Rect2(1320,105,120,130),Rect2(1425,105,110,130)]
const TILES={"grass":Rect2(820,0,40,40),"meadow":Rect2(860,0,40,40),"dirt":Rect2(900,0,40,40),"stone":Rect2(980,0,40,40),"water":Rect2(820,78,40,40),"deep_water":Rect2(860,78,40,40),"snow":Rect2(1040,0,40,40),"void":Rect2(1120,40,40,40)}
const INTERIORS={"wood":Rect2(820,255,120,96),"stone":Rect2(940,255,120,96),"arcane":Rect2(1180,255,120,96),"shop":Rect2(1300,255,120,96)}
const ENEMIES={
 "mossling":Rect2(0,650,78,72),"briarback":Rect2(82,650,78,72),"gloomwing":Rect2(405,650,82,76),
 "river_wisp":Rect2(645,650,82,76),"stonejaw":Rect2(164,650,78,72),"roadshade":Rect2(488,650,78,76),
 "lantern_moth":Rect2(568,650,76,76),"hollow_knight":Rect2(325,650,80,76),"glass_fox":Rect2(246,650,78,72),
 "stonewarden":Rect2(265,855,150,165),"mire_hart":Rect2(0,855,180,165)
}

static func hero_region(_facing:Vector2)->Rect2:return HERO_SAFE
static func npc_region(name:String,facing:Vector2)->Rect2:
 var column=abs(hash(name))%9;var row=(abs(hash(name))/9)%5;var direction=0
 if abs(facing.x)>abs(facing.y):direction=1 if facing.x<0 else 2
 elif facing.y<0:direction=3
 return Rect2(420+column*42,8+(row*4+direction)*48,40,46)
static func building_region(id:String)->Rect2:return BUILDINGS[abs(hash(id))%BUILDINGS.size()]
static func vehicle_region(id:String)->Rect2:return VEHICLES.get(id,VEHICLES.spacecraft)
static func enemy_region(id:String)->Rect2:return ENEMIES.get(id,ENEMIES.mossling)
static func enemy_icon(id:String)->AtlasTexture:
 var icon=AtlasTexture.new();icon.atlas=ATLAS;icon.region=enemy_region(id);return icon

