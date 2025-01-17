extends CharacterBody2D


const speed = 200.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var newArrow : PackedScene
@export var hearts : Array[Node]
@export var deathef : PackedScene

enum enum_dir {LEFT, RIGHT, UP ,DOWN}
var first_dir = null
var second_dir = null

var isAlive : bool = true
var walking : bool = true
var canmove : bool = true
var attack : bool = false

var health : int = 2


func _physics_process(delta: float) -> void:
	
	if (walking and canmove):
		animated_sprite_2d.animation = "walking"
	elif (canmove):
		animated_sprite_2d.animation = "default"
	
	if (Input.is_action_just_pressed("attack") and attack == false):
		attacking()
	
	if (canmove):
		movement()
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
func attacking():
	canmove = false
	walking = false
	attack = true
	velocity = Vector2.ZERO
	
	##4direction attack
	if (first_dir == enum_dir.RIGHT or first_dir == enum_dir.LEFT and first_dir == second_dir):
		animated_sprite_2d.animation = "right_attacking"
		await get_tree().create_timer(0.8).timeout
		var arrow = newArrow.instantiate()
		if (animated_sprite_2d.flip_h == false):
			arrow.create(position, Vector2(1, 0), 0)
		else:
			arrow.create(position, Vector2(-1, 0), -180)
		get_parent().add_child(arrow)		
	
	elif (first_dir == enum_dir.DOWN and first_dir == second_dir):
		animated_sprite_2d.animation = "down_attacking"
		await get_tree().create_timer(0.8).timeout
		var arrow = newArrow.instantiate()
		arrow.create(position, Vector2(0, 1), 90)
		get_parent().add_child(arrow)
		
	elif (first_dir == enum_dir.UP and first_dir == second_dir):
		animated_sprite_2d.animation = "up_attacking"
		await get_tree().create_timer(0.8).timeout
		var arrow = newArrow.instantiate()
		arrow.create(position, Vector2(0, -1), 270)
		get_parent().add_child(arrow)
	##other
	elif (first_dir == enum_dir.DOWN and second_dir == enum_dir.RIGHT or first_dir == enum_dir.RIGHT and second_dir == enum_dir.DOWN or first_dir == enum_dir.DOWN and second_dir == enum_dir.LEFT or first_dir == enum_dir.LEFT and second_dir == enum_dir.DOWN):
		animated_sprite_2d.animation = "downright_attacking"
		await get_tree().create_timer(0.8).timeout
		var arrow = newArrow.instantiate()
		if (animated_sprite_2d.flip_h == false):
			arrow.create(position, Vector2(1, 1), 45)
		else:
			arrow.create(position, Vector2(-1, 1), 135)
		get_parent().add_child(arrow)
	elif (first_dir == enum_dir.UP and second_dir == enum_dir.RIGHT or first_dir == enum_dir.RIGHT and second_dir == enum_dir.UP or first_dir == enum_dir.UP and second_dir == enum_dir.LEFT or first_dir == enum_dir.LEFT and second_dir == enum_dir.UP):
		animated_sprite_2d.animation = "upright_attacking"
		await get_tree().create_timer(0.8).timeout
		var arrow = newArrow.instantiate()
		if (animated_sprite_2d.flip_h == false):
			arrow.create(position, Vector2(1, -1), 305)
		else:
			arrow.create(position, Vector2(-1, -1), 225)
		get_parent().add_child(arrow)
	
	
	
	await get_tree().create_timer(0.2).timeout
	canmove = true
	attack = false
		
	
	
func movement():
	var direction = Input.get_vector("second_player_left", "second_player_right", "second_player_up", "second_player_down")
	velocity = speed * direction
	
	if(Input.is_action_pressed("second_player_right")):
		second_dir = first_dir
		first_dir = enum_dir.RIGHT
	if(Input.is_action_pressed("second_player_left")):
		second_dir = first_dir
		first_dir = enum_dir.LEFT
	if(Input.is_action_pressed("second_player_up")):
		second_dir = first_dir
		first_dir = enum_dir.UP
	if(Input.is_action_pressed("second_player_down")):
		second_dir = first_dir
		first_dir = enum_dir.DOWN

	print(first_dir)
	print(second_dir)
	
	if (velocity.x < 0 ):
		animated_sprite_2d.flip_h = true
	elif (velocity.x > 0):
		animated_sprite_2d.flip_h = false

	if (velocity.x == 0 and velocity.y == 0):
		walking = false
	elif (canmove):
		walking = true
		
	move_and_slide()


func _on_kill_area_area_entered(area: Area2D) -> void:
	if (area.name == "EnemySwordArea"):
		print("aspeofowpef")
		loseHeart()


func loseHeart():
	if (isAlive):
		health -=1
		for h in 2:
			if (health< h+1):
				hearts[h].hide()
			
	if (health == 0 and isAlive):
		go_dead()
		var death_effect = deathef.instantiate()
		death_effect.position = position
		get_parent().add_child(death_effect)
		print(position.x)
		print(position.y)
		animated_sprite_2d.hide()
		await get_tree().create_timer(2.1).timeout
		death_effect.queue_free()
		get_tree().reload_current_scene()
		queue_free()

func go_dead():
	isAlive = false
	canmove = false
	attack = true
