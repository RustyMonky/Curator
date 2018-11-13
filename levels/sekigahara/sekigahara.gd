extends "res://levels/level.gd"

onready var samuraiNode = $samurai

func _ready():
	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.position = Vector2(64, 64 * i)
		samuraiInstance.setTeam("blue")

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.position = Vector2(painting.get_texture().get_size().x - 64, 64 * i)
		samuraiInstance.animations.flip_h = true
		samuraiInstance.setTeam("red")

func _process(delta):
	if complete:
		return

	if samuraiNode.get_children().size() == 0:
		complete = true
		openPortal()
