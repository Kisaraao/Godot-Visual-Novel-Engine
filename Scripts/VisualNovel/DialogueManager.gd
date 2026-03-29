extends Control

@export_group("UI")
@export var background : TextureRect
@export var title : Label
@export var title_ui : TextureRect
@export var speaker : Label
@export var speaker_ui : TextureRect
@export var content : Label
@export var place : Label
@export var camera : Camera2D
@export var character_layer : CanvasLayer
@export var filter : TextureRect

@export_group("音频")
@export var voice : AudioStreamPlayer2D
@export var bgm : AudioStreamPlayer2D
@export var sound : AudioStreamPlayer2D

var typing_tween : Tween
var dialogue_index : int = 0

var timer_switch_limit : Timer

var last_dialogue : DialogueData
var next_dialogue : DialogueData

var animate_script = load("res://Scripts/VisualNovel/CharacterAnimation.gd")
var character_array : Array[Sprite2D]

func display_next_dialogue() -> void:
	# out of dialogue_list range
	if dialogue_index + 1 > Data.current_level.dialogue_list.size():
		_back_to_selecting_scene()
		return
	# record new and old dialogue
	if dialogue_index != 0:
		last_dialogue = next_dialogue
	next_dialogue = Data.current_level.dialogue_list[dialogue_index]
	# skip typing
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
		content.text = next_dialogue.content
		dialogue_index += 1
	# timer switch limit
	elif timer_switch_limit.time_left == 0:
		timer_switch_limit.start()
		# narration
		if next_dialogue.is_narration:
			content.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			title.hide()
			title_ui.hide()
			speaker.hide()
			speaker_ui.hide()
		else:
			content.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			content.vertical_alignment = VERTICAL_ALIGNMENT_TOP
			title.show()
			title_ui.show()
			speaker.show()
			speaker_ui.show()
			
		# audio
		voice.stop()
		sound.stop()
		if next_dialogue.bgm:
			bgm.stream = next_dialogue.bgm
			bgm.play()
		voice.stream = next_dialogue.voice
		sound.stream = next_dialogue.sound
		voice.play()
		sound.play()
		
		# background
		background.texture = next_dialogue.background.texture
			
		# place_name
		place.text = next_dialogue.background.name
		
		# filter blink
		filter.hide()
		if next_dialogue.is_blink:
			filter.modulate.a = 0
			filter.modulate = next_dialogue.blink_color
			filter.show()
			var blink = create_tween()
			blink.tween_property(filter, "modulate:a", 1, next_dialogue.blink_duration)
			blink.tween_property(filter, "modulate:a", 0, next_dialogue.blink_duration).set_delay(next_dialogue.blink_delay)
		
		# clear character
		if character_array.is_empty() != true:
			for c : Sprite2D in character_array:
				c.die()
			character_array.clear()
		
		# create character
		for c: CharacterSlot in next_dialogue.characters:
			var character = Sprite2D.new()
			character.set_script(animate_script)
			character.name = c.character.name
			var emo = _get_emote_texture(c.emote, c.character.textures)
			character.texture = emo.texture
			#character.position = c.position + emo.offset
			
			character.position.x = 960 + float(c.x_position) / 10 * 960
			character.position.y = c.y_position + emo.offset.y
			
			character.z_index = c.z_index
			character.scale = emo.scale
			
			character.is_fade_in = c.is_fade_in
			character.is_fade_out = c.is_fade_out
			character.is_gray = c.is_gray
			character.is_black = c.is_black
			character.flip_h = c.horizon_flip
			
			# 动画
			character.is_position_animation = c.is_position_animation
			character.is_rotation_animation = c.is_rotation_animation
			character.is_scale_animation = c.is_scale_animation
			if character.is_position_animation:
				character.begin_position = Vector2(960 + float(c.begin_position_x) / 10 * 960, c.begin_position_y  + emo.offset.y)
				character.end_position = Vector2(960 + float(c.end_position_x) / 10 * 960, c.end_position_y + emo.offset.y)
				character.position_animation_duration = c.position_animation_duration
			if character.is_rotation_animation:
				character.begin_rotation = c.begin_rotation
				character.end_rotation = c.end_rotation
				character.rotation_animation_duration = c.rotation_animation_duration
			if character.is_scale_animation:
				character.begin_scale = c.begin_scale
				character.end_scale = c.end_scale
				character.scale_animation_duration = c.scale_animation_duration
			
			character_array.append(character)
		
		# add character
		for c in character_array:
			character_layer.add_child(c)
		
		# camera
		camera.position_smoothing_enabled = next_dialogue.position_smoothing
		camera.rotation_smoothing_enabled = next_dialogue.rotation_smoothing
		if next_dialogue.position + Vector2(960, 540) != camera.position:
			camera.position = next_dialogue.position + Vector2(960, 540)
		if next_dialogue.zoom != camera.zoom:
			if next_dialogue.zoom_smoothing:
				var tween = create_tween()
				tween.tween_property(camera, "zoom", next_dialogue.zoom, next_dialogue.zoom_speed).set_ease(Tween.EASE_OUT)
			else:
				camera.zoom = next_dialogue.zoom
		if deg_to_rad(next_dialogue.rotation) != camera.rotation:
			camera.rotation = deg_to_rad(next_dialogue.rotation)
		if next_dialogue.is_shake:
			shake(next_dialogue.shake_duration, next_dialogue.shake_strength)
		
		# speaker
		if next_dialogue.is_censor:
			speaker.add_theme_color_override("font_color", Color("f8dbb5"))
		else:
			speaker.add_theme_color_override("font_color", next_dialogue.speaker.font_color)
		speaker_ui.modulate = Color.DARK_GOLDENROD if next_dialogue.is_censor else next_dialogue.speaker.badge_color
		title.text = "? ? ?" if next_dialogue.is_censor else next_dialogue.speaker.title
		speaker.text = "? ? ?" if next_dialogue.is_censor else next_dialogue.speaker.name
			
		# content
		typing_tween = get_tree().create_tween()
		content.text = ""
		for character in next_dialogue.content:
			typing_tween.tween_callback(append_character.bind(character)).set_delay(0.05)
		typing_tween.tween_callback(func(): dialogue_index += 1)


func _get_emote_texture(target : String, emote : Array[EmoteUnit]) -> EmoteUnit:
	for yes in emote:
		if yes.name == target:
			return yes
	return

func append_character(character : String) -> void:
	content.text += character

func _ready() -> void:
	timer_switch_limit = Timer.new()
	timer_switch_limit.set_wait_time(0.4)
	timer_switch_limit.set_one_shot(true)
	get_tree().current_scene.add_child(timer_switch_limit)
	camera.position = Vector2(960, 540)
	display_next_dialogue()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		display_next_dialogue()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		display_next_dialogue()

func shake(duration: float = 0.2, intensity: float = 10.0):
	var original_offset = camera.offset
	var timer = Timer.new()
	timer.wait_time = 0.02  # 每帧更新太快，设小点
	timer.autostart = true
	timer.timeout.connect(func():
		var random = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		camera.offset = original_offset + random
	)
	add_child(timer)
	await get_tree().create_timer(duration).timeout
	timer.queue_free()
	camera.offset = original_offset

func _back_to_selecting_scene() -> void:
	Data.current_level = null
	get_tree().change_scene_to_file("res://Scenes/LevelSelecting.tscn")
