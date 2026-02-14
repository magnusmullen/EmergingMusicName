extends Area2D

func _ready():
	print("[EnemyOverworld] Ready. Monitoring=", monitoring, " Mask=", collision_mask)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("[EnemyOverworld] body_entered by: ", body.name)
	if body.name == "Player": # <- match your actual node name (capitalize if yours is 'Player')
		print("[EnemyOverworld] Player detected. Changing scene...")
		get_tree().change_scene_to_file("res://scenes/battle/BattleTest.tscn")
