extends Area2D

const SPEED = 32

onready var sprite = $screamSprite

var destination = Vector2()
var direction = Vector2()

func _ready():
	sprite.rotation = (destination - self.position).angle()

	if self.destination.x > self.position.x:
		self.direction.x = 1
	elif self.destination.x < self.position.x:
		self.direction.x = -1

	if self.destination.y > self.position.y:
		self.direction.y = 1
	elif self.destination.y < self.position.y:
		self.direction.y = -1

	set_physics_process(true)

func _physics_process(delta):
	self.scale.x += 0.05
	self.scale.y += 0.05

	self.global_position += self.direction.normalized() * SPEED * delta

func _on_screamBlast_body_entered(body):
	if body.is_in_group("entities"):
		body.takeDamage()
		self.queue_free()
