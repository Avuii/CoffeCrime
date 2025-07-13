extends Area2D

@export var correct_coffee: bool = false 

func _on_body_entered(body: Node) -> void:
	if body is Player:
		if Global.customer_queue.is_empty():
			print("pusta kolejka")
			return

		var npc = Global.customer_queue[0]
		if npc:
			var order_text = Global.npc_orders.get(npc.npc_name, "coffee")
			var dialogue_data = {
				"npc_name": npc.npc_name,
				"drink_name": order_text
			}
			DialogueManager.show_example_dialogue_balloon(
				load("res://dialogi/orders.dialogue"),
				"start",
				[dialogue_data]
			)
