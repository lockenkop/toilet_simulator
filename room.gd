extends Node2D

@export var customer_scene: PackedScene
@export var toilet_scene: PackedScene
@export var max_toilets: int = 4
@export var max_customers: int = 30

var money: int
var customer: CharacterBody2D
var toilet: Area2D
var customers: Array
var toilets: Array


var toilet_offset: Vector2 = Vector2(150,0)
var customer_offset: Vector2 = Vector2(50,0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func count_customers() -> int:
	return len(get_tree().get_nodes_in_group("customers"))
	
func count_toilets() -> int:
	return len(get_tree().get_nodes_in_group("toilets"))

func _on_spawn_customer_button_pressed() -> void:
	var customer_count = count_customers()
	if customer_count < max_customers:
		print("instantiating customer")
		customer = customer_scene.instantiate()
		customer.position = $QueueStart.position + customer_count * customer_offset
		customer.movement_target_position = $QueueEnd.position
		add_child(customer)
		


func _on_spawn_toilet_button_pressed() -> void:
	var toilet_count = count_toilets()
	if toilet_count < max_toilets:
		print("instantiating toilet")
		toilet = toilet_scene.instantiate()
		toilet.position = $ToiletStart.position + toilet_count * toilet_offset
		add_child(toilet)

	
	
	
