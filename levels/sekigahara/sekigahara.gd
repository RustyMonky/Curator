extends "res://levels/level.gd"

onready var nav = $samuraiNav
onready var tilemap = $samuraiNav/tilemap

var hasChosenTeam = false

func _ready():
	textureScale = 0.75
	var xRange = painting.get_texture().get_size().x * textureScale

	playerInstance.canvas.setText(["Pick your side and defeat all enemies!"])

	# Parent override for starting position to respect scaling
	playerInstance.position = Vector2((painting.get_texture().get_size().x * textureScale) / 2, (painting.get_texture().get_size().y * textureScale) / 2)

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		var randomX = rand_range(16, xRange / 2)
		randomize()
		nav.add_child(samuraiInstance)
		samuraiInstance.position = Vector2(randomX, 32 * (i+ 1))
		samuraiInstance.setTeam("blue")
		samuraiInstance.setNav(nav)

	for i in range(5):
		var samuraiInstance = load("res://entities/npc/samurai/samurai.tscn").instance()
		var randomX = rand_range(xRange / 2, xRange)
		randomize()
		nav.add_child(samuraiInstance)
		samuraiInstance.position = Vector2(randomX, 32 * (i + 1))
		samuraiInstance.animations.flip_h = true
		samuraiInstance.setTeam("red")
		samuraiInstance.setNav(nav)

	set_process_input(true)

# isLevelComplete
# Determines if the victory conditions have been met
func isLevelComplete():
	if !hasChosenTeam && !startEvent:
		return false
	elif playerInstance.is_in_group("neutral") and get_tree().get_nodes_in_group("samurai").size() == 0:
		return true
	elif playerInstance.is_in_group("blue") and get_tree().get_nodes_in_group("red").size() == 0:
		return true
	elif playerInstance.is_in_group("red") and get_tree().get_nodes_in_group("blue").size() == 0:
		return true
	else:
		return false

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
	elif isLevelComplete():
		complete = true
		openPortal()
