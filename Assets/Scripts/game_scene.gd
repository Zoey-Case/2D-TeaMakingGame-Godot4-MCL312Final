extends Node2D

signal revealDatsura
signal resetButtons

var menuText = ""
var dreamText = []
var teaText = []
var instructions = []
var alerts = []

# Global Variables...
@export var requiredChoiceNum = 2
var CHOICE_REQ = requiredChoiceNum
var sceneOptions = []
var choiceTracker = []
var datsuraGiven = false
var datsuraSelected = false
var choiceCount = 0
var sceneCount = 0
var sceneChange = false
var gameReset = false
var peaceful = true
var scene = ""

###########################
## UI NAVIGATION METHODS ##
###########################

func _ready():
	teaText = GetTextFromFile("TeaText")
	dreamText = GetTextFromFile("DreamText")
	menuText = GetTextFromFile("MenuText")
	instructions = GetTextFromFile("Instructions")
	alerts = GetTextFromFile("Alerts")
	ResetGame()
	$UI.HideTeaScene()
	$UI.HideDreamScene()
	$UI.ShowMainMenu()

func GetTextFromFile(filename):
	var file = FileAccess.open("res://Assets/TextFiles/" + filename + ".txt", FileAccess.READ)
	var data = []
	while(not file.eof_reached()):
		data.append(file.get_line())
	
	return data

func StartGame():
	gameReset = false
	$UI.HideMainMenu()
	GoToTeaScene(teaText[sceneCount], instructions[0])

func ResetGame():
	datsuraGiven = false
	gameReset = true
	peaceful = true
	sceneOptions = ['A', 'B', 'C']
	choiceTracker = [0, 0, 0]
	datsuraSelected = false
	sceneCount = 1
	if($Audio/TeaTheme.playing):
		TrackOperations("TeaTheme")
	if($Audio/DreamTheme.playing):
		TrackOperations("DreamTheme")

func ReturnToMenu():
	ResetGame()
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowMainMenu()

func QuitGame():
	get_tree().quit()

func ContinueGame():
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowContinueScene()

func GoToDream(dreamTextOption):
	if(not peaceful):
		sceneCount += 1
		if(not $Audio/DreamTheme.playing):
			print("Dream Track not playing.")
			sceneChange = true
			TrackOperations("DreamTheme")
		$UI.HideTeaScene()
		$UI.ShowDreamScene(dreamTextOption)
	else:
		$UI.HideTeaScene()
		$UI.ShowDreamScene(dreamTextOption)

func GoToTeaScene(teaTextOption, instruction):
	choiceCount = 0
	choiceTracker = [0, 0, 0]
	resetButtons.emit()
	if(not $Audio/TeaTheme.playing):
		print("Tea Track not playing.")
		sceneChange = true
		TrackOperations("TeaTheme")
	$UI.HideDreamScene()
	$UI.ShowTeaScene(teaTextOption, instruction)

func ActivationIngredientSelected():
	choiceTracker[0] += 1
	choiceCount += 1
	print("Activation ingredient selected.")

func NegationIngredientSelected():
	choiceTracker[1] += 1
	choiceCount += 1
	print("Negation ingredient selected.")

func NeutralIngredientSelected():
	choiceTracker[2] += 1
	choiceCount += 1
	print("Neutral ingredient selected.")

func DatsuraSelected():
	datsuraSelected = true

func BrewTea():
	print("Choices Made: ", choiceCount)
	var RNG = RandomNumberGenerator.new()
	if(choiceCount < CHOICE_REQ):
		print("NOT ENOUGH CHOICES")
		# DO NOTHING
		$UI.ShowAlert(alerts[0])
	elif(datsuraGiven == true):
		print("DATSURA GIVEN")
		if(datsuraSelected == false):
			print("DATSURA NOT USED")
			# DO NOT ENTER DREAM
			peaceful = true
			GoToDream(dreamText[0])
		else:
			print("DATSURA USED")
			peaceful = false
			# ENTER FINAL DREAM
			GoToDream(dreamText[5])
	elif(len(sceneOptions) > 0):
		print("DREAMS REMAINING")
		if (choiceTracker[1] > 0 or choiceTracker[0] == 0):
			print("NEGATION CHOSEN")
			# DO NOT ENTER DREAM
			peaceful = true
			GoToDream(dreamText[0])
		else:
			print("NEGATION NOT CHOSEN")
			# ENTER DREAM
			var randomNumber = RNG.randi_range(0, len(sceneOptions) - 1)
			var choice = sceneOptions[randomNumber]
			sceneOptions.pop_at(randomNumber)
			
			if(choice == 'A'):
				print("ENTERING DREAM A")
				peaceful = false
				GoToDream(dreamText[1])
			elif(choice == 'B'):
				print("ENTERING DREAM B")
				peaceful = false
				GoToDream(dreamText[2])
			else:
				print("ENTERING DREAM C")
				peaceful = false
				GoToDream(dreamText[3])
	else:
		print("NO DREAMS REMAINING")
		if (choiceTracker[1] > 0 or choiceTracker[0] == 0):
			print("NEGATION CHOSEN")
			# DO NOT ENTER DREAM
			peaceful = true
			GoToDream(dreamText[0])
		else:
			print("ENTERING INARI ENCOUNTER")
			revealDatsura.emit()
			peaceful = false
			GoToDream(dreamText[4])

func Proceed():
	if(sceneCount >= 5):
		if(peaceful == false):
			ReturnToMenu()
		else:
			peaceful = true
			GoToTeaScene(teaText[0], instructions[0])
	else:
		if(peaceful == false):
			GoToTeaScene(teaText[sceneCount], instructions[0])
		else:
			peaceful = true
			GoToTeaScene(teaText[0], instructions[0])


func MusicFinished():
	if(not sceneChange):
		print("Scene NOT changed.")
		if(scene == "tea"):
			print("Replaying TEA TRACK.")
			$Audio/TeaTheme.play()
		else:
			print("Replaying DREAM TRACK.")
			$Audio/DreamTheme.play()
	else:
		print("Scene changed.")
		print("Not replaying track.")

func TrackOperations(track):
	if (track == "TeaTheme"):
		print("Turning down DREAM TRACK.")
		$Audio/MusicFader.play("DreamDown")
	elif (track == "DreamTheme"):
		print("Turning down TEA TRACK.")
		$Audio/MusicFader.play("TeaDown")
	
	print("Starting FADE TIMER.")
	$Audio/FadeTimer.start()

func FadeTimerEnd():
	if(gameReset == true):
		print("Game is being reset.")
		print("Stopping both tracks.")
		$Audio/TeaTheme.stop()
		$Audio/DreamTheme.stop()
		print("Resetting track volumes.")
		$Audio/MusicFader.play("TeaUp")
		$Audio/MusicFader.play("DreamUp")
		gameReset = false
	else:
		print("Game is not being reset.")
		if($Audio/TeaTheme.playing):
			print("Stopping TEA TRACK.")
			$Audio/TeaTheme.stop()
			print("Playing DREAM TRACK.")
			$Audio/DreamTheme.play()
			print("Resetting Tea Track volume.")
			$Audio/MusicFader.play("TeaUp")
		else:
			print("Stopping DREAM TRACK.")
			$Audio/DreamTheme.stop()
			print("Playing TEA TRACK.")
			$Audio/TeaTheme.play()
			print("Resetting DREAM TRACK volume.")
			$Audio/MusicFader.play("DreamUp")
	
	if(sceneChange == true):
		sceneChange = false

func ResetButtons():
	pass # Replace with function body.

func TeaScene():
	scene = "tea"

func DreamScene():
	scene = "dream"

func MenuScene():
	scene = "menu"
