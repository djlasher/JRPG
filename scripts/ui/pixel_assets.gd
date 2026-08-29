class_name PixelAssets
extends RefCounted

const ATLAS=preload("res://assets/generated/master_pixel_atlas.png")
const HERO={"down":Rect2(0,0,44,56),"left":Rect2(44,0,44,56),"right":Rect2(88,0,44,56),"up":Rect2(132,0,44,56)}
const VEHICLES={"ground":Rect2(1040,790,105,72),"boat":Rect2(806,805,110,85),"aircraft":Rect2(1110,760,180,95),"spacecraft":Rect2(1125,840,210,105)}
const BUILDINGS=[Rect2(1180,0,135,105),Rect2(1310,0,125,115),Rect2(1415,0,120,115),Rect2(1180,105,145,130),Rect2(1320,105,120,130),Rect2(1425,105,110,130)]
const TILES={"grass":Rect2(820,0,40,40),"meadow":Rect2(860,0,40,40),"dirt":Rect2(900,0,40,40),"stone":Rect2(980,0,40,40),"water":Rect2(820,78,40,40),"deep_water":Rect2(860,78,40,40),"snow":Rect2(1040,0,40,40),"void":Rect2(1120,40,40,40)}
const INTERIORS={"wood":Rect2(820,255,120,96),"stone":Rect2(940,255,120,96),"arcane":Rect2(1180,255,120,96),"shop":Rect2(1300,255,120,96)}

static func hero_region(facing:Vector2)->Rect2:
 if abs(facing.x)>abs(facing.y):return HERO.right if facing.x>0 else HERO.left
 return HERO.down if facing.y>=0 else HERO.up
static func npc_region(name:String,facing:Vector2)->Rect2:
 var column=abs(hash(name))%9;var row=(abs(hash(name))/9)%5;var direction=0
 if abs(facing.x)>abs(facing.y):direction=1 if facing.x<0 else 2
 elif facing.y<0:direction=3
 return Rect2(420+column*42,8+(row*4+direction)*48,40,46)
static func building_region(id:String)->Rect2:return BUILDINGS[abs(hash(id))%BUILDINGS.size()]
static func vehicle_region(id:String)->Rect2:return VEHICLES.get(id,VEHICLES.spacecraft)
