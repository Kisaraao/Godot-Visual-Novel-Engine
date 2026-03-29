extends Area2D

@export var level : LevelData
@export var cam : Camera2D

var is_enterd : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	$Hover.modulate.a = 0
	position = level.position
	name = level.name
	$Label.text = level.name
	$bg.texture = level.badge

func _process(delta: float) -> void:
	if is_enterd and Time.get_ticks_msec() % 5 == 0:
		rotation = deg_to_rad(randi_range(-3, 3))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		Data.current_level = level
		Data.selecting_cam_pos = cam.position
		get_tree().change_scene_to_file("res://Scenes/VisualNovel.tscn")


func _on_mouse_entered() -> void:
	is_enterd = true
	$Click.play()
	$Cover.modulate = Color(1.3, 1.3, 1.3)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Hover, "modulate:a", 1, 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN_OUT)

func _on_mouse_exited() -> void:
	is_enterd = false
	rotation = 0
	$Cover.modulate = Color.WHITE
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Hover, "modulate:a", 0, 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color(0.8, 0.8, 0.8), 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.1).set_ease(Tween.EASE_IN_OUT)
