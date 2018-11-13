extends Spatial

var portalPosition = Vector3()

onready var painting = $painting
onready var playerInstance = load("res://entities/player/player.tscn").instance()

func _ready():
	self.add_child(playerInstance)
	playerInstance.translation = Vector3(0, 0, 10)

	if gameData.hasDemon:
		var demonInstance = load("res://entities/npc/demon/demon.tscn").instance()
		self.add_child(demonInstance)
		demonInstance.translation = Vector3(-1, 1.5, painting.get_texture().get_size().y / 2)
		demonInstance.direction = Vector3(0, 0, 1)

# openPortal
# Spawns a portal to transition player to next level
func openPortal():
	var portalInstance = load("res://entities/portal/portal.tscn").instance()
	self.add_child(portalInstance)
	portalInstance.translation = Vector3(0, 0.5, 0)
	portalPosition = portalInstance.translation
	print("Portal spawned at", portalInstance.translation)