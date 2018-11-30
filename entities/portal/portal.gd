extends Area2D

onready var collider = $portalShape

onready var tween = $portalTween

func _ready():
	tween.interpolate_property(self, "rotation", 0, 360, 500, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

# Signals

func _on_portal_body_entered(body):
	if body.is_in_group("player"):
		# Disable collisions, prevent inputs, stop animations, and hide the helper arrow
		collider.disabled = true
		body.preventInput = true
		body.playerAnimations.stop()
		body.arrow.hide()

		levelLoader.currentIndex += 1
		fader.fadeToScene(levelLoader.getPath())
