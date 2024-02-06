class_name Building extends Node

@export var spriteLocation:Vector2i;
@export var id:int;
@export var texture:Texture2D
##row = id, column = likes or dislikes (symmetric)
static var hatesArray= [
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Street
	[false,false,true,false,false,false,true,false,false,false,false,true,false], #Flat
	[false,true,false,false,true,false,false,false,false,false,false,false,false], #Foundry
	[false,false,false,true,false,false,false,false,false,false,false,true,false], #Cinema
	[false,false,true,false,false,false,false,false,false,false,false,true,false], #University
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Station
	[false,true,false,false,false,false,false,false,false,false,false,false,false], #Rails
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Forest
	[false,false,false,false,false,false,false,false,false,false,true,false,false], #Gas works
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Hill
	[false,false,false,false,false,false,false,false,true,false,false,true,false], #Office
	[false,true,false,true,true,false,false,false,false,false,true,false,false], #Mine
	[false,false,false,false,false,false,false,false,false,false,false,false,false]] #River
static var likesArray = [
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Street
	[false,false,false,true,false,true,false,true,false,true,true,false,true], #Flat
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Foundry
	[false,true,false,false,true,false,false,false,false,false,true,false,true], #Cinema
	[false,false,false,true,false,true,false,false,false,true,false,false,true], #University
	[false,true,false,false,true,false,false,false,false,false,false,false,true], #Station
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Rails
	[false,true,false,false,false,false,false,false,false,false,false,false,true], #Forest
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Gas works
	[false,true,false,false,true,false,false,false,false,false,false,true,true], #Hill
	[false,true,false,true,false,false,false,false,false,false,false,false,true],#Office
	[false,false,false,false,false,false,false,false,false,true,false,false,true],#Mine
	[true,true,true,true,true,true,true,true,true,true,true,true,false]] #River

func getlike(checkingId:int) -> bool:
	var likes = likesArray[id][checkingId];
	return likes;

func getHates(checkId:int) -> bool:
	var hates = hatesArray[id][checkId];
	return hates;
