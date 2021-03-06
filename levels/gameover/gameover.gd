extends Control

var preventInputs = true

func _ready():
	set_process_input(true)

func _input(event):
	if preventInputs:
		return

	if event.is_action_pressed("ui_accept"):
		gameData.restart()
		levelLoader.restart()

	if event.is_action_released("ui_accept"):
		fader.fadeToScene("res://levels/start/start.tscn")
		preventInputs = true

# Signals

func _on_inputDelay_timeout():
	preventInputs = false
