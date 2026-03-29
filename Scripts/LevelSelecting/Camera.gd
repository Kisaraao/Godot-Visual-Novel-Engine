extends Camera2D

var dragging = false
var drag_start_pos = Vector2()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_start_pos = event.position
		else:
			# 可选：拖动结束后做点啥
			pass
	elif event is InputEventMouseMotion and dragging:
		# 鼠标移动，摄像机位置反向移动（因为拖动是移动视图）
		var offset = event.position - drag_start_pos
		position -= offset
		drag_start_pos = event.position
