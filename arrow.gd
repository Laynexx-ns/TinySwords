extends AnimatableBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var speed
var velocity : Vector2
var rot : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#constant_linear_velocity.x = 300
	#animated_sprite_2d.rotate(1.57)
	animated_sprite_2d.rotation_degrees = rot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_collide(velocity, false,  0.08, true)


func _on_arrow_area_area_entered(area: Area2D) -> void:
	
	if (area.name == "EnemyKillArea"):
		queue_free()



func create(position_ : Vector2, velocity_ : Vector2, rotate : float):
	position = position_
	velocity = velocity_ * 20
	rot = rotate
		
