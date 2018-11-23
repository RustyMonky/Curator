extends KinematicBody2D

var collisionObject = null
var hp = 3
var nav = null

# setNav
# Sets the navigation 2D reference
func setNav(navNode):
	nav = navNode