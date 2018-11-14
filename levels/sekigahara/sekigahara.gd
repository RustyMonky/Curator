extends "res://levels/level.gd"

onready var samuraiNode = $samurai

func _ready():
	playerInstance.canvas.setText("Pick your side and defeat all enemies!")
	# Parent override for starting position to respect scaling
	playerInstance.position = Vector2(16, (painting.get_texture().get_size().y * 0.75) - 16)

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.position = Vector2(16, 32 * (i+ 1))
		samuraiInstance.setTeam("blue")

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		samuraiNode.add_child(samuraiInstance)
		samuraiInstance.position = Vector2((painting.get_texture().get_size().x * 0.75) - 16, 32 * (i + 1))
		samuraiInstance.animations.flip_h = true
		samuraiInstance.setTeam("red")

	# Now, override collision per samurai so that they don't collide with their team
	for blueSamurai in get_tree().get_nodes_in_group("blue"):
		for ally in get_tree().get_nodes_in_group("blue"):
			blueSamurai.add_collision_exception_with(ally)

	for redSamurai in get_tree().get_nodes_in_group("red"):
		for ally in get_tree().get_nodes_in_group("red"):
			redSamurai.add_collision_exception_with(ally)

func _process(delta):
	if complete:
		return

	if playerInstance.currentState != playerInstance.STATE.TEXT && !startEvent:
		startEvent = true

	if samuraiNode.get_children().size() == 0:
		complete = true
		openPortal()
