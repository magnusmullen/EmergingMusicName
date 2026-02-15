extends CharacterBody2D

@export var speed: float = 100.0
@export var accel: float = 900.0
@export var stop_distance: float = 10.0

var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta):
	if player == null:
		return

	var to_player = player.global_position - global_position
	var dist = to_player.length()

	var desired_vel := Vector2.ZERO
	if dist > stop_distance:
		desired_vel = to_player.normalized() * speed

	velocity = velocity.move_toward(desired_vel, accel * delta)
	move_and_slide()
