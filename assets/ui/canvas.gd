extends CanvasLayer

onready var optionsHBox = $container/optionsHBox
onready var textBox = $container/textBox
onready var textLabel = $container/textBox/text

var currentTextArray = []
var currentTextIndex = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

# resetText
# Clears the label and hides the text box
func resetText():
	textBox.hide()
	textLabel.text = ""
	currentTextIndex = 0

# setText
# Shows the text box and updates its content
func setText(textArray):
	textBox.show()
	currentTextArray = textArray
	textLabel.text = textArray[currentTextIndex]

func showNextText():
	currentTextIndex += 1
	textLabel.visible_characters = 0
	textLabel.text = currentTextArray[currentTextIndex]

# Signals

func _on_textTimer_timeout():
	if textLabel.visible_characters != textLabel.get_total_character_count():
		textLabel.visible_characters += 1
