extends Area2D

onready var offSprite = load("res://assets/sprites/switch/off.png")
onready var onSprite = load("res://assets/sprites/switch/on.png")
onready var sprite = $switchSprite

var currentState = "On"

func _ready():
	pass

# Signals

func _on_switchArea_body_entered(body):
	match (currentState):
		"Off":
			currentState = "On"
			sprite.texture = onSprite
		"On":
			currentState = "Off"
			sprite.texture = offSprite
