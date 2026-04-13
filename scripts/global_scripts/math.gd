extends Node
func find_median(array: Array) -> float:
	var target_array = array.duplicate(true)
	var size: float = target_array.size()
	target_array.sort()
	var median_value
	if int(size) % 2 == 0:
		var first_mid_index :int = int(size * 0.5)
		median_value = float(target_array[first_mid_index] + target_array[first_mid_index - 1]) * 0.5
		return median_value
	else:
		median_value =  target_array[int((size - 1) * 0.5)]
		return median_value
