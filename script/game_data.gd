extends Node

var uniq_id = 0

func get_id() -> int:
	var id = uniq_id
	uniq_id += 1
	return id
