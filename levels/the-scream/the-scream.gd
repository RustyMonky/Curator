extends "res://levels/level.gd"

onready var delayTimer = $screamDelay
onready var nav = $screamNav

var screamSwitch = null

func _ready():
	textureScale = 0.75

	playerInstance.canvas.setText(["Dodge the scream waves and find the switch!"])

	# Parent override for starting position to respect scaling
	playerInstance.position = Vector2((paintingSize.x * textureScale) / 2, (paintingSize.y * textureScale) / 2)

	# Select spawnpoint for switch
	randomize()
	var spawnX = randi() % int(paintingSize.x * textureScale)
	var spawnY = randi() % int(paintingSize.y * textureScale)

	screamSwitch = load("res://entities/switch/switch.tscn").instance()
	screamSwitch.position = Vector2(spawnX, spawnY)
	nav.add_child(screamSwitch)

	if gameData.hasDemon:
		var demonInstance = load("res://entities/npc/demon/demon.tscn").instance()
		nav.add_child(demonInstance)
		demonInstance.position = Vector2((paintingSize.x * textureScale) - 64, (paintingSize.y * textureScale) / 2)
		demonInstance.animations.flip_h = true
		demonInstance.setNav(nav)

	set_process_input(true)

func spawnBlast():
	var blastInstance = load("res://levels/the-scream/screamBlast.tscn").instance()
	blastInstance.destination = playerInstance.position
	blastInstance.position = Vector2(320 * textureScale, 465 * textureScale)
	blastInstance.add_to_group("blast")
	nav.add_child(blastInstance)

func _input(event):
	if event.is_action_pressed("ui_accept") && playerInstance.currentState != playerInstance.STATE.TEXT && !startEvent:
		startEvent = true
		delayTimer.start()

func _process(delta):
	if screamSwitch.currentState == "Off" && !complete:
		screamSwitch.collider.disabled = true
		complete = true

		for blast in get_tree().get_nodes_in_group("blast"):
			blast.dissipate()

		openPortal()

# Signals

func _on_screamDelay_timeout():
	if complete:
		delayTimer.stop()
		return

	spawnBlast()
