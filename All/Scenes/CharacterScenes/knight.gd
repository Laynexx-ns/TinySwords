extends CharacterBody2D

#sprite
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
##sword collisions
@onready var right_sword_collision: CollisionShape2D = %RightSwordCollision
@onready var left_sword_collision: CollisionShape2D = %LeftSwordCollision
@onready var down_sword_collision: CollisionShape2D = %DownSwordCollision
@onready var up_sword_collision: CollisionShape2D = %UpSwordCollision

@export var DeathEffect : PackedScene
@export var hearts : Array[Node]
@export var trees_text : Label
##default count of hearts - 3
var health : int = 3
var trees_count : int = 0

##useless piece of ...
#speed was 250
const SPEED = 250
const JUMP_VELOCITY = -400.0

##movement values
var walking = false
var input_x_direction
var input_y_direction
var canmove = true

##attack values
enum  dirState {UP, DOWN, LEFT, RIGHT}
var dir
var attacking = false
var attack_count = 0
var alive = true

#ready
func _on_ready() -> void:
	##disable all collisions
	disable_all_collisions()


#same as default process
func _physics_process(delta: float) -> void:
	
	
	if (walking == true and attacking == false):
		animated_sprite_2d.animation = "walking"
	elif (attacking == false):
		animated_sprite_2d.animation = "default"
		
	if (Input.is_action_just_pressed("attack") and attacking == false):
		attacking = true
		attack()
	if (canmove):
		movement()
	move_and_slide()
	 
	if (health == 0 and alive):
		go_dead()
		var death_effect = DeathEffect.instantiate()
		death_effect.position = position
		#death_effect.position.x = position.x + 215
		#death_effect.position.y = position.y + 700
		get_parent().add_child(death_effect)
		#print(position.x)
		#print(position.y)
		animated_sprite_2d.hide()
		await get_tree().create_timer(2.1).timeout
		death_effect.queue_free()
		get_tree().reload_current_scene()
		queue_free()
		
	
#attack logic
func attack():
	
	velocity.x = 0
	velocity.y = 0
	attacking = true
	canmove = false
	#
	##attacking logic##
	#
	attack_count += 1
	
	##up
	if (dir == 0):
		
		if (attack_count%2 == 0):
			animated_sprite_2d.animation = "up_attacking"
		else:
			animated_sprite_2d.animation = "up_additional_attacking"
		await get_tree().create_timer(0.4).timeout
		up_sword_collision.disabled = false
			
	##down
	if (dir == 1):
		
		if (attack_count%2 == 0):
			animated_sprite_2d.animation = "down_attacking"
		else:
			animated_sprite_2d.animation = "down_additional_attacking"
		await get_tree().create_timer(0.4).timeout
		down_sword_collision.disabled = false
		
	##left n right
	if (dir == 2):
		if (attack_count%2 == 0):
			animated_sprite_2d.animation = "right_attacking"
		else:
			animated_sprite_2d.animation = "right_additional_attacking"	
		await get_tree().create_timer(0.4).timeout
		left_sword_collision.disabled = false
	if (dir == 3):
		if (attack_count%2 == 0):
			animated_sprite_2d.animation = "right_attacking"
		else:
			animated_sprite_2d.animation = "right_additional_attacking"	
		
		await get_tree().create_timer(0.4).timeout
		right_sword_collision.disabled = false
	
	
	
	##time for animation
	await get_tree().create_timer(0.3).timeout
	attacking = false
	canmove = true
	
	disable_all_collisions()
	
	
		
#only movement
func movement():
	
	##getting direction (x and y)
	input_x_direction = Input.get_axis("left", "right")
	input_y_direction = Input.get_axis("up", "down")
	
	##one-way walking script
	if (input_x_direction == 0):
		velocity.x = 0
	else:
		if (input_y_direction == 0 and input_x_direction != 0):
			velocity.x = input_x_direction * SPEED
			if (input_x_direction < 0):
				animated_sprite_2d.flip_h = true
				dir = dirState.LEFT
				walking = true
			else:
				animated_sprite_2d.flip_h = false
				walking = true
				dir = dirState.RIGHT
	if (input_y_direction == 0):
		velocity.y = 0
		
	else:	
		if (input_x_direction == 0 and input_y_direction != 0):
				velocity.y = input_y_direction * SPEED
				walking = true
				if (input_y_direction < 0):
					dir = dirState.UP
				else:
					dir = dirState.DOWN
	if (input_x_direction == 0 and input_y_direction == 0):
		walking = false

#useful disabling
func disable_all_collisions():
	right_sword_collision.disabled = true
	left_sword_collision.disabled = true
	up_sword_collision.disabled = true
	down_sword_collision.disabled = true


func _on_kill_area_area_entered(area: Area2D) -> void:
	if (area.name == "EnemySwordArea"):
		print("fcking goblin!")
		loseHeart()
	print(health)

func loseHeart():
	health -=1
	for h in 3:
		if (health< h+1):
			hearts[h].hide()





func go_dead():
	alive = false
	canmove = false
	attacking = true


func _on_sword_area_area_entered(area: Area2D) -> void:
	if (area.name == "TreeKillArea"):
		await get_tree().create_timer(0.2).timeout
		trees_count += 1
		trees_text.text = str(trees_count)
		
