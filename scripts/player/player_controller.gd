extends CharacterBody2D

@export var speed: float = 200.0
@export var max_health: int = 10
@export var invuln_time: float = 0.6
@export var knockback_strength: float = 220.0

var health: int
var invulnerable := false

signal health_changed(current: int, max: int)
signal died

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	health = max_health
	emit_signal("health_changed", health, max_health)
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_area_body_entered)

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int):
	if invulnerable:
		return
	health = max(health - amount, 0)
	emit_signal("health_changed", health, max_health)
	
	# HIT FEEDBACK
	_flash_hit()

	# I-FRAMES
	invulnerable = true
	await get_tree().create_timer(invuln_time).timeout
	invulnerable = false

	if health == 0:
		emit_signal("died")
		print("Player died")

func _flash_hit():
	# quick red flash (no shader needed)
	sprite.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.08).timeout
	sprite.modulate = Color(1, 1, 1)
	

####### Attack Section ########
@onready var attack_area: Area2D = $AttackArea

@export var attack_damage: int = 1
@export var attack_active_time: float = 1.0

var attacking := false
var already_hit := {}  # prevents multi-hits in one swing

func _input(event):
	if event.is_action_pressed("ui_accept"): # Space/Enter default
		attack()

func attack():
	if attacking:
		return

	attacking = true
	already_hit.clear()

	attack_area.monitoring = true
	await get_tree().create_timer(attack_active_time).timeout
	attack_area.monitoring = false

	attacking = false

func _on_attack_area_body_entered(body: Node):
	if not attacking:
		return

	if body.is_in_group("enemy") and body.has_method("take_damage"):
		# only hit once per swing
		if already_hit.has(body):
			return
		already_hit[body] = true

		body.take_damage(attack_damage, global_position)
		print("Hit enemy for ", attack_damage)
