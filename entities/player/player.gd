extends KinematicBody2D

const SPEED = 2

onready var playerAnimations = $playerAnimations

var currentAnimation = "walkDown"
var direction = Vector2(0, 0)

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		self.direction = Vector2(0, -1)
		self.currentAnimation = "walkUp"
		move_self()
	elif Input.is_action_pressed("ui_down"):
		self.direction = Vector2(0, 1)
		self.currentAnimation = "walkDown"
		move_self()
	elif Input.is_action_pressed("ui_left"):
		self.direction = Vector2(-1, 0)
		move_self()
	elif Input.is_action_pressed("ui_right"):
		self.direction = Vector2(1, 0)
		move_self()

func move_self():
	var collision = self.move_and_collide(self.direction * SPEED)
	playerAnimations.play(currentAnimation)