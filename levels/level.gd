extends Node2D

onready var painting = $painting
onready var playerInstance = load("res://entities/player/player.tscn").instance()

func _ready():
	self.add_child(playerInstance)
	playerInstance.position = Vector2(0, painting.get_texture().get_size().y / 2)

# openPortal
# Spawns a portal to transition player to next level
func openPortal():
	var portalInstance = load("res://entities/portal/portal.tscn").instance()
	self.add_child(portalInstance)
	portalInstance.position = Vector2(painting.get_texture().get_size().x / 2, painting.get_texture().get_size().y / 2)