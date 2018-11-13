extends "res://levels/level.gd"

onready var samuraiNode = $samurai

func _ready():
	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.translation = Vector3(10, 0, 1.5 * i)
		samuraiInstance.animations.flip_h = true
		samuraiInstance.setTeam("blue")

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.translation = Vector3(-10, 0, 1.5 * i)
		samuraiInstance.setTeam("red")
