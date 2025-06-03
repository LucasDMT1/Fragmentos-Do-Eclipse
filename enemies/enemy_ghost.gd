extends CharacterBody2D

var GRAVITY = 1000
const SPEED = 1500

enum State {idle, walk}
var current_state : State
var direction : Vector2 = Vector2.LEFT

func _ready():
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
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	current_state = State.idle
	
func enemy_walk(delta: float):
	velocity.x = direction.x * SPEED * delta
	current_state = State.walk
	
