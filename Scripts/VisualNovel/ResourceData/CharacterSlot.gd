extends Resource
class_name CharacterSlot

@export var character : CharacterData
@export var emote : String = "Idle"
@export var horizon_flip : bool = false
@export_range(-15, 15) var x_position : int = 0
@export var y_position : float = 0
@export var is_gray : bool = false
@export var is_black : bool = false
@export var is_fade_in : bool = true
@export var is_fade_out : bool = true
@export var z_index : int = 0

@export_group("动画")
@export_subgroup("坐标")
@export var is_position_animation : bool = false
@export var begin_position_x : int
@export var end_position_x : int
@export var begin_position_y : float = 0
@export var end_position_y : float = 0
@export var position_animation_duration : float = 0.0
@export_subgroup("角度")
@export var is_rotation_animation : bool = false
@export var begin_rotation : float
@export var end_rotation : float
@export var rotation_animation_duration : float = 0.0
@export_subgroup("大小")
@export var is_scale_animation : bool = false
@export var begin_scale : Vector2
@export var end_scale : Vector2
@export var scale_animation_duration : float = 0.0
