extends "res://levels/level.gd"

func _ready():
	playerInstance.canvas.setText([
		"You're trapped within a dungeon of paintings.",
		"In order to progress past a painting, you must complete its challenge.",
		"Upon completing its challenge, a portal will appear.",
		"An arrow will guide you toward the portal.",
		"Enter it to press on.",
		"Keep track of your health at the top left of your screen.",
		"Use WASD or the ARROW KEYS to move.",
		"Press ENTER or SPACE to swing your sword.",
		"Good luck!"
	])

	playerInstance.position = Vector2(paintingSize.x * textureScale / 2 - 64, paintingSize.y * textureScale / 2)

	startEvent = true

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") && playerInstance.currentState != playerInstance.STATE.TEXT:
		complete = true
		openPortal()