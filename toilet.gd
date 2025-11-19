extends Area2D
signal customer_over_toilet

@export var quality: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tooltip.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_mouse_entered() -> void:
	$Tooltip/TooltipTimer.start()
	
func _on_tooltip_timer_timeout() -> void:
	$Tooltip.visible = true
	
func _on_mouse_exited() -> void:
	$Tooltip/TooltipTimer.stop()
	$Tooltip.visible = false
	
func set_quality(value: float):
	quality = value
	$Tooltip/QualityLabel.text = "Quality: %s" %quality 
