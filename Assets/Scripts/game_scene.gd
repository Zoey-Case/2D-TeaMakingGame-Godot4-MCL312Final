extends Node2D

var startMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
var menuText = "MENU SCREEN"

func StartGame():
	$UI.ShowMessage(startMessage)

func ReturnToMenu():
	$UI.ShowMessage(menuText)

func QuitGame():
	get_tree().quit()

func Choice1Selected():
	print("Choice 1")
	$UI.ShowMessage("Choice 1 Selected")

func Choice2Selected():
	print("Choice 2")
	$UI.ShowMessage("Choice 2 Selected")

func Choice3Selected():
	print("Choice 3")
	$UI.ShowMessage("Choice 3 Selected")

func Choice4Selected():
	print("Choice 4")
	$UI.ShowMessage("Choice 4 Selected")
