extends Area

onready var tween = $portalTween

func _ready():
	tween.interpolate_property(self, "rotation", Vector3(), Vector3(0, 360, 0), 50, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

# Signals

func _on_portal_body_entered(body):
	levelLoader.currentIndex += 1
	sceneManager.goto_scene(levelLoader.getPath())
