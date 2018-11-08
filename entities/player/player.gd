extends KinematicBody2D

enum STATE { REST, MOVING, DEAD }

const SPEED = 2

onready var arrow = $arrow
onready var playerAnimations = $playerAnimations

var currentAnimation = "walkSide"
var currentState = STATE.REST
var direction = Vector2(0, 0)

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		self.direction = Vector2(0, -1)
		move_self()
	elif Input.is_action_pressed("ui_down"):
		self.direction = Vector2(0, 1)
		move_self()
	elif Input.is_action_pressed("ui_left"):
		self.direction = Vector2(-1, 0)
		playerAnimations.flip_h = true
		move_self()
	elif Input.is_action_pressed("ui_right"):
		self.direction = Vector2(1, 0)
		playerAnimations.flip_h = false
		move_self()

	if currentState == STATE.REST:
		if playerAnimations.is_playing():
			playerAnimations.stop()
			playerAnimations.set_frame(0)

	if get_parent().has_node("portal"):
		arrow.set_visible(true)
		arrow.rotation = (get_parent().portalPosition - arrow.global_position).angle()

func move_self():
	currentState = STATE.MOVING
	var collision = self.move_and_collide(self.direction * SPEED)
	playerAnimations.play(currentAnimation)