extends KinematicBody

enum STATE { MOVE, ATTACK }

const SPEED = 1

onready var animations = $samuraiAnimations
onready var ray = $samuraiRay

var collisionObject = null
var currentState = STATE.MOVE
var direction = Vector3()
var hp = 3
var team = null

func _ready():
	set_physics_process(true)
	animations.play()

func _physics_process(delta):
	if currentState == STATE.MOVE:
		if animations.flip_h:
			self.direction = Vector3(-1, 0, 0)
			ray.rotation.x = 180
		else:
			self.direction = Vector3(1, 0, 0)
			ray.rotation.x = 0

		collisionObject = self.move_and_collide(self.direction.normalized() * SPEED * delta)

		if ray.is_colliding() && !ray.get_collider().is_in_group(team):
			currentState = STATE.ATTACK
			animations.set_animation("sword")
			animations.play()
			self.direction = Vector3()

# setTeam
# Sets the samurai team color and modulate
func setTeam(color):
	if color == "blue":
		self.add_to_group(color)
		team = color
		self.animations.modulate = Color("4c93ad")
	elif color == "red":
		self.add_to_group(color)
		team = color
		self.animations.modulate = Color("c93038")

# takeDamage
# Decreases hp and removes from queue when dead
func takeDamage():
	hp -= 1
	if hp <= 0:
		self.queue_free()

# Signals

func _on_samuraiAnimations_animation_finished():
	if currentState == STATE.ATTACK:
		currentState = STATE.MOVE
		animations.set_animation("walkSide")
		animations.play()

func _on_samuraiAnimations_frame_changed():
	# Determines if entity stands close enough to attack animation to take damage
	if currentState == STATE.ATTACK && collisionObject && collisionObject.collider.is_in_group("entities") && animations.get_frame() >= 5:
		collisionObject.collider.takeDamage()