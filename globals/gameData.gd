extends Node

var hasDemon = false

var demon = {
	hp = 5
}

var playerData = {
	hp = 3
}

# restart
# Resets game values
func restart():
	hasDemon = false
	demon.hp = 5
	playerData.hp = 3