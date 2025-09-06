extends Control

# divisor y contenedor principal
@onready var VSSplit: VSplitContainer = $VSplitContainer
# divisor entre monitor y botones
@onready var mainSplit: HSplitContainer = $VSplitContainer/HSplitContainer
# divisor entre monitor y perfiles
@onready var monitorPerfil: VSplitContainer = $VSplitContainer/HSplitContainer/VBoxContainer/VSplitContainer

@onready var fadeTime: Timer = $"../fadeTime"

# botones de comando
@export var arrayButtons: Array[Button]

@onready var buttonSalir: Button = $VSplitContainer/HSplitContainer/VBoxContainer2/VSplitContainer/MarginContainer/VSplitContainer/HBoxContainer/salir

var current_value = 0.0
var menuOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# conectar la funcion del vieport a la funcion sizeViewPort del script
	get_viewport().connect("size_changed", sizeViewPort)
	
	# asignar tamaño al contenedor principal
	VSSplit.size = get_viewport().size
	
	# ajustar las divisiones acorde a la resolucion
	fixSplits()
	
	fadeIn_fadeOut(current_value)

# tomar un número y devolver el equivalente en porcentaje
func getPixelsToPercent(sizeP: float, percent: int) -> float:
	return (sizeP * percent) / 100
	
func sizeViewPort():
	VSSplit.size = get_viewport().size
	fixSplits()

# efecto de difuminado
func fadeIn_fadeOut(value: float):
	modulate.v = value

# ajustar las divisiones acorde a la resolucion
func fixSplits():
	VSSplit.split_offset = getPixelsToPercent(VSSplit.size.y, 30)
	mainSplit.split_offset = getPixelsToPercent(VSSplit.size.x, 23)
	monitorPerfil.split_offset = getPixelsToPercent(VSSplit.size.y, 18)


func _on_fade_time_timeout():
	if current_value >= 1.0:
		fadeTime.stop()
		current_value = 0.0
		return
	current_value += 0.08
	buttonSalir.grab_focus()
	fadeIn_fadeOut(current_value)
