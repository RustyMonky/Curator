extends "res://levels/level.gd"

onready var demonInstance = load("res://entities/npc/demon/demon.tscn").instance()

func _ready():
	self.add_child(demonInstance)
	demonInstance.position = Vector2(painting.get_texture().get_size().x / 2, painting.get_texture().get_size().y / 2)
	gameData.hasDemon = true
	openPortal()
