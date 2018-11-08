extends Node2D

onready var painting = $painting
onready var playerInstance = load("res://entities/player/player.tscn").instance()

func _ready():
	self.add_child(playerInstance)
	playerInstance.position = Vector2(0, painting.get_texture().get_size().y / 2)