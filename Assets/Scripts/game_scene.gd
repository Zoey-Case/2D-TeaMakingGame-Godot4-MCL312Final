extends Node2D

@export var standardText = ["START TEXT", "MENU TEXT", "CORRECT CHOICE", "INCORRECT CHOICE"]
@export var endText = ["NEVER PASSED SCENE 1", "NEVER PASSED SCENE 2", "NEVER PASSED SCENE 3",
					"NEVER PASSED SCENE 4", "REACHED END, BUT FOUND 0 CLUES",
					"REACHED END, BUT ONLY FOUND 1 CLUE", "REACHED END, BUT ONLY FOUND 2 CLUES",
					"REACHED END, BUT ONLY FOUND 3 CLUES", "REACHED END, AND FOUND ALL 4 CLUES"]
@export var dreamText = []
@export var teaText = []

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
	$UI.ShowMessage(standardText[0])
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
	ResetGame()
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowMainMenu()
	$UI.ShowMessage(standardText[1])

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
		$UI.ShowMessage(standardText[2])
		if(choiceNum > 1):
			if(teaCorrect == 2):
				goToDream = true
				teaCorrect = 0
			
			teaCorrect = 0
			choiceNum = 0
			ContinueGame()
	else:
		$UI.ShowMessage(standardText[3])
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
		$UI.ShowMessage(standardText[2])
	else:
		$UI.ShowMessage(standardText[3])
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceBdSelected():
	print("Dream Choice B Selected")
	
	if(sceneNum == 4):
		dreamCorrect += 1
		$UI.ShowMessage(standardText[2])
	else:
		$UI.ShowMessage(standardText[3])
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceCdSelected():
	print("Dream Choice C Selected")
	
	if(sceneNum == 3):
		dreamCorrect += 1
		$UI.ShowMessage(standardText[2])
	else:
		$UI.ShowMessage(standardText[3])
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func ChoiceDdSelected():
	print("Dream Choice D Selected")
	print("Scene: ", sceneNum)
	
	if(sceneNum == 2):
		dreamCorrect += 1
		$UI.ShowMessage(standardText[2])
	else:
		$UI.ShowMessage(standardText[3])
	
	print("Correct Dream Answers: ", dreamCorrect)
	ContinueGame()

func GoToEnd():
	print("End Reached")
	
	match sceneNum:
		1:
			$UI.ShowMessage(endText[0])
		2:
			$UI.ShowMessage(endText[1])
		3:
			$UI.ShowMessage(endText[2])
		4:
			$UI.ShowMessage(endText[3])
		5:
			if(dreamCorrect == 4):
				$UI.ShowMessage(endText[8])
			elif(dreamCorrect == 3):
				$UI.ShowMessage(endText[7])
			elif(dreamCorrect == 2):
				$UI.ShowMessage(endText[6])
			elif(dreamCorrect == 1):
				$UI.ShowMessage(endText[5])
			else:
				$UI.ShowMessage(endText[4])
