extends KinematicBody2D

enum STATE { TEXT, REST, MOVING, HURT, DEAD }

const SPEED = 64

onready var animator = $playerAnimator
onready var arrow = $arrow
onready var canvas = $canvas
onready var playerAnimations = $playerAnimations

var currentAnimation = "walkSide"
var currentState = STATE.TEXT
var direction = Vector2(0, 0)
var hp = 3
var isInvulerable = false

func _ready():
	animator.set_autoplay("false")
	canvas.resetText()
	set_process(true)
	set_process_input(true)

func _input(event):
	if currentState == STATE.MOVING:
		if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
			currentState = STATE.REST
			playerAnimations.stop()
			playerAnimations.set_frame(0)

	elif currentState == STATE.TEXT:
		if event.is_action_pressed("ui_accept") && canvas.textLabel.percent_visible == 1:
			currentState = STATE.REST
			canvas.resetText()

func _process(delta):
	if currentState == STATE.MOVING || currentState == STATE.REST:
		if Input.is_action_pressed("ui_up"):
			self.direction = Vector2(0, -1)
			moveSelf(delta)
		elif Input.is_action_pressed("ui_down"):
			self.direction = Vector2(0, 1)
			moveSelf(delta)
		elif Input.is_action_pressed("ui_left"):
			self.direction = Vector2(-1, 0)
			playerAnimations.flip_h = true
			moveSelf(delta)
		elif Input.is_action_pressed("ui_right"):
			self.direction = Vector2(1, 0)
			playerAnimations.flip_h = false
			moveSelf(delta)

	if get_parent().has_node("portal"):
		arrow.set_visible(true)
		arrow.rotation = (get_parent().portalPosition - arrow.global_position).angle()

# moveSelf
# Moves the player and updates their current state
func moveSelf(delta):
	currentState = STATE.MOVING
	var collision = self.move_and_collide(self.direction * SPEED * delta)
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
		currentAnimation = "hurt"
		currentState = STATE.HURT
		playerAnimations.play(currentAnimation)

# Signals

func _on_playerAnimator_animation_finished(anim_name):
	if anim_name == "invulnerabilityFrames":
		isInvulerable = false

func _on_playerAnimations_animation_finished():
	if currentState == STATE.HURT:
		currentAnimation = "walkSide"
		currentState = STATE.REST
