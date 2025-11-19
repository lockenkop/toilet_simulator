extends CharacterBody2D

var toilet: Area2D
var locked = false
var progressbar: ProgressBar
var over_toilet: bool = false
var queue_start_marker: Marker2D
var money: Label 
var base_reward: int = 10
var movement_speed: float = 400.0
var movement_target_position: Vector2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

enum States {READY, IN_QUEUE, DRAGGED, DROPPED, AT_TOILET, FINISHED}

var state: States


func _ready() -> void:
	$Area2D.area_entered.connect(_on_body_entered)
	$Area2D.area_exited.connect(_on_body_exited)
	_set_state(States.IN_QUEUE)
	$ProgressBar.max_value = $Timer.wait_time
	money = get_tree().get_nodes_in_group("money")[0]
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)
	
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() or not state == States.IN_QUEUE :
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func _process(delta):
	if state == States.DRAGGED:
		$".".global_position = lerp($".".global_position, get_global_mouse_position(), 70 * delta)
	if state == States.DROPPED:
		if over_toilet:
			_set_state(States.AT_TOILET)
		else:
			reset_to_queue()
	if state == States.AT_TOILET:
		if $Timer.is_stopped():
			$Timer.start()
		$ProgressBar.value = $Timer.time_left
	if state == States.FINISHED:
		
		if $".".global_position <= Vector2(0,336):
			$".".translate(Vector2(0,100))
		$".".translate(Vector2(10,0))
		

func calculate_reward():
	return base_reward * toilet.quality

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_action_pressed("drag_customer") and state == States.IN_QUEUE:
			_set_state(States.DRAGGED)
		elif event.is_action_released("drag_customer"):
			_set_state(States.DROPPED)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("toilets"):
		$ToiletLabel.text = "at toilet"
		over_toilet = true
		toilet = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("toilets"):
		$ToiletLabel.text = "off toilet"
		over_toilet = false
		toilet = null

func _on_mouse_entered() -> void:
	$Sprite2D.rotation_degrees = 15

func _on_mouse_exited() -> void:
	$Sprite2D.rotation_degrees = 0

func _on_timer_timeout() -> void:
	money.add(calculate_reward())
	_set_state(States.FINISHED)

func _set_state(state_to_set: States):
	var statename = States.find_key(state_to_set)
	$StateLabel.text = statename
	state = state_to_set

func reset_to_queue():
	_set_state(States.IN_QUEUE)


func _on_playable_area_body_exited(body: Node2D) -> void:
	_set_state(reset_to_queue())


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
