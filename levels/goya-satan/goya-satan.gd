extends "res://levels/level.gd"

onready var demonInstance = load("res://entities/npc/demon/demon.tscn").instance()
onready var nav = $goyaNav

func _ready():
	playerInstance.canvas.setText(["Run!"])

func _process(delta):
	if playerInstance.currentState != playerInstance.STATE.TEXT && !startEvent:
		startEvent = true
		complete = true
		nav.add_child(demonInstance)
		demonInstance.position = Vector2(paintingSize.x / 2, paintingSize.y / 2)
		demonInstance.setNav(nav)
		gameData.hasDemon = true
		openPortal()
