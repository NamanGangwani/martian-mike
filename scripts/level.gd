extends Node2D

@onready var start_position = $StartPosition

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		# trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player) #godot 4 way

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_deathzone_body_entered(body: Node2D) -> void:
	reset_player()

func _on_trap_touched_player() -> void:
	reset_player()

func reset_player() ->void:
	player.velocity = Vector2.ZERO
	player.global_position = start_position.global_position
