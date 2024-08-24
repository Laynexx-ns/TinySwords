extends AnimatableBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var speed
var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#constant_linear_velocity.x = 300
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_collide(velocity, false,  0.08, true)


func _on_arrow_area_body_entered(body: Node2D) -> void:
	if (body.name == "EnemyKillArea"):
		await get_tree().create_timer(0.25).timeout
		queue_free()

func create(position_ : Vector2, velocity_ : Vector2, rotate : int):
	position = position_
	velocity = velocity_ * 10
	rotate(rotate)
		
