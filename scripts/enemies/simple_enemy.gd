extends CharacterBody2D

@export var speed: float = 160.0
@export var accel: float = 900.0
@export var max_health: int = 5

@export var damage: int = 1
@export var damage_cooldown: float = 1.0
@export var touch_range: float = 12.0
@export var knockback_strength: float = 360.0

var health: int
var player: Node2D = null
var can_damage := true

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Node2D
	add_to_group("enemy")

func _physics_process(delta):
	if player == null:
		return

	# chase
	var to_player = player.global_position - global_position
	var desired = to_player.normalized() * speed
	velocity = velocity.move_toward(desired, accel * delta)
	move_and_slide()

	# touch damage
	if global_position.distance_to(player.global_position) <= touch_range:
		_try_damage_player()

func _try_damage_player():
	if not can_damage:
		return

	if player.has_method("take_damage"):
		player.take_damage(damage)

	can_damage = false
	await get_tree().create_timer(damage_cooldown).timeout
	can_damage = true

func take_damage(amount: int, from_pos: Vector2 = Vector2.ZERO):
	health -= amount

	if from_pos != Vector2.ZERO:
		var dir = (global_position - from_pos).normalized()
		velocity = dir * knockback_strength

	_flash_hit()
	if health <= 0:
		queue_free()

func _flash_hit():
	sprite.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.08).timeout
	sprite.modulate = Color(1, 1, 1)
