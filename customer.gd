extends AnimatableBody2D

var canDrag = false
var sprite: Sprite2D
var at_toilet = false
var toilet: Node2D
var locked = false
var timer: Timer
var progressbar: ProgressBar

func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			sprite = child
		if child is Timer:
			timer = child
		if child is ProgressBar:
			progressbar = child

func _process(delta):
	if canDrag:
		$".".global_position = lerp($".".global_position, get_global_mouse_position(), 30 * delta)
	if locked:
		progressbar.set_value_no_signal(timer.time_left)


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		if event.button_mask == 1 and event.pressure == 1.00 and locked == false:
			canDrag = true
		elif event.button_mask == 1 and event.is_released() and not at_toilet:
			print("released off toilet")
		elif event.button_mask == 1 and event.is_released() and at_toilet:
			print("released at toilet")
			locked = true
		else:
			canDrag = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered toilet")
	at_toilet = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("left toilet")
	at_toilet = false

func _on_mouse_entered() -> void:
	sprite.rotation_degrees = 15

func _on_mouse_exited() -> void:
	sprite.rotation_degrees = 0

func _on_timer_timeout() -> void:
	print("timer finished")
	locked = false
