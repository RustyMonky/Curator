extends Control

onready var painting = $painting
onready var timer = $timer

var preventInputs = false

# When time permits, programatically generate the below array
var paintingsArray = [
	"res://assets/paintings/goya-satan-devouring-his-son.png",
	"res://assets/paintings/great-wave-off-kanagawa.png",
	"res://assets/paintings/sekigahara-kassen-byōbu-zu.jpg",
	"res://assets/paintings/starry-night.png",
	"res://assets/paintings/the-scream.png"
]

var paintingIndex = 0

func _ready():
	painting.texture = load(paintingsArray[paintingIndex])

	set_process(true)
	set_process_input(true)

	timer.start()

func _input(event):
	if preventInputs:
		return

	if event.is_action_pressed("ui_accept"):
		preventInputs = true
		fader.fadeToScene(levelLoader.getPath())

func _process(delta):
	if !timer.is_stopped():
		var paintingSize = painting.texture.get_size()
		if paintingSize.y >= paintingSize.x:
			painting.rect_position.y -= (1 * delta)
		elif paintingSize.x > paintingSize.y:
			painting.rect_position.x -= (1 * delta)
# Signals

func _on_timer_timeout():
	if (paintingIndex + 1) > (paintingsArray.size() - 1):
		paintingIndex = 0
	else:
		paintingIndex += 1

	painting.texture = load(paintingsArray[paintingIndex])
	painting.rect_position = Vector2(0, 0)
