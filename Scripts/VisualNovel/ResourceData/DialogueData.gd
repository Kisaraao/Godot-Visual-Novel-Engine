extends Resource
class_name DialogueData

@export var speaker : CharacterData
@export var is_censor : bool = false
@export_multiline var content : String
@export var is_narration : bool = false

@export_group("图形资产")
@export var background : PlaceData
@export var characters : Array[CharacterSlot]
@export_subgroup("闪烁")
@export var is_blink : bool = false
@export var blink_color : Color = Color.WHITE
@export var blink_delay : float = 0.0
@export var blink_duration : float = 0.0

@export_group("音频")
@export var sound : AudioStream
@export var voice : AudioStream
@export var bgm : AudioStream

@export_group("摄像机")
@export var position_smoothing : bool = true
@export var position : Vector2 = Vector2(0, 0)
@export var zoom_smoothing : bool = true
@export var zoom : Vector2 = Vector2(1, 1)
@export var zoom_speed : float = 0.5
@export var rotation_smoothing : bool = true
@export var rotation : float = 0
@export_subgroup("抖动")
@export var is_shake : bool = false
@export var shake_strength : float
@export var shake_duration : float
