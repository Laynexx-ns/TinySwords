extends Node


var default_arrow = load("res://All/Assets/Effects/01.png")
@onready var knight_camera: Camera2D = $"../SceneObjs/Characters/Knight/KnightCamera"
@onready var archer_camera: Camera2D = $"../Archer/ArcherCamera"


var knight : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_custom_mouse_cursor(default_arrow)
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("change_camera")):
		if (knight):
			knight_camera.enabled = false
			archer_camera.enabled = true
			knight = false
		else:
			knight_camera.enabled = true
			archer_camera.enabled = false
			knight = true
