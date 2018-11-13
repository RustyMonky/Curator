extends KinematicBody2D

enum STATE { MOVE, ATTACK }

const SPEED = 64

onready var animations = $samuraiAnimations
onready var ray = $samuraiRay

var collisionObject = null
var currentState = STATE.MOVE
var direction = Vector2()
var hp = 3
var team = null

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if !get_parent().get_parent().startEvent:
		return
	else:
		animations.play()

	if currentState == STATE.MOVE:
		if animations.flip_h:
			self.direction = Vector2(-1, 0)
			ray.rotation_degrees = 180
		else:
			self.direction = Vector2(1, 0)
			ray.rotation_degrees = 0

		collisionObject = self.move_and_collide(self.direction.normalized() * SPEED * delta)

		if ray.is_colliding() && !ray.get_collider().is_in_group(team):
			currentState = STATE.ATTACK
			animations.set_animation("sword")
			animations.play()
			self.direction = Vector2()

# setTeam
# Sets the samurai team color and modulate
func setTeam(color):
	if color == "blue":
		self.add_to_group(color)
		team = color
		self.modulate = Color("4c93ad")
	elif color == "red":
		self.add_to_group(color)
		team = color
		self.modulate = Color("c93038")

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
		animations.set_animation("walkSwordSide")
		animations.play()

func _on_samuraiAnimations_frame_changed():
	# Determines if entity stands close enough to attack animation to take damage
	if currentState == STATE.ATTACK && collisionObject && collisionObject.collider.is_in_group("entities") && animations.get_frame() >= 5:
		collisionObject.collider.takeDamage()
