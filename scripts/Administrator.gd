extends Node3D

@onready var cam0: Camera3D = $cameras/Cam0
@onready var cam1: Camera3D = $cameras/Cam1
@onready var cam2: Camera3D = $cameras/Cam2
@onready var cam3: Camera3D = $cameras/Cam3
@onready var cam4: Camera3D = $cameras/Cam4
@onready var cam5: Camera3D = $cameras/Cam5
@onready var cam6: Camera3D = $cameras/Cam6
@onready var cam7: Camera3D = $cameras/Cam7
@onready var cam8: Camera3D = $cameras/Cam8

@onready var door_locked: AnimationPlayer = $AnimationPlayer
# colisiones a desactivar
@onready var colEscalera: CollisionShape3D = $Alfombra_escalera/alfombra/PuertaEscaleraBaja
@onready var colEscaleraArriba: CollisionShape3D = $Alfombra_escalera/alfombra/PuertaEscaleraAlta
@onready var colEscaleraArea: CollisionShape3D = $Alfombra_escalera/AreaEscaleraInferior/CollisionShape3D
@onready var colEscaleraArribaArea: CollisionShape3D = $Alfombra_escalera/AreaEscaleraSuperior/CollisionShape3D
@onready var screen_transition: AnimationPlayer = $scene_transition/fundido

# dialogos
@export var dialog_puerta: DialogueResource
@export var dialog_puerta_cerrada: DialogueResource
@export var dialog_maquina: DialogueResource
@export var dialog_inicio: DialogueResource

const Balloon = preload("res://dialogos/balloon.tscn")

# para los dialogos
enum DialogText { closed_door, table, front_door, start }

var close_door = null
var playerNearUpstairs = false

signal playerCanMove

var isStart = true

func _ready():
	start()

func start():
	cam0.make_current()
	
	close_door = DialogText.start
	action()
	

func _process(delta):
	if close_door != null && Input.is_action_just_pressed("ui_accept"):
		action()
	
	# salir del juego
	if Input.is_action_just_pressed("salir"):
		get_tree().quit()
	
	if playerNearUpstairs && Input.is_action_just_pressed("escalar"):
		colEscalera.disabled = true
		colEscaleraArriba.disabled = true
		colEscaleraArribaArea.disabled = true
		colEscaleraArea.disabled = true
		emit_signal("playerCanMove")
	
func action() -> void:
	# usando un template personalizado
	var balloon: Node = Balloon.instantiate()
	
	get_tree().current_scene.add_child(balloon)
	
	# match es el equivalente a switch case
	match close_door:
		DialogText.closed_door:
			door_locked.play("door_locked")
			balloon.start(dialog_puerta_cerrada, "puerta_cerrada")
		DialogText.table:
			balloon.start(dialog_maquina, "mesa")
		DialogText.front_door:
			door_locked.play("door_locked")
			balloon.start(dialog_puerta, "puerta")
		DialogText.start:
			balloon.start(dialog_inicio, "inicio")
	
	# conectar señal para cuando termina el mensaje
	balloon.connect("message_over", is_dialog_showing_done)
	
	close_door = null
	# pausar el juego
	get_tree().paused = true

func is_dialog_showing_done():
	get_tree().paused = false
	
	if isStart:
		isStart = false
		screen_transition.play("fade_out")
		
		await screen_transition.animation_finished
		
		await get_tree().create_timer(2.0).timeout
		
		cam1.make_current()

# # # Camera areas
func _on_area_3d_body_exited(body):
	set_active_camera(body.name, cam1, cam2)

func area_2(body):
	set_active_camera(body.name, cam2, cam3)

func area_1_3(body):
	set_active_camera(body.name, cam1, cam3)

func area_1_4(body):
	set_active_camera(body.name, cam1, cam4)

func area_4_5(body):
	set_active_camera(body.name, cam4, cam5)

func area_1_6(body):
	set_active_camera(body.name, cam1, cam6)

func area_6_7(body):
	set_active_camera(body.name, cam6, cam7)

func area_6_8(body):
	set_active_camera(body.name, cam6, cam8)

func area_7_8(body):
	set_active_camera(body.name, cam7, cam8)
# # # end Camera areas

# custom camera driver
func set_active_camera(bodyName: String, camA: Camera3D, camB: Camera3D):
	if bodyName == "Player":
		if camA.current:
			camB.make_current()
		elif camB.current:
			camA.make_current()
	

# # # Messages area
func _on_area_3d_body_entered(body):
	if body.name == "Player":
		close_door = DialogText.front_door # usando un enum para pasar datos

func on_avoid_area(body):
	close_door = null
	
func door_closed(body):
	if body.name == "Player":
		close_door = DialogText.closed_door

func table_machine(body):
	if body.name == "Player":
		close_door = DialogText.table
# # # end Messages area

func up_down_stairs(body):
	if body.name == "Player":
		playerNearUpstairs = !playerNearUpstairs

func playerMoveIsDone():
	print(playerNearUpstairs)
	colEscalera.disabled = false
	colEscaleraArriba.disabled = false
	colEscaleraArea.disabled = false
	colEscaleraArribaArea.disabled = false
