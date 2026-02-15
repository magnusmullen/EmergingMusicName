extends CharacterBody2D

@export var speed: float = 90.0
@export var max_health: int = 3
@export var stop_distance: float = 1.0

var health: int
var player: Node2D

func _ready():
	health = max_health

	var players = get_tree().get_nodes_in_group("player")
	print("Players in group:", players.size())
	for p in players:
		print(" - ", p.name, " path=", p.get_path(), " pos=", (p as Node2D).global_position)

	player = players[0] as Node2D
	print("[Enemy] using player:", player.name, " @ ", player.global_position)



func _physics_process(delta):
	if player == null:
		return

	var to_player = player.global_position - global_position
	var direction = to_player.normalized()
	var dist = to_player.length()

	# If we're basically on top of the player, stop to prevent overshoot jitter
	if dist < 4.0:
		velocity = Vector2.ZERO
		return

	# Optional: slow down as we get close (smooth "arrive")
	var desired_speed = speed
	if dist < 40.0:
		desired_speed = lerp(0.0, speed, dist / 40.0)

	velocity = to_player.normalized() * desired_speed
	move_and_slide()
