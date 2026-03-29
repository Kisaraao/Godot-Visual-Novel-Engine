extends Control

@export var level_box : PackedScene
@export var test : LevelData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera.position = Data.selecting_cam_pos
	
	# 在某个全局管理器或场景的 _ready 中
	var head = "res://Levels/"
	var feet = ".tres"
	var chapters = [
		load(head + "YuHuaBin" + feet),
		load(head + "SmartHomeIsOver" + feet),
		load(head + "Smurf" + feet),
		load(head + "Emperor" + feet),
		load(head + "JadeBird" + feet),
		load(head + "LaQiLaBiao" + feet),
		load(head + "MobileAppDevelop" + feet),
		load(head + "YuHuaBiaonia" + feet),
		load(head + "Yz" + feet),
		load(head + "Jb" + feet),
		load(head + "CKDragon" + feet)
	]
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if file_name.ends_with(".tres"):
				#print("res://Dialogues/" + file_name)
				#var chapter = load("res://Dialogues/" + file_name)
				#if chapter is Level:
					#chapters.append(chapter)
			#file_name = dir.get_next()
		#dir.list_dir_end()
	 #现在 chapters 数组里就是所有剧本资源
	var points = []
	var line = Line2D.new()
	line.width = 12                     # 线条宽度
	line.default_color = Color.GOLD   # 线条颜色
	line.joint_mode = Line2D.LINE_JOINT_ROUND   # 拐角圆滑
	
	for lev in chapters:
		points.append(lev.position)
		
	line.points = points
	$LinesLayer.add_child(line)

	for lev : LevelData in chapters:
		var box := level_box.instantiate()
		box.level = lev
		box.cam = $Camera
		$LevelsLayer.add_child(box)
