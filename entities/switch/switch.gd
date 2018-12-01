extends Area2D

onready var collider = $switchCollider
onready var offSprite = load("res://assets/sprites/switch/off.png")
onready var onSprite = load("res://assets/sprites/switch/on.png")
onready var sfx = $switchSfx
onready var sprite = $switchSprite

var currentState = "On"
var switchSound = load("res://assets/sfx/buttonPress.wav")

func _ready():
	sfx.stream = switchSound

# Signals

func _on_switchArea_body_entered(body):
	# Only the player can activate switches!
	if !body.is_in_group("player"):
		return

	sfx.play()

	match (currentState):
		"Off":
			currentState = "On"
			sprite.texture = onSprite
		"On":
			currentState = "Off"
			sprite.texture = offSprite
