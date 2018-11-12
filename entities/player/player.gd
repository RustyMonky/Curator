extends KinematicBody2D

enum STATE { REST, MOVING, DEAD }

const SPEED = 2

onready var animator = $playerAnimator
onready var arrow = $arrow
onready var playerAnimations = $playerAnimations

var currentAnimation = "walkSide"
var currentState = STATE.REST
var direction = Vector2(0, 0)
var hp = 3
var isInvulerable = false

func _ready():
	animator.set_autoplay("false")
	set_process(true)
	set_process_input(true)

func _input(event):
	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		self.direction = Vector2(0, -1)
		moveSelf()
	elif Input.is_action_pressed("ui_down"):
		self.direction = Vector2(0, 1)
		moveSelf()
	elif Input.is_action_pressed("ui_left"):
		self.direction = Vector2(-1, 0)
		playerAnimations.flip_h = true
		moveSelf()
	elif Input.is_action_pressed("ui_right"):
		self.direction = Vector2(1, 0)
		playerAnimations.flip_h = false
		moveSelf()

	if currentState == STATE.REST:
		if playerAnimations.is_playing():
			playerAnimations.stop()
			playerAnimations.set_frame(0)

	if get_parent().has_node("portal"):
		arrow.set_visible(true)
		arrow.rotation = (get_parent().portalPosition - arrow.global_position).angle()

# moveSelf
# Moves the player and updates their current state
func moveSelf():
	currentState = STATE.MOVING
	var collision = self.move_and_collide(self.direction * SPEED)
	playerAnimations.play(currentAnimation)

# takeDamage
# Decreases player hp, triggers death, and starts invulnerability animation
func takeDamage():
	if isInvulerable:
		return

	self.hp -= 1
	if hp <= 0:
		sceneManager.goto_scene("res://levels/gameover/gameover.tscn")
	else:
		animator.play("invulnerabilityFrames")
		isInvulerable = true

# Signals

func _on_playerAnimator_animation_finished(anim_name):
	if anim_name == "invulnerabilityFrames":
		isInvulerable = false
