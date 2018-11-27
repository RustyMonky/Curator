extends CanvasLayer

onready var fadePlayer = $faderPlayer
onready var fadeRect = $faderRect

var scenePath

func _ready():
	pass

func fadeToScene(destinationPath):
	scenePath = destinationPath
	fadePlayer.play("fade")

func switchScene():
	sceneManager.goto_scene(levelLoader.getPath())
