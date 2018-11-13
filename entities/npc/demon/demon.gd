extends KinematicBody

enum STATE { ATTACK, CHASE }

const SPEED = 0.5

onready var animations = $demonAnimations
onready var player = get_parent().get_node("player")
onready var ray = $demonRay

var collisionObject = null
var currentState = STATE.CHASE
var direction = Vector3()

func _ready():
	animations.play()
	set_physics_process(true)

func _physics_process(delta):
	if currentState == STATE.CHASE:
		if self.translation.z < player.translation.z:
			self.direction.z = 1
		elif self.translation.z > player.translation.z:
			self.direction.z = -1
		elif self.translation.z == player.translation.z:
			self.direction.z = 0

		if animations.flip_h && player.translation.x > self.translation.x:
			animations.flip_h = false
			self.direction.x = 1
		elif !animations.flip_h && player.translation.x < self.translation.x:
			animations.flip_h = true
			self.direction.x = -1

		if animations.flip_h == true:
			ray.rotation.x = 180
		else:
			ray.rotation.x = 0

		collisionObject = self.move_and_collide(self.direction.normalized() * SPEED * delta)

		if ray.is_colliding() && ray.get_collider().is_in_group("entities"):
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
	if currentState == STATE.ATTACK && collisionObject && collisionObject.collider.is_in_group("entities") && animations.get_frame() >= 5:
		collisionObject.collider.takeDamage()
