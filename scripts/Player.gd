extends CharacterBody3D

var direction = Vector3.ZERO
@export var speed = 0.5
var rotation_speed = 100
var axis = 0.0
var walking = false
@export var speed_move = 0.1
@onready var foots = $footStep
@onready var footsStep = $footSteps

var movingPlayerToPos = false
var distanceBetween = 0
var angleToRot = 0
var aiming = false
var walkOrPistol = 0.0

# Posiciones para el player
@export var pos1: Node3D
@export var pos2: Node3D

var currentPos = 1
var posNow: Node3D
var posToMove: Node3D

var posSet = false

signal playerMoveDone

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3(0.0,-1.0,0.0)
	walking = false
	
	# ya se calcula de la posicion 2
	# ver la forma de indicar que posicion se desea calcular.
	# calcular distancia entre jugador y objetos
	if currentPos == 1:
		posToMove = pos2
		posNow = pos1
	else:
		posToMove = pos1
		posNow = pos2
	
	distanceBetween = round(global_transform.origin.distance_to(posToMove.global_transform.origin))
	
	if distanceBetween <= 1:
		if currentPos == 1:
			currentPos = 2
		else:
			currentPos = 1
		movingPlayerToPos = false
		emit_signal("playerMoveDone")
	
	# mover al jugador a la posicion deseada
	if movingPlayerToPos:
		if posSet == false:
			global_position = posNow.global_position
			global_rotation = posNow.global_rotation
		
		await get_tree().create_timer(0.5).timeout
		
		posSet = true
			
		if posSet == true:
			velocity += Vector3(sin(rotation.y), 0, cos(rotation.y)) * speed * delta
			global_position = lerp(global_position, posToMove.global_position, 0.001)
			axis = lerp(axis, 1.0, speed_move)
			walking = true
		
	if Input.is_action_pressed("foward") && movingPlayerToPos == false:
		velocity += Vector3(sin(rotation.y), 0, cos(rotation.y)) * speed * delta
		axis = lerp(axis, 1.0, speed_move)
		walking = true
	if Input.is_action_pressed("backward") && movingPlayerToPos == false:
		velocity += Vector3(sin(rotation.y) * -1, 0, cos(rotation.y) * -1) * speed * delta
		axis = lerp(axis, -1.0, speed_move)
		walking = true
	if Input.is_action_pressed("left") && movingPlayerToPos == false:
		direction.y += rotation_speed
	if Input.is_action_pressed("right") && movingPlayerToPos == false:
		direction.y -= rotation_speed
		
	if Input.is_action_just_pressed("Arma"):
		aiming = !aiming
		
	if !walking:
		axis = lerp(axis, 0.0, speed_move)
		#if footsStep.is_playing():
			#footsStep.stop()
	#elif walking && !footsStep.is_playing():
		#footsStep.play("foot_step")
	
	direction.y = deg_to_rad(direction.y)
	rotate_y(direction.y * delta)
	
	# usando arma o caminando
	if aiming == true:
		if walkOrPistol < 1.0:
			walkOrPistol = lerp(walkOrPistol, 1.0, 0.2)
		$jill/AnimationTree.set("parameters/Blend2/blend_amount", walkOrPistol)
		$jill/AnimationTree.set("parameters/walkPistol/blend_position", axis)
	else:
		if walkOrPistol > 0.0:
			walkOrPistol = lerp(walkOrPistol, 0.0, 0.2)
		$jill/AnimationTree.set("parameters/Blend2/blend_amount", walkOrPistol)
		$jill/AnimationTree.set("parameters/mainWalk/blend_position", axis)
	
	move_and_slide()

func move_player_to_pos():
	movingPlayerToPos = true
