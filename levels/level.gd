extends Node2D

var portalPosition = Vector2()

onready var painting = $painting
onready var playerInstance = load("res://entities/player/player.tscn").instance()

var complete = false
var paintingSize = Vector2()
var startEvent = false
var textureScale = 1

func _ready():
	paintingSize = painting.get_texture().get_size()

	self.add_child(playerInstance)
	playerInstance.position = Vector2(16, (paintingSize.y * textureScale) - 16)

	set_process(true)

# openPortal
# Spawns a portal to transition player to next level
func openPortal():
	var portalInstance = load("res://entities/portal/portal.tscn").instance()
	self.add_child(portalInstance)
	portalInstance.position = Vector2((paintingSize.x * textureScale) / 2, (paintingSize.y * textureScale) / 2)
	portalPosition = portalInstance.position