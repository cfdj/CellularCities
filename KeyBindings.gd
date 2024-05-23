class_name KeyBindings extends Resource

@export var actionTracker:Dictionary;
@export var eventActionMaps:Dictionary;

func markChanged(action:StringName):
	actionTracker[action] = true;

func markUnchanged(action:StringName):
	actionTracker[action] = false;

func getChanged(action:StringName) ->bool:
	if(actionTracker.has(action)):
		return actionTracker[action]
	return false;	
func saveRebind(action:StringName):
	eventActionMaps[action] = InputMap.action_get_events(action)

func getBindings(action:StringName) ->Array[InputEvent]:
	return eventActionMaps[action]
