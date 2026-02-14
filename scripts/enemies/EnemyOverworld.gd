# res://scripts/overworld/EnemyOverworld.gd
extends Area2D

## Which battle enemy to spawn when this one is touched.
@export var enemy_battle_scene: PackedScene

func _ready():
	# Make sure signals are connected at runtime
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Only trigger on player
	if not body.is_in_group("player"):
		return

	# Optional: prevent double-trigger if multiple bodies overlap
	set_deferred("monitoring", false)

	# Store which enemy to spawn (via autoload) and switch to battle
	if Engine.has_singleton("GameState"):
		var GameState = Engine.get_singleton("GameState")
		GameState.next_enemy_scene = enemy_battle_scene
	else:
		# If you're using autoload as a script, you can instead do:
		# GameState.next_enemy_scene = enemy_battle_scene
		pass

	# Change scene to the battle manager
	get_tree().change_scene_to_file("res://scenes/battle/BattleManager.tscn")
