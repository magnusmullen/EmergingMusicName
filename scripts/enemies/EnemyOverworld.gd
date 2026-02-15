extends CharacterBody2D

@export var speed := 100
@export var max_health := 3

var health : int
var player : Node2D = null

func _ready():
	health = max_health
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(amount):
	health -= amount

	if health <= 0:
		queue_free()
