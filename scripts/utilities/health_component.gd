class_name HealthComponent
extends Node

signal died
signal health_changed(value)

@export var max_health := 100
var health := max_health

func take_damage(amount):
	health -= amount
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("died")
