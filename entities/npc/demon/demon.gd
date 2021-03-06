extends "res://entities/npc/npc.gd"

const SPEED = 48

onready var animationPlayer = $demonPlayer
onready var animations = $demonAnimations
onready var collider = $demonShape
onready var player = get_parent().get_parent().get_node("player")
onready var ray = $demonRay
onready var sfx = $demonSfx
onready var timer = $demonDelay
onready var tween = $deathTween

var deathSound = load("res://assets/sfx/demonDeath.wav")
var hitSound = load("res://assets/sfx/demonGrunt.wav")
var navPointsArray = []

func _ready():
	# Override parent hp value
	hp = gameData.demon.hp
	animations.play()
	set_physics_process(true)

func _physics_process(delta):
	if !get_parent().get_parent().startEvent:
		return

	if currentState == STATE.MOVE:
		navPointsArray = nav.get_simple_path(self.global_position, player.global_position, false)

		if animations.flip_h && player.position.x > self.position.x:
			animations.flip_h = false
		elif !animations.flip_h && player.position.x < self.position.x:
			animations.flip_h = true

		if animations.flip_h == true:
			ray.rotation_degrees = 180
		else:
			ray.rotation_degrees = 0

		var velocity = (navPointsArray[1] - self.position).normalized() * SPEED * delta

		collisionObject = self.move_and_collide(velocity)

		# If colliding with an entity that's not an obstacle, current target, or on the same team, set that collider as the new target
		if collisionObject && collisionObject.collider.is_in_group("obstacles"):
				velocity = velocity.slide(collisionObject.normal)

		if ray.is_colliding() && weakref(ray.get_collider()) && ray.get_collider().is_in_group("entities"):
			currentState = STATE.ATTACK
			animations.set_animation("demonSmash")
			animations.play()

# takeDamage
# Decreases hp and removes from queue when dead
func takeDamage():
	hp -= 1

	if hp <= 0:
		gameData.hasDemon = false
		currentState = STATE.DEAD
		collider.disabled = true
		animations.set_animation("demonDeath")
		animations.play()
		sfx.stream = deathSound
		sfx.play()
	else:
		sfx.stream = hitSound
		sfx.play()
		currentState = STATE.HURT
		animations.play("demonHurt")
		animationPlayer.play("hurt")

# Signals

func _on_demonAnimations_animation_finished():
	if currentState == STATE.ATTACK || currentState == STATE.HURT:
		currentState = STATE.REST
		animations.set_animation("demonWalk")
		animations.stop()
		animations.set_frame(0)
		timer.start()
	elif currentState == STATE.DEAD:
		tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()

func _on_demonAnimations_frame_changed():
	# Determines if player stands close enough to demon's attack animation to take damage
	if currentState == STATE.ATTACK:
		if ray.is_colliding() && ray.get_collider():
			var collider = ray.get_collider()

			if collider.is_in_group("entities") && !collider.isHurt() && animations.get_frame() >= 6:
				collider.takeDamage()

func _on_demonDelay_timeout():
	if currentState == STATE.REST:
		currentState = STATE.MOVE
		animations.play()

func _on_deathTween_tween_completed(object, key):
	if currentState == STATE.DEAD:
		self.queue_free()
