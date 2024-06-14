class_name BuildingMenu extends Control

@export var displays:Array[BuildingDisplay];

func setDisplays(buildings:Array[Building],allBuildings:Array[Building]):
	var displayingBuildings:Array[Building];
	for d in displays:
		d.visible = false;
	
	for b in buildings:
		if !displayingBuildings.has(b):
			displayingBuildings.append(b);
	for c in displayingBuildings.size():
		displays[c].setBuilding(displayingBuildings[c],allBuildings,buildings);
		displays[c].visible = true;

signal displaysSet
