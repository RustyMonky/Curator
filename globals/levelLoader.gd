extends Node

var currentIndex = 0

onready var levels = [
	"goya-satan",
	"sekigahara",
	"the-scream"
]

onready var loadedLevels = []

func _ready():
	while loadedLevels.size() < levels.size():
		appendNextLevel()
	loadedLevels.push_front("kanagawa-wave")

# appendNextLevel
# Adds next unique level to loaded levels array
func appendNextLevel():
	randomize()
	var index = randi() % levels.size()

	if loadedLevels.has(levels[index]):
		appendNextLevel()
	else:
		loadedLevels.append(levels[index])

# getPath
# Returns path of level scene based on current index
func getPath():
	var levelName = loadedLevels[currentIndex]
	return "res://levels/" + levelName + "/" + levelName + ".tscn"