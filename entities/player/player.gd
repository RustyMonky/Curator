extends KinematicBody2D

enum STATE { ATTACK, TEXT, REST, MOVING, HURT, DEAD }

const SPEED = 64

onready var animator = $playerAnimator
onready var arrow = $arrow
onready var canvas = $canvas
onready var collisionPoly = $playerPolygon
onready var playerAnimations = $playerAnimations
onready var ray = $playerRay
onready var sfx = $playerSfx

var currentAnimation = "walkSwordSide"
var currentState = STATE.TEXT
var direction = Vector2(0, 0)
var hitSound = load("res://assets/sfx/fleshHit.wav")
var isInvulerable = false
var preventInput = false
var swordSound = load("res://assets/sfx/swordSwish.wav")

func _ready():
	animator.set_autoplay("false")
	canvas.resetText()
	set_process(true)
	set_process_input(true)

func _input(event):
	if preventInput:
		return

	match (currentState):
		STATE.REST:
			if event.is_action_pressed("ui_accept"):
				currentState = STATE.ATTACK
				playerAnimations.play("sword")
				sfx.stream = swordSound
				sfx.play()

		STATE.MOVING:
			if event.is_action_released("ui_up") || event.is_action_released("ui_down") || event.is_action_released("ui_left") || event.is_action_released("ui_right"):
				currentState = STATE.REST
				playerAnimations.stop()
				playerAnimations.set_frame(0)

			elif event.is_action_pressed("ui_accept"):
				currentState = STATE.ATTACK
				playerAnimations.play("sword")
				sfx.stream = swordSound
				sfx.play()

		STATE.TEXT:
			if event.is_action_pressed("ui_accept") && canvas.textLabel.percent_visible == 1:
				if canvas.currentTextIndex == (canvas.currentTextArray.size() - 1) && canvas.optionsHBox.get_children().size() == 0:
					currentState = STATE.REST
					canvas.resetText()
				else:
					canvas.showNextText()
			elif event.is_action_pressed("ui_accept") && !canvas.textLabel.percent_visible == 1:
				canvas.textLabel.percent_visible = 0.99

func _process(delta):
	if preventInput:
		return

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
			ray.rotation_degrees = 180
			currentAnimation = "walkSwordSide"
			moveSelf(delta)
		elif Input.is_action_pressed("ui_right"):
			self.direction = Vector2(1, 0)
			playerAnimations.flip_h = false
			ray.rotation_degrees = 0
			currentAnimation = "walkSwordSide"
			moveSelf(delta)

	if get_parent().has_node("portal"):
		arrow.set_visible(true)
		arrow.rotation = (get_parent().portalPosition - arrow.global_position).angle()

# isHurt
# Returns whether or not player is currently hurt
func isHurt():
	return currentState == STATE.HURT

# moveSelf
# Moves the player and updates their current state
func moveSelf(delta):
	currentState = STATE.MOVING
	var collision = self.move_and_collide(self.direction * SPEED * delta)
	playerAnimations.play(currentAnimation)

# takeDamage
# Decreases player hp, triggers death, and starts invulnerability animation
func takeDamage():
	if isInvulerable || currentState == STATE.DEAD:
		return

	gameData.playerData.hp -= 1
	canvas.takeDamage()

	if gameData.playerData.hp <= 0:
		currentState = STATE.DEAD
		playerAnimations.play("death")
	else:
		animator.play("invulnerabilityFrames")
		sfx.stream = hitSound
		sfx.play()
		isInvulerable = true
		currentAnimation = "hurt"
		currentState = STATE.HURT
		playerAnimations.play(currentAnimation)
		collisionPoly.disabled = true

# Signals

func _on_playerAnimator_animation_finished(anim_name):
	if anim_name == "invulnerabilityFrames":
		isInvulerable = false
		collisionPoly.disabled = false

func _on_playerAnimations_animation_finished():
	if currentState == STATE.HURT || currentState == STATE.ATTACK:
		currentState = STATE.REST
		playerAnimations.stop()
		playerAnimations.set_frame(0)
	elif currentState == STATE.DEAD:
		fader.fadeToScene("res://levels/gameover/gameover.tscn")

func _on_playerAnimations_frame_changed():
	if currentState == STATE.ATTACK && ray.is_colliding():
		var collider = ray.get_collider()

		if collider.is_in_group("entities") && !collider.isHurt() && playerAnimations.get_frame() >= 5:
			collider.takeDamage()

			# If entity is a samurai, they'll now target the player
			if collider.is_in_group("samurai"):
				collider.setTarget(self)
