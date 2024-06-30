class_name MathUtils
extends RefCounted

static func normalise_range(value : float, min_value : float, max_value : float) -> float:
	return (value - min_value) / (max_value - min_value)
	

static func denormalise_range(value : float, min_value : float, max_value : float) -> float:
	return value * (max_value - min_value) + min_value
	
