class_name CombatMath
extends RefCounted
static func physical_damage(attack:int,defense:int,variance:=0)->int:
 # Defense mitigates 35%, preserving readable damage at every valid stat tier.
 return clampi(attack-int(defense*0.35)+variance,1,9999)
static func skill_damage(power_stat:int,power:float,defense:int,variance:=0)->int:
 return clampi(int(power_stat*power)-int(defense*0.30)+variance,1,9999)
static func element_multiplier(element:String,weakness:String,resistance:String)->float:
 if element!="" and element==weakness:return 1.5
 if element!="" and element==resistance:return 0.6
 return 1.0

