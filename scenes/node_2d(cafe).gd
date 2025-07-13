extends Node2D

@onready var cafe_timer = $CafeTimer
@onready var npc_container = $YSortCafe/NPCContainer
@onready var cafetoex: TextureButton = $Control/CafeToEx

@onready var points = $Points
@onready var spawn_point = $Points/SpawnPoint
@onready var queue = $Points/Queue
@onready var seat = $Points/Seat
@onready var queue_seat = $Points/QueueSeat
@onready var spawn_queue = $Points/SpawnQueue
@onready var cafecity = $CafeCity


# ========== READY ==========
func _ready():
	cafe_timer.timeout.connect(_on_global_timer_timeout)
	cafetoex.pressed.connect(on_espresso_button_pressed)



# ========== POZYCJE (OSTATECZNA WERSJA) ==========

func get_marker_position(path: String) -> Vector2:
	var node = get_node_or_null(path)
	return node.global_position if node and node is Node2D else Vector2.ZERO

func get_queue_position(index: int) -> Vector2:
	var q = queue.get_node_or_null("Q%d" % (index + 1))
	return q.global_position if q else Vector2.ZERO

func get_spawn_point_position() -> Vector2:
	return spawn_point.to_global(Vector2.ZERO)


func get_spawn_queue_position() -> Vector2:
	return spawn_queue.global_position

func get_queue_seat_position() -> Vector2:
	return queue_seat.global_position

func get_exit_position() -> Vector2:
	return get_spawn_point_position()

func get_seat_position(name: String) -> Vector2:
	var seat_marker_name = Global.npc_seat_markers.get(name, "")
	if seat_marker_name == "":
		return Vector2.ZERO
	var seat_node = seat.get_node_or_null(seat_marker_name)
	return seat_node.global_position if seat_node else Vector2.ZERO

# ========== ZMIENNE NPC ==========
var elapsed_time := 0
var npc_index := 0
var current_queue = []
var npc_list = []

var daily_npc_lists = {
	1: [
		{"name": "Marcus", "animation": "res://graphic/anim/marcus.tres", "spawn_time": 5},
		{"name": "Suzie", "animation": "res://graphic/anim/suzie.tres", "spawn_time": 15},
		{"name": "James", "animation": "res://graphic/anim/james.tres", "spawn_time": 25},
		{"name": "Freya", "animation": "res://graphic/anim/freya.tres", "spawn_time": 30}
	],
	2: [
		{"name": "Henry", "animation": "res://graphic/anim/henry.tres", "spawn_time": 5},
		{"name": "James", "animation": "res://graphic/anim/james.tres", "spawn_time": 15},
		{"name": "Caroline", "animation": "res://graphic/anim/caroline.tres", "spawn_time": 25},
		{"name": "Marcus", "animation": "res://graphic/anim/marcus.tres", "spawn_time": 30}
	],
	3: [
		{"name": "Clara", "animation": "res://graphic/anim/clara.tres", "spawn_time": 5},
		{"name": "Caroline", "animation": "res://graphic/anim/caroline.tres", "spawn_time": 10},
		{"name": "Marcus", "animation": "res://graphic/anim/marcus.tres", "spawn_time": 15},
		{"name": "James", "animation": "res://graphic/anim/james.tres", "spawn_time": 20}
		],
	4: [
		{"name": "Pierce", "animation": "res://graphic/anim/pierce.tres", "spawn_time": 5},
		{"name": "Freya", "animation": "res://graphic/anim/freya.tres", "spawn_time": 10},
		{"name": "James", "animation": "res://graphic/anim/james.tres", "spawn_time": 15},
		{"name": "Ezequiel", "animation": "res://graphic/anim/ezequiel.tres", "spawn_time": 20}
		],
	5: [
		{"name": "Dante", "animation": "res://graphic/anim/dante.tres", "spawn_time": 5},
		{"name": "Pierce", "animation": "res://graphic/anim/pierce.tres", "spawn_time": 10},
		{"name": "Marcus", "animation": "res://graphic/anim/marcus.tres", "spawn_time": 15},
		{"name": "Clara", "animation": "res://graphic/anim/clara.tres", "spawn_time": 20}
	]
}

# ========== LOGIKA DNIA ==========
func start_day(day: int):
	npc_list = daily_npc_lists.get(day, [])
	reset_timer()

func reset_timer():
	elapsed_time = 0
	npc_index = 0
	for npc in npc_container.get_children():
		npc.queue_free()
	cafe_timer.stop()
	cafe_timer.start()

func start_timer():
	if cafe_timer.is_stopped():
		cafe_timer.start()

func pause_timer():
	cafe_timer.stop()

# ========== PRZYCISK ==========
func on_espresso_button_pressed():
	get_node("/root/GameRoot").show_location("express")

# ========== TIMER / SPAWN NPC ==========
func _on_global_timer_timeout():
	elapsed_time += 1

	while npc_index < npc_list.size() and npc_list[npc_index]["spawn_time"] <= elapsed_time:
		spawn_customer(npc_list[npc_index])
		npc_index += 1

func spawn_customer(npc_data: Dictionary):
	var name = npc_data["name"]

	# Zwiększ licznik wizyt NPC
	if not Global.npc_dialogue_counters.has(name):
		Global.npc_dialogue_counters[name] = 1
	else:
		Global.npc_dialogue_counters[name] += 1

	# Tworzenie NPC-a jak wcześniej
	var new_npc = preload("res://scenes/customer.tscn").instantiate()
	new_npc.npc_name = name
	new_npc.animation_data = load(npc_data["animation"])
	new_npc.global_position = get_spawn_point_position()
	npc_container.add_child(new_npc)

	new_npc.trigger_entry()
	await get_tree().create_timer(0.5).timeout
	new_npc.move_to_queue()



func _on_cafe_city_pressed():
	get_node("/root/GameRoot").show_location("city", "YSortCity", "PlayerSpawn2")
