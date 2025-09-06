extends CharacterBody3D

@export var speed = 0.5
var accel = 1
var move = 0.0
@export var speed_move = 2

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var rayCast: RayCast3D = $RayCast3D
@onready var tree: AnimationTree = $tyrant/AnimationTree
@onready var timer: Timer = $ReactionTime
@export var target: RigidBody3D
@export var targetB: CharacterBody3D
var playerReach: bool = false
var playerDetected: bool = false
var direction: Vector3 = Vector3()
var lookTo
var currentLook

func _physics_process(delta):
	
	if rayCast.enabled && rayCast.is_colliding():
		if rayCast.get_collider().get("name") == "Player":
			playerDetected = true
			rayCast.enabled = false
	
	if !playerDetected:
		return
	
	if !playerReach:
		move = lerp(move, 1.0, speed_move * delta)
		
		nav.target_position = targetB.global_position
		
		if currentLook == null:
			currentLook = targetB.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		direction.y = 0.0 #para que el enemigo quede sobre el suelo
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		
		lookTo = lerp(currentLook, targetB.global_position, accel * delta)
		
		# hacer que el enemigo mire en la direccion del jugador
		look_at(lookTo)
		
		currentLook = lookTo
		
		tree.set("parameters/Transition/transition_request", "walking") # cambiar a animacion de caminar
		
		move_and_slide()
	else:
		move = lerp(move, 0.0, speed_move * delta)
		tree.set("parameters/Transition/transition_request", "attack") # cambiar a animacion de atacar
	
	tree.set("parameters/walk_cycle/blend_position", move)

# detectar cuando el jugador está al alcance
func _on_area_3d_body_entered(body):
	if body.name == "Player":
		if timer.is_stopped():
			playerReach = true
			currentLook = targetB.global_position
		else:
			timer.stop()

# detectar cuando el jugador sale del alcance
func _on_area_3d_body_exited(body):
	if body.name == "Player":
		timer.start()


func _on_reaction_time_timeout():
	playerReach = false
