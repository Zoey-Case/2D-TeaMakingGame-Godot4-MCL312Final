extends CanvasLayer

signal choiceA
signal choiceB
signal choiceC
signal choiceD
signal choiceAd
signal choiceBd
signal choiceCd
signal choiceDd
signal proceed
signal startGame
signal quitGame
signal returnToMenu

# SIGNAL FUNCTIONS
func ButtonAPressed():
	choiceA.emit()

func ButtonBPressed():
	choiceB.emit()

func ButtonCPressed():
	choiceC.emit()

func ButtonDPressed():
	choiceD.emit()

func ButtonAdPressed():
	choiceAd.emit()

func ButtonBdPressed():
	choiceBd.emit()

func ButtonCdPressed():
	choiceCd.emit()

func ButtonDdPressed():
	choiceDd.emit()

func StartButtonPressed():
	startGame.emit()

func QuitButtonPressed():
	quitGame.emit()

func ExitButtonPressed():
	returnToMenu.emit()

func ContinueButtonPressed():
	proceed.emit()


# METHODS
func ShowMessage(text):
	$Message.text = text
	$Message.show()
	
func HideContinueScene():
	$ContinueButton.hide()
	
func HideDreamScene():
	$TeaBackdrop.hide()
	$ButtonAd.hide()
	$ButtonBd.hide()
	$ButtonCd.hide()
	$ButtonDd.hide()
	
func HideMainMenu():
	$ExitButton.show()
	$StartButton.hide()
	$QuitButton.hide()
	
func HideTeaScene():
	$TeaBackdrop.hide()
	$ButtonA.hide()
	$ButtonB.hide()
	$ButtonC.hide()
	$ButtonD.hide()

func ShowContinueScene():
	$ContinueButton.show()
	
func ShowDreamScene():
	$TeaBackdrop.show()
	$ButtonAd.show()
	$ButtonBd.show()
	$ButtonCd.show()
	$ButtonDd.show()

func ShowMainMenu():
	$ExitButton.hide()
	$StartButton.show()
	$QuitButton.show()
	
func ShowTeaScene():
	$TeaBackdrop.show()
	$ButtonA.show()
	$ButtonB.show()
	$ButtonC.show()
	$ButtonD.show()
