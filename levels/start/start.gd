extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		fader.fadeToScene(levelLoader.getPath())
