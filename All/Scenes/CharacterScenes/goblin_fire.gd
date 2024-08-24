extends CharacterBody2D

@onready var viewing_area: Area2D = %Viewing_area
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_sword_area: Area2D = $EnemySwordArea

const SPEED = 100
#const SPEED = 0
const JUMP_VELOCITY = -400.0

enum dirLR {LEFT, RIGHT}
var dir = dirLR.RIGHT

var canmove : bool = true
var walk : bool = false
var knight = null

var hearts = 2

@onready var right_sword_collision: CollisionShape2D = $EnemySwordArea/right_sword_collision
@onready var down_sword_collision: CollisionShape2D = $EnemySwordArea/down_sword_collision
@onready var left_sword_collision: CollisionShape2D = $EnemySwordArea/left_sword_collision
@onready var up_sword_collision: CollisionShape2D = $EnemySwordArea/up_sword_collision

@onready var ReakKnight: CharacterBody2D = $"."

@export var death_effect : PackedScene


var attacking : bool = false

var isDead = false

func _on_ready() -> void:
	
	disable_all_swords_collisions()


func _physics_process(delta: float) -> void:
	
	if (hearts <= 0 and isDead == false):
		isDead = true
		dead()
		enemy_sword_area.monitorable = false
		disable_all_swords_collisions()
		var deathE = death_effect.instantiate()
		deathE.position = position
		get_parent().add_child(deathE)
		disable_all_swords_collisions()
		await get_tree().create_timer(1.7).timeout
		get_parent().remove_child(deathE)
		queue_free()
	
	
	if (walk and canmove):
		animated_sprite_2d.animation = "walking"
	elif canmove:
		animated_sprite_2d.animation = "default"
	
	velocity = Vector2.ZERO
	if (canmove):
		if knight:
			velocity = position.direction_to(knight.position) * SPEED
			walk = true
		if (velocity.x < 0):
			dir = dirLR.LEFT
			animated_sprite_2d.flip_h = true
		elif (velocity.x > 0):
			dir = dirLR.RIGHT
			animated_sprite_2d.flip_h = false
		
		
	if (attacking and canmove):
		attack()
		
	move_and_slide()
	
	

func attack():
	
	await get_tree().create_timer(0.2).timeout
	
	canmove = false
	velocity.x = 0
	velocity.y = 0
	#print(knight.position.x - position.x)
	#print(knight.position.y - position.y)
	
	if (knight.position.x - position.x < -10):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.animation = "right_attacking"
		await get_tree().create_timer(0.6).timeout
		left_sword_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
	elif ((knight.position.x - position.x) > 10):
		animated_sprite_2d.animation = "right_attacking"
		await get_tree().create_timer(0.6).timeout
		right_sword_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
	else:
		if 	knight.position.y - position.y > 10:
			animated_sprite_2d.animation = "down_attacking"
			await get_tree().create_timer(0.6).timeout
			down_sword_collision.disabled = false
			await get_tree().create_timer(0.1).timeout
		else:
			animated_sprite_2d.animation = "up_attacking"
			await get_tree().create_timer(0.6).timeout
			up_sword_collision.disabled = false
			await get_tree().create_timer(0.1).timeout
			
	##why it doesn't work(((
	
	disable_all_swords_collisions()
	canmove = true



##bool attacking logic
func _on_stop_area_area_entered(area: Area2D) -> void:
	if (area.name == "KillArea"):
		attacking = true

func _on_stop_area_area_exited(area: Area2D) -> void:
	if (area.name == "KillArea"):
		attacking = false
##attacking logic ends



func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.name == "SwordArea"):
		print("taked damage: goblinus")
		hearts -=1
	if (area.name == "ArrowArea"):
		print("aa")
		hearts -= 2
	
	
func dead():
	velocity.x = 0
	velocity.y = 0
	canmove = 0
	walk = false
	attacking = false
	enemy_sword_area.monitorable = false
	animated_sprite_2d.hide()

func _on_viewing_area_body_entered(body: Node2D) -> void:
	if (body.name == "Knight"):
		print("knigt here!!")
		knight = body
		
		
func disable_all_swords_collisions():
	right_sword_collision.disabled = true
	left_sword_collision.disabled = true
	down_sword_collision.disabled = true
	up_sword_collision.disabled = true

func _on_viewing_area_body_exited(body: Node2D) -> void:
	if (body.name == "Knight"):
		knight = null
		walk = false
