extends CanvasLayer

signal choice1
signal choice2
signal choice3
signal choice4
signal startGame
signal quitGame
signal returnToMenu

func Button1Pressed():
	choice1.emit()

func Button2Pressed():
	choice2.emit()

func Button3Pressed():
	choice3.emit()

func Button4Pressed():
	choice4.emit()

func ShowMessage(text):
	$Message.text = text
	$Message.show()

func StartButtonPressed():
	$StartButton.hide()
	$QuitButton.hide()
	$MenuButton.show()
	$Button1.show()
	$Button2.show()
	$Button3.show()
	$Button4.show()
	startGame.emit()

func QuitButtonPressed():
	$StartButton.hide()
	$QuitButton.hide()
	quitGame.emit()

func MenuButtonPressed():
	$StartButton.show()
	$QuitButton.show()
	$MenuButton.hide()
	$Button1.hide()
	$Button2.hide()
	$Button3.hide()
	$Button4.hide()
	returnToMenu.emit()
