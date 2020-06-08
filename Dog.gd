extends Node2D

var moveTarget := Vector2.ZERO
var jumpPeak = Vector2.ZERO
var start = Vector2.ZERO
var speed = 8
var jumpDistances = [8, 8, 8, 8] # up, down, left, right
var jumpHeights = [12, 4, 4, 4] # up, down, left, right

var moveTime: float = 0

func _ready():
	pass

func _process(delta: float):
	if moveTarget != Vector2.ZERO:
		var q0 = start.linear_interpolate(jumpPeak, moveTime)
		var q1 = jumpPeak.linear_interpolate(moveTarget, moveTime)
		position = q0.linear_interpolate(q1, moveTime)
		if moveTime >= 1.0:
			moveTime = 0
			position = moveTarget
			moveTarget = Vector2.ZERO
		moveTime += delta * speed

func _input(event: InputEvent):
	if moveTarget == Vector2.ZERO:
		var jumpHeight = 0
		if event.is_action_pressed("ui_up"):
			moveTarget = Vector2(position.x, position.y - jumpDistances[0])
			jumpHeight = jumpHeights[0]
		elif event.is_action_pressed("ui_down"):
			moveTarget = Vector2(position.x, position.y + jumpDistances[1])
			jumpHeight = jumpHeights[1]
		elif event.is_action_pressed("ui_left"):
			moveTarget = Vector2(position.x - jumpDistances[2], position.y)
			jumpHeight = jumpHeights[2]
			scale.x = 1
		elif event.is_action_pressed("ui_right"):
			moveTarget = Vector2(position.x + jumpDistances[3], position.y)
			jumpHeight = jumpHeights[3]
			scale.x = -1

		if moveTarget != Vector2.ZERO:
			start = position
			jumpPeak = Vector2(position.x, position.y - jumpHeight)
			moveTime = 0.0
