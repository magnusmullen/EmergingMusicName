extends Node

var current_level

func load_level(path):
	if current_level:
		current_level.queue_free()

	var scene = load(path).instantiate()
	get_tree().root.add_child(scene)
	current_level = scene
