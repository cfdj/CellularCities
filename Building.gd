class_name Building extends Node

@export var spriteLocation:Vector2i;
@export var id:int;
@export var texture:Texture2D
##row = id, column = likes or dislikes (symmetric)
static var hatesArray= [
	[false,false,false,false,false,false,false,false,false,false,false,false], #Street
	[false,false,true,false,false,true,true,false,false,false,false,true], #Flat
	[false,true,false,false,true,false,false,false,false,false,false,false], #Foundry
	[false,false,false,true,false,false,false,false,false,false,false,true], #Cinema
	[false,false,true,false,false,false,false,false,false,false,false,true], #University
	[false,true,false,false,false,false,false,false,false,false,false,false], #Station
	[false,true,false,false,false,false,false,false,false,false,false,false], #Rails
	[false,false,false,false,false,false,false,false,false,false,false,false], #Forest
	[false,false,false,false,false,false,false,false,false,false,true,false], #Gas works
	[false,false,false,false,false,false,false,false,false,false,false,false], #Hill
	[false,false,false,false,false,false,false,false,true,false,false,true], #Office
	[false,true,false,true,true,false,false,false,false,false,true,false],] #Mine
static var likesArray = [
	[false,false,false,false,false,false,false,false,false,false,false,false], #Street
	[false,false,false,true,false,true,true,true,false,true,true,false], #Flat
	[false,false,false,false,false,false,false,false,false,false,false,false], #Foundry
	[false,true,false,false,true,false,false,false,false,false,false,false], #Cinema
	[false,false,false,true,false,false,false,false,false,true,false,false], #University
	[false,true,false,false,false,false,false,false,false,false,false,false], #Station
	[false,true,false,false,false,false,false,false,false,false,false,false], #Rails
	[false,true,false,false,false,false,false,false,false,false,false,false], #Forest
	[false,false,false,false,false,false,false,false,false,false,false,false], #Gas works
	[false,true,false,false,true,false,false,false,false,false,false,true], #Hill
	[false,true,false,false,false,false,false,false,false,false,false,false],#Office
	[false,false,false,false,false,false,false,false,false,true,false,false],] #Mine

func getlike(checkingId:int) -> bool:
	var likes = likesArray[id][checkingId];
	return likes;

func getHates(checkId:int) -> bool:
	var hates = hatesArray[id][checkId];
	return hates;
