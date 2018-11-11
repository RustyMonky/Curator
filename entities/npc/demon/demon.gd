extends KinematicBody2D

enum STATE { ATTACK, CHASE }

const SPEED = 64

onready var animations = $demonAnimations
onready var player = get_parent().get_node("player")
onready var ray = $demonRay

var collisionObject = null
var currentState = STATE.CHASE
var direction = Vector2()

func _ready():
	animations.play()
	set_process(true)

func _process(delta):
	if currentState == STATE.CHASE:
		if self.global_position.y < player.position.y:
			self.direction.y = 1
		elif self.global_position.y > player.position.y:
			self.direction.y = -1
		elif self.global_position.y == player.position.y:
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

		if ray.is_colliding() && ray.get_collider() == player:
			currentState = STATE.ATTACK
			animations.set_animation("smash")
			animations.play()

# Signals

func _on_demonAnimations_animation_finished():
	if currentState == STATE.ATTACK:
		currentState = STATE.CHASE
		animations.set_animation("walkSide")
		animations.play()

func _on_demonAnimations_frame_changed():
	# Determines if player stands close enough to demon's attack animation to take damage
	if currentState == STATE.ATTACK && collisionObject && collisionObject.collider == player && animations.get_frame() >= 5:
		print("Hit!")
