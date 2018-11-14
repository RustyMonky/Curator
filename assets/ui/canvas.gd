extends CanvasLayer

onready var optionsHBox = $container/optionsHBox
onready var textBox = $container/textBox
onready var textLabel = $container/textBox/text

var currentHBoxIndex = 0

var currentTextArray = []
var currentTextIndex = 0

var fontFortification = load("res://assets/fonts/dynamicFonts/fortification.tres")

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_right") && optionsHBox.get_children().size() > 0:
		if currentHBoxIndex + 1 == optionsHBox.get_children().size():
			currentHBoxIndex = 0
		else:
			currentHBoxIndex += 1
		updateHBoxOptionHighlight()
	elif event.is_action_pressed("ui_left") && optionsHBox.get_children().size() > 0:
		if currentHBoxIndex - 1 < 0:
			currentHBoxIndex = optionsHBox.get_children().size() - 1
		else:
			currentHBoxIndex -= 1
		updateHBoxOptionHighlight()

# resetHBoxOptions
# Clears the hbox container and resets the pointer index
func resetHBoxOptions():
	for option in optionsHBox.get_children():
		option.queue_free()
	currentHBoxIndex = 0

# resetText
# Clears the label and hides the text box
func resetText():
	textBox.hide()
	textLabel.text = ""
	currentTextIndex = 0

# setHBoxOptions
# Populates the hbox container with labels that represent selectable options
func setHBoxOptions(optionsArray):
	for option in optionsArray:
		var optionLabel = Label.new()
		optionLabel.text = option
		optionLabel.set("custom_fonts/font", fontFortification)
		optionLabel.set("custom_colors/font_color", Color("ffffff"))
		optionsHBox.add_child(optionLabel)

	optionsHBox.get_children()[0].set("custom_colors/font_color", Color("826481"))

# setText
# Shows the text box and updates its content
func setText(textArray):
	textBox.show()
	currentTextArray = textArray
	textLabel.text = textArray[currentTextIndex]

# showNextText
# Increments the current text index to display the next string
func showNextText():
	currentTextIndex += 1
	textLabel.visible_characters = 0
	textLabel.text = currentTextArray[currentTextIndex]

# updateHBoxOptionHighlight
# Updates highlighting of option after user input
func updateHBoxOptionHighlight():
	for option in optionsHBox.get_children():
		if optionsHBox.get_children().find(option) == currentHBoxIndex:
			option.set("custom_colors/font_color", Color("826481"))
		else:
			option.set("custom_colors/font_color", Color("ffffff"))

# Signals

func _on_textTimer_timeout():
	if textLabel.visible_characters != textLabel.get_total_character_count():
		textLabel.visible_characters += 1
