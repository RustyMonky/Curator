extends KinematicBody2D

enum STATE { MOVE, ATTACK, HURT, REST }

var collisionObject = null
var currentState = STATE.MOVE
var hp = 3
var nav = null

# isHurt
# Returns whether or not npc is currently hurt
func isHurt():
	return currentState == STATE.HURT

# setNav
# Sets the navigation 2D reference
func setNav(navNode):
	nav = navNode