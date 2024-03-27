extends Node2D

var startText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
var menuText = "MENU SCREEN"
var correctText = "CORRECT CHOICE"
var incorrectText = "INCORRECT CHOICE"
var endText = "END REACHED"

var endScene1Text = "NEVER PASSED SCENE 1"
var endScene2Text = "NEVER PASSED SCENE 2"
var endScene3Text = "NEVER PASSED SCENE 3"
var endScene4Text = "NEVER PASSED SCENE 4"
var end0Text = "REACHED END, BUT FOUND 0 CLUES"
var end1Text = "REACHED END, BUT ONLY FOUND 1 CLUE"
var end2Text = "REACHED END, BUT ONLY FOUND 2 CLUES"
var end3Text = "REACHED END, BUT ONLY FOUND 3 CLUES"
var end4Text = "REACHED END, AND FOUND ALL 4 CLUES"

var sceneNum = 0
var choiceNum = 0
var dreamCorrect = 0
var teaCorrect = 0
var turnsRemaining = 9
var correct = false
var goToDream = false
var inDream = false

func StartGame():
	$UI.HideMainMenu()
	$UI.ShowTeaScene()
	$UI.ShowMessage(startText)
	sceneNum += 1

func ResetGame():
	sceneNum = 0
	choiceNum = 0
	dreamCorrect = 0
	teaCorrect = 0
	turnsRemaining = 10
	correct = false
	goToDream = false
	inDream = false

func ReturnToMenu():
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowMainMenu()
	$UI.ShowMessage(menuText)

func QuitGame():
	print("Game Exited")
	get_tree().quit()

func ChoiceASelected():
	print("Choice A Selected")
	choiceNum += 1
	
	if(choiceNum == 1):
		if(sceneNum == 2):
			correct = true
			teaCorrect += 1
	elif(choiceNum == 2):
		if(sceneNum == 1):
			correct = true
			teaCorrect += 1
	
	ProcessTurn()

func ChoiceBSelected():
	print("Choice B Selected")
	choiceNum += 1
	
	if(choiceNum == 1 and sceneNum == 1):
			correct = true
			teaCorrect += 1
	elif(choiceNum == 2 and sceneNum == 4):
			correct = true
			teaCorrect += 1
	
	ProcessTurn()

func ChoiceCSelected():
	print("Choice C Selected")
	choiceNum += 1
	
	if(choiceNum == 1 and sceneNum == 4):
			correct = true
			teaCorrect += 1
	elif(choiceNum == 2 and sceneNum == 3):
			correct = true
			teaCorrect += 1
	
	ProcessTurn()

func ChoiceDSelected():
	print("Choice D Selected")
	choiceNum += 1
	
	if(choiceNum == 1 and sceneNum == 3):
			correct = true
			teaCorrect += 1
	elif(choiceNum == 2 and sceneNum == 2):
			correct = true
			teaCorrect += 1
	
	ProcessTurn()

func ProcessTurn():
	print("Choice Number: ", choiceNum)
	print("Tea Correct: ", teaCorrect)
	
	if(correct):
		$UI.ShowMessage(correctText)
		if(choiceNum > 1):
			if(teaCorrect == 2):
				goToDream = true
				teaCorrect = 0
			
			teaCorrect = 0
			choiceNum = 0
			ContinueGame()
	else:
		$UI.ShowMessage(incorrectText)
		if(choiceNum > 1):
			choiceNum = 0
			ContinueGame()
	
	correct = false

func ContinueGame():
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowContinueScene()
	
	print("Scene: ", sceneNum)
	print("Turns Remaining: ", turnsRemaining)

func GoToDream():
	goToDream = false
	inDream = true
	$UI.ShowDreamScene()

func GoToNextScene():
	sceneNum += 1
	turnsRemaining -= 1
	$UI.HideDreamScene()
	$UI.ShowTeaScene()

func RestartScene():
	turnsRemaining -= 1
	$UI.ShowTeaScene()

func ContinueButtonPressed():	
	if(turnsRemaining > 0):
		if(goToDream):
			GoToDream()
		elif(inDream):
			inDream = false
			if(sceneNum > 3):
				sceneNum += 1
				GoToEnd()
			else:
				GoToNextScene()
		else:
			RestartScene()
	else:
		GoToEnd()
	
	$UI.HideContinueScene()


func ChoiceAdSelected():
	print("Dream Choice A Selected")
	
	if(sceneNum == 1):
		dreamCorrect += 1
		$UI.ShowMessage(correctText)
	else:
		$UI.ShowMessage(incorrectText)
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceBdSelected():
	print("Dream Choice B Selected")
	
	if(sceneNum == 4):
		dreamCorrect += 1
		$UI.ShowMessage(correctText)
	else:
		$UI.ShowMessage(incorrectText)
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceCdSelected():
	print("Dream Choice C Selected")
	
	if(sceneNum == 3):
		dreamCorrect += 1
		$UI.ShowMessage(correctText)
	else:
		$UI.ShowMessage(incorrectText)
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceDdSelected():
	print("Dream Choice D Selected")
	print("Scene: ", sceneNum)
	
	if(sceneNum == 2):
		dreamCorrect += 1
		$UI.ShowMessage(correctText)
	else:
		$UI.ShowMessage(incorrectText)
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func GoToEnd():
	print("End Reached")
	
	match sceneNum:
		1:
			$UI.ShowMessage(endScene1Text)
		2:
			$UI.ShowMessage(endScene2Text)
		3:
			$UI.ShowMessage(endScene3Text)
		4:
			$UI.ShowMessage(endScene4Text)
		5:
			if(dreamCorrect == 4):
				$UI.ShowMessage(end4Text)
			elif(dreamCorrect == 3):
				$UI.ShowMessage(end3Text)
			elif(dreamCorrect == 2):
				$UI.ShowMessage(end2Text)
			elif(dreamCorrect == 1):
				$UI.ShowMessage(end1Text)
			else:
				$UI.ShowMessage(end0Text)
