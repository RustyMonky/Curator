extends Control

var preventInputs = false

func _ready():
	set_process_input(true)

func _input(event):
	if preventInputs:
		return

	if event.is_action_pressed("ui_accept"):
		gameData.restart()

	if event.is_action_released("ui_accept"):
		fader.fadeToScene("res://levels/start/start.tscn")
		preventInputs = true
