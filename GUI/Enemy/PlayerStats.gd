extends Control


func update_battery(batteryCharge, batteryChargeMax = batteryCharge):
	$battery/meter.max_value = float(batteryChargeMax)
	$battery/meter.value = float(batteryCharge)
	
	$battery/value.text = str(batteryCharge)


func update_health(currentHealth, maxHealth):
	var meter = $health/meter/fill
	meter.max_value = float(maxHealth)
	meter.value = float(currentHealth)
	
	$health/value.text = str(currentHealth)