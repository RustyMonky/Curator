extends "res://levels/level.gd"

onready var samuraiNode = $samurai

var hasChosenTeam = false

func _ready():
	playerInstance.canvas.setText(["Pick your side and defeat all enemies!"])
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

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !hasChosenTeam:
			# Override player state to allow choosing options
			playerInstance.currentState = playerInstance.STATE.TEXT

			if playerInstance.canvas.optionsHBox.get_children().size() == 0:
				playerInstance.canvas.setHBoxOptions(["blue", "neutral", "red"])
			else:
				playerInstance.add_to_group(playerInstance.canvas.optionsHBox.get_children()[playerInstance.canvas.currentHBoxIndex].text)
				hasChosenTeam = true
				playerInstance.currentState = playerInstance.STATE.REST
				playerInstance.canvas.resetHBoxOptions()

		if playerInstance.currentState != playerInstance.STATE.TEXT && hasChosenTeam && !startEvent:
			startEvent = true

func _process(delta):
	if complete:
		return

	if samuraiNode.get_children().size() == 0:
		complete = true
		openPortal()
