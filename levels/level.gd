extends Node2D

var portalPosition = Vector2()

onready var painting = $painting
onready var playerInstance = load("res://entities/player/player.tscn").instance()

var complete = false
var startEvent = false

func _ready():
	self.add_child(playerInstance)
	playerInstance.position = Vector2(64, painting.get_texture().get_size().y / 2)

	if gameData.hasDemon:
		var demonInstance = load("res://entities/npc/demon/demon.tscn").instance()
		self.add_child(demonInstance)
		demonInstance.position = Vector2(-64, painting.get_texture().get_size().y / 2)
		demonInstance.direction = Vector2(1, 0)

	set_process(true)

# openPortal
# Spawns a portal to transition player to next level
func openPortal():
	var portalInstance = load("res://entities/portal/portal.tscn").instance()
	self.add_child(portalInstance)
	portalInstance.position = Vector2(painting.get_texture().get_size().x / 2, painting.get_texture().get_size().y / 2)
	portalPosition = portalInstance.position