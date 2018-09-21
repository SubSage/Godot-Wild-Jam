extends Control


func update_health(currentHealth, healthMaximum):
	var fill = $health/meter/fill
	
	fill.max_value = healthMaximum
	fill.value = currentHealth
	
	$health/value.text = str(currentHealth)


func update_name(monsterName):
	$health/name.text = monsterName