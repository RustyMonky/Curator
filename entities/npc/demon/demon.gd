extends KinematicBody2D

const SPEED = 64

onready var animations = $demonAnimations
onready var player = get_parent().get_node("player")

var direction = Vector2()

func _ready():
	animations.play()
	set_process(true)

func _process(delta):
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

	self.move_and_collide(self.direction.normalized() * SPEED * delta)
