extends Resource
class_name CharacterData

@export_category("信息")
@export var title : String = "未设定身份"
@export var name : String = "未设定名称"
@export var font_color : Color = Color("f8dbb5")
@export var badge_color : Color = Color.WHITE

@export_category("贴图")
@export var textures : Array[EmoteUnit]
