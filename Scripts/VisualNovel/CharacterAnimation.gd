extends Sprite2D

@export var is_gray : bool
@export var is_black : bool
@export var is_fade_in : bool
@export var is_fade_out : bool

@export var is_position_animation : bool
@export var begin_position : Vector2
@export var end_position : Vector2
@export var position_animation_duration : float

@export var is_rotation_animation : bool
@export var begin_rotation : float
@export var end_rotation : float
@export var rotation_animation_duration : float

@export var is_scale_animation : bool
@export var begin_scale : Vector2
@export var end_scale : Vector2
@export var scale_animation_duration : float

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	if is_gray:
		modulate = 	Color(0.5, 0.5, 0.5)
	elif is_black:
		modulate = Color.BLACK
	if is_fade_in:
		modulate.a = 0.0
		tween.tween_property(self, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_IN)
	if is_position_animation:
		position = begin_position
		tween.tween_property(self, "position", end_position, position_animation_duration)
	if is_rotation_animation:
		rotation = deg_to_rad(begin_rotation)
		tween.tween_property(self, "rotation", deg_to_rad(end_rotation), rotation_animation_duration)
	if is_scale_animation:
		scale = begin_scale
		tween.tween_property(self, "scale", end_scale, scale_animation_duration)

func die() -> void:
	if is_fade_out:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_OUT).set_delay(0.15)
		await tween.finished
	queue_free()
