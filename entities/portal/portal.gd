extends Area2D

func _ready():
	pass

# Signals

func _on_portal_body_entered(body):
	levelLoader.currentIndex += 1
	sceneManager.goto_scene(levelLoader.getPath())
