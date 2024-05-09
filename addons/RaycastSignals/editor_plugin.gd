@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"RaycastSignals",
		"Node",
		preload("src/RaycastSignals.gd"),
		preload("icons/RaycastSignals.svg")
	)


func _exit_tree():
	remove_custom_type("RaycastSignals")
