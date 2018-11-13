extends "res://entities/npc/npc.gd"

enum STATE { REST, ATTACK, CHASE, HURT }

const SPEED = 64

onready var animations = $demonAnimations
onready var player = get_parent().get_node("player")
onready var ray = $demonRay
onready var timer = $demonDelay

var currentState = STATE.CHASE

func _ready():
	# Override parent hp value
	hp = 5
	animations.play()
	set_physics_process(true)

func _physics_process(delta):
	if !get_parent().startEvent:
		return

	if currentState == STATE.CHASE:
		if self.position.y < player.position.y:
			self.direction.y = 1
		elif self.position.y > player.position.y:
			self.direction.y = -1
		elif self.position.y == player.position.y:
			self.direction.y = 0

		if animations.flip_h && player.position.x > self.position.x:
			animations.flip_h = false
			self.direction.x = 1
		elif !animations.flip_h && player.position.x < self.position.x:
			animations.flip_h = true
			self.direction.x = -1

		if animations.flip_h == true:
			ray.rotation_degrees = 180
		else:
			ray.rotation_degrees = 0

		collisionObject = self.move_and_collide(self.direction.normalized() * SPEED * delta)

		if ray.is_colliding() && ray.get_collider().is_in_group("entities"):
			currentState = STATE.ATTACK
			animations.set_animation("smash")
			animations.play()

# takeDamage
# Decreases hp and removes from queue when dead
func takeDamage():
	hp -= 1

	if hp <= 0:
		self.queue_free()
	else:
		currentState = STATE.HURT
		animations.play("hurt")

# Signals

func _on_demonAnimations_animation_finished():
	if currentState == STATE.ATTACK || currentState == STATE.HURT:
		currentState = STATE.REST
		animations.set_animation("walkSide")
		animations.stop()
		animations.set_frame(0)
		timer.start()

func _on_demonAnimations_frame_changed():
	# Determines if player stands close enough to demon's attack animation to take damage
	if currentState == STATE.ATTACK:
		if ray.is_colliding() && ray.get_collider().is_in_group("entities") && animations.get_frame() == 6:
			ray.get_collider().takeDamage()

func _on_demonDelay_timeout():
	if currentState == STATE.REST:
		currentState = STATE.CHASE
		animations.play()
