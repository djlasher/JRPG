class_name EnemyDatabase
extends RefCounted
const ENEMIES={
"mossling":{"name":"Green Slime","color":"6fa34f","hp":18,"attack":4,"defense":1,"speed":5,"exp":12,"crowns":7,"ai":"basic"},
"briarback":{"name":"Thorn Slime","color":"8a713c","hp":26,"attack":5,"defense":2,"speed":6,"exp":15,"crowns":9,"ai":"basic"},
"gloomwing":{"name":"Cave Bat","color":"66548f","hp":22,"attack":5,"defense":1,"speed":11,"exp":14,"crowns":8,"ai":"swift"},
"river_wisp":{"name":"River Bubble","color":"53a6bd","hp":25,"attack":5,"defense":2,"speed":8,"exp":16,"crowns":10,"ai":"magic"},
"stonejaw":{"name":"Pebble Crab","color":"77746a","hp":34,"attack":6,"defense":4,"speed":5,"exp":20,"crowns":12,"ai":"defensive"},
"roadshade":{"name":"Road Bandit","color":"9b4e55","hp":38,"attack":7,"defense":3,"speed":9,"exp":24,"crowns":18,"ai":"aggressive"},
"lantern_moth":{"name":"Glow Moth","color":"e0b64e","hp":24,"attack":6,"defense":2,"speed":12,"exp":18,"crowns":11,"ai":"magic"},
"hollow_knight":{"name":"Ruin Guard","color":"596677","hp":55,"attack":8,"defense":6,"speed":7,"exp":34,"crowns":24,"ai":"defensive"},
"glass_fox":{"name":"Glass Fox","color":"8ad2cf","hp":46,"attack":9,"defense":4,"speed":15,"exp":45,"crowns":32,"ai":"swift"},
"stonewarden":{"name":"Stonewarden Orrox","color":"a06e42","hp":190,"attack":13,"defense":9,"speed":8,"exp":180,"crowns":150,"ai":"boss","boss":true},
"mire_hart":{"name":"Mire-Crowned Hart","color":"477f67","hp":240,"attack":15,"defense":10,"speed":12,"exp":240,"crowns":220,"ai":"boss","boss":true}}
static func formation(id:String)->Array[String]:
 if id=="briarback":return ["briarback"]
 if id=="gloomwing":return ["gloomwing","gloomwing"]
 if id=="roadshade":return ["roadshade","roadshade"]
 return [id]

