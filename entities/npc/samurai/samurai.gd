extends "res://entities/npc/npc.gd"

enum STATE { MOVE, ATTACK, HURT, REST }

const SPEED = 24

onready var animations = $samuraiAnimations
onready var delayTimer = $samuraiAttackDelay
onready var sceneParent = get_parent().get_parent()
onready var ray = $samuraiRay

var currentState = STATE.MOVE
var navPointsArray = []
var selfIndex
var target = null
var targetRef = null
var team = null

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if !sceneParent.startEvent:
		currentState = STATE.REST
		return

	elif currentState == STATE.REST && delayTimer.time_left == 0:
		currentState = STATE.MOVE
		animations.play()

	if currentState == STATE.MOVE:
		if !target || !targetRef.get_ref():

			selfIndex = get_tree().get_nodes_in_group(team).find(self)
			if selfIndex >= 0:
				match (team):
					"red":
						var blueSamuraiGroup = get_tree().get_nodes_in_group("blue")
						if blueSamuraiGroup.size() > selfIndex:
							setTarget(blueSamuraiGroup[selfIndex])
						elif !blueSamuraiGroup.empty():
							setTarget(blueSamuraiGroup.front())
					"blue":
						var redSamuraiGroup = get_tree().get_nodes_in_group("red")
						if redSamuraiGroup.size() > selfIndex:
							setTarget(redSamuraiGroup[selfIndex])
						elif !redSamuraiGroup.empty():
							setTarget(redSamuraiGroup.front())

		else:
			# Determine if animation horizontal flip is required
			if animations.flip_h == true:
				ray.rotation_degrees = 180
			else:
				ray.rotation_degrees = 0

			animations.play("samuraiWalk")

		var velocity = (navPointsArray[1] - self.position).normalized() * SPEED * delta

		collisionObject = self.move_and_collide(velocity)

		# If colliding with an entity that's not an obstacle, current target, or on the same team, set that collider as the new target
		if collisionObject:
			if collisionObject.collider != target && !collisionObject.collider.is_in_group(team) && collisionObject.collider.is_in_group("entities"):
				setTarget(collisionObject.collider)
			elif collisionObject.collider.is_in_group("obstacles") || collisionObject.collider.is_in_group(team):
				velocity = velocity.slide(collisionObject.normal)

		# Horizontal Collisions
		if ray.is_colliding() && ray.get_collider():
			var rayCollider = ray.get_collider()
			# If colliding with an obstacle, just turn around
			if rayCollider.is_in_group("obstacle"):
				animations.flip_h = !animations.flip_h

				if animations.flip_h:
					ray.rotation_degrees = 180
				else:
					ray.rotation_degrees = 0

			# If colliding with a teammate, stop moving horizontally
			elif rayCollider.is_in_group(team):
				setWait()

			# Otherwise, if colliding with an entity not on the same team, attack
			elif !rayCollider.is_in_group(team) && rayCollider.is_in_group("entities"):
				setTarget(rayCollider)
				currentState = STATE.ATTACK
				animations.set_animation("samuraiSword")
				animations.play()

# setTarget
# Sets the target and a weak reference to it for future freed instances
func setTarget(targetEntity):
	target = targetEntity
	targetRef = weakref(target)
	navPointsArray = nav.get_simple_path(self.global_position, target.global_position, false)

# setTeam
# Sets the samurai team color and modulate
func setTeam(color):
	self.add_to_group(color)
	team = color

	match (color):
		"blue":
			self.modulate = Color("4c93ad")
		"red":
			self.modulate = Color("c93038")

# setWait
# Sets current state to rest and starts delay timer
func setWait():
	currentState = STATE.REST
	delayTimer.start()

# takeDamage
# Decreases hp and removes from queue when dead
func takeDamage():
	hp -= 1

	if hp <= 0:
		self.queue_free()
	else:
		currentState = STATE.HURT
		animations.play("samuraiHurt")

# Signals

func _on_samuraiAnimations_animation_finished():
	if currentState == STATE.ATTACK || currentState == STATE.HURT:
		animations.set_animation("samuraiWalk")
		# Then, specifically if they just attacked, delay their next strike:
		if currentState == STATE.ATTACK:
			currentState = STATE.REST
			delayTimer.start()
		else:
			currentState = STATE.MOVE
			animations.play("samuraiWalk")

func _on_samuraiAnimations_frame_changed():
	# Determines if entity stands close enough to attack animation to take damage
	if currentState == STATE.ATTACK && ray.is_colliding() && ray.get_collider().is_in_group("entities") && animations.get_frame() == 5:
		ray.get_collider().takeDamage()

func _on_samuraiDetectArea_body_entered(body):
	if body.is_in_group("entities") && !body.is_in_group(team):
		setTarget(body)

func _on_samuraiAttackDelay_timeout():
	currentState = STATE.MOVE
	animations.set_animation("samuraiWalk")
	animations.play()
