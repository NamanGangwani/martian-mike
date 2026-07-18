extends Node2D

@export var next_level: PackedScene = null

@onready var start = $Start
@onready var exit = $Exit
@onready var deathzone = $Deathzone

var player = null

@export var level_time = 5

var timer_node = null
var time_left

var win = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		# trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player) #godot 4 way

	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_level_timer_timeout() -> void:
	if !win:
		time_left -= 1
		if time_left < 0:
			reset_player()
			time_left = level_time

func _on_deathzone_body_entered(body: Node2D) -> void:
	reset_player()

func _on_trap_touched_player() -> void:
	reset_player()
	
func _on_exit_body_entered(body: Node2D) -> void:
	if body is Player and next_level != null:
		exit.animate()
		player.active = false
		win = true
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_packed(next_level)

func reset_player() ->void:
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
	
