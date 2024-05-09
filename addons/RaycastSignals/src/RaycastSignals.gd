@icon("icons/RaycastSignals.svg")
@tool
extends Node

## A node that adds signals to a Raycast.
##
## RaycastSignals is added as a child to a Raycast3D or Raycast2D node.
## and allows using signals that indicate when a body enters collision, when it remains colliding, and when it exits collision.
## The signals are body_just_entered, body_inside, and body_exited.

## Stores a reference to the previously collided node.
var previous = null

## Flag to know if a body is currently colliding.
var is_inside = false

## Used to verify that the parent node is a Raycast node.
var ray

## Called when a body starts colliding with the ray.
signal body_just_entered(body)

## Called while a body is colliding.
signal body_inside(body)

## Called when a body has just exited the collision.
signal body_exited(body)


func _ready():
	previous = null


func _notification(what):
	match what:
		NOTIFICATION_PARENTED:
			ray = get_parent()
			update_configuration_warnings()


func _physics_process(_delta):
	if not Engine.is_editor_hint():
		if get_parent().is_colliding():
			var collider = get_parent().get_collider()
			if collider and collider != previous:
				if previous:
					body_exited.emit(previous)
					is_inside = false
				body_just_entered.emit(collider)
				is_inside = true
				previous = collider
			else:
				body_inside.emit(collider)
		else:
			if previous:
				body_exited.emit(previous)
				is_inside = false
				previous = null


func _get_configuration_warnings():
	var warnings = []
	if not (ray is RayCast3D or ray is RayCast2D):
		warnings.push_back("the node RaycastSignals needs to be a child of a Raycast3D or Raycast2D node for it to work correctly.")
	return warnings
