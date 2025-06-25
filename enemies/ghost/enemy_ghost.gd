extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed = 1500
@export var patrol_points : Node
@export var health_amount :  int = 3
@export var damage_amount : int =1 

var GRAVITY = 1000
const SPEED = 1500

enum State {idle, walk}
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var points_position : Array[Vector2]
var current_point : Vector2
var current_points_position : int

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			points_position.append(point.global_position)
		current_point = points_position[current_points_position]
	else:
		print("No patrol points")
	
	current_state = State.idle

func _physics_process(delta: float):
	enemy_falling(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()

func enemy_falling(delta: float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
func enemy_idle(delta: float):
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	current_state = State.idle
	
func enemy_walk(delta: float):
	
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.walk
	else:
		current_points_position += 1
	
	if current_points_position >= number_of_points:
		current_points_position = 0 
	
	current_point = points_position[current_points_position]
	
	if current_point.x > position.x:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	
	animated_sprite_2d.flip_h = direction.x < 0
	


func _on_hurtbox_area_entered(area: Area2D):
	print("Hurtbox area entered")
