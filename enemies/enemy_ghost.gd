extends CharacterBody2D

var GRAVITY = 1000

enum State {idle, walk}
var current_state : State

func _ready():
	current_state = State.idle

func _physics_process(delta: float):
	enemy_falling(delta)
	
	move_and_slide()

func enemy_falling(delta: float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
