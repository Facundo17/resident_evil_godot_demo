extends Button

var scene = preload("res://mansion_demo.tscn")
var music: AudioStreamPlayer
var playGame = false
var transition: AnimationPlayer

func _ready():
	music = $"../../../Music"
	transition = $"../../../scene_transition/fundido"
	
	await transition.animation_finished
	
	transition.play("fade_out")
	grab_focus()

func _on_pressed():
	# flash
	transition.play("flash")
	music.play()
	
	await transition.animation_finished

	transition.play("fade_in")
	
	# cambiar de escena cuando la animacion transition finaliza
	await transition.animation_finished
	playGame = true
	get_tree().change_scene_to_packed(scene)
