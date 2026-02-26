extends Label

@export var player_path: NodePath
var player

func _ready():
	player = get_node(player_path)
	player.health_changed.connect(_on_health_changed)
	_on_health_changed(player.health, player.max_health)

func _on_health_changed(current: int, max_hp: int):
	text = "HP: %d / %d" % [current, max_hp]
