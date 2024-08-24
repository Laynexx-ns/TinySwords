extends RigidBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var default_collision: CollisionShape2D = $default_collision
@onready var if_dead_collision: CollisionShape2D = $ifDeadCollision

@onready var tree_kill_area: Area2D = $TreeKillArea

var isAlive : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_kill_area_area_entered(area: Area2D) -> void:
	if (area.name == "SwordArea" and isAlive):
		isAlive = false
		animated_sprite_2d.animation = "get_hitted"
		await get_tree().create_timer(0.2).timeout
		animated_sprite_2d.animation = "change_to_stump"
		default_collision.disabled = true
		if_dead_collision.disabled = false
		tree_kill_area.monitorable = false
