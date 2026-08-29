class_name EnemyDatabase
extends RefCounted
const ENEMIES={
"mossling":{"name":"Mossling","color":"6fa34f","hp":34,"attack":8,"defense":3,"speed":7,"exp":18,"crowns":10,"ai":"basic"},
"briarback":{"name":"Briarback","color":"8a713c","hp":52,"attack":11,"defense":5,"speed":8,"exp":25,"crowns":14,"ai":"aggressive"},
"gloomwing":{"name":"Gloomwing","color":"66548f","hp":38,"attack":9,"defense":3,"speed":14,"exp":22,"crowns":12,"ai":"swift"},
"river_wisp":{"name":"River Wisp","color":"53a6bd","hp":44,"attack":10,"defense":4,"speed":11,"exp":28,"crowns":16,"ai":"magic"},
"stonejaw":{"name":"Stonejaw Burrower","color":"77746a","hp":70,"attack":13,"defense":9,"speed":5,"exp":35,"crowns":20,"ai":"defensive"},
"roadshade":{"name":"Roadshade","color":"9b4e55","hp":62,"attack":15,"defense":6,"speed":12,"exp":38,"crowns":28,"ai":"aggressive"},
"lantern_moth":{"name":"Lantern Moth","color":"e0b64e","hp":42,"attack":12,"defense":4,"speed":15,"exp":32,"crowns":18,"ai":"magic"},
"hollow_knight":{"name":"Hollow Knight","color":"596677","hp":92,"attack":17,"defense":12,"speed":7,"exp":55,"crowns":35,"ai":"defensive"},
"glass_fox":{"name":"Glass Fox","color":"8ad2cf","hp":78,"attack":18,"defense":7,"speed":18,"exp":70,"crowns":55,"ai":"swift"},
"stonewarden":{"name":"Stonewarden Orrox","color":"a06e42","hp":280,"attack":20,"defense":11,"speed":8,"exp":180,"crowns":150,"ai":"boss","boss":true},
"mire_hart":{"name":"Mire-Crowned Hart","color":"477f67","hp":360,"attack":23,"defense":13,"speed":12,"exp":240,"crowns":220,"ai":"boss","boss":true}}
static func formation(id:String)->Array[String]:
 if id=="briarback":return ["briarback","mossling"]
 if id=="gloomwing":return ["gloomwing","gloomwing","lantern_moth"]
 if id=="roadshade":return ["roadshade","roadshade"]
 return [id]

