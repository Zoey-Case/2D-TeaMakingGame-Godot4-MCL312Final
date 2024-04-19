extends Node2D

## TEXT STUFF
var dreamText = ["[p]You rest peacefully in your bed all night...[/p]", "[p]A dark forest surrounds you when you open your eyes.[/p] [p]A flash of light catches your eye.[/p] [p]A glowing fox dashes through the trees ahead. You follow.[/p] [p]An eternity later, the fox stops running. So do you.[/p] [p]The fox looks up through the branches and leaves for a moment, glows brighter and vanishes.[/p] [p]You walk to the same spot, and look up.[/p] [p]One star glows in the sky above.[/p]", "[p]A dark forest surrounds you when you open your eyes.[/p] [p]A flash of light catches your eye.[/p] [p]A glowing fox dashes through the trees ahead. You follow.[/p] [p]The fox enters a clearing. You halt at the treeline to watch.[/p] [p]The fox spirit effortlessly climbs to the top of a giant rock in the middle of the clearing.[/p] [p]The fox looks up at the sky, and then vanishes.[/p] [p]You enter the clearing and circle the rock, trying to climb up, but you can't seem to find a way.[/p] [p]Frustrated, you give up and gaze towards the sky where you see two stars glowing brightly above you.[/p]", "[p]A rock partially obstructs your view when you open your eyes.[/p] [p]You're in the middle of a clearing.[/p] [p]On top of the rock sits a glowing fox. It's looking at you.[/p] [p]By the fox’s glow, you can see crevices in the rock.[/p] [p]You stand, walk to the rock, and climb.[/p] [p]When you’re finally standing on top of the rock, the fox has vanished, but you can still see somehow.[/p] [p]You look up to the sky above. Three huge stars glow back at you.[/p]", "[p]You awaken in the clearing, no rock to be seen, the night sky glowing above.[/p] [p]As you stand, the glowing fox approaches you, and transforms into a person wearing a tunic, still glowing softly from within.[/p] [p]The glow-person smiles.[/p] [p]“I am Inari. You are truly gifted in the craft of tea. Take this. It will bless you as you have blessed me.”[/p] [p]A new flower sits in your hand, white and cup-shaped.[/p]", "[p]You awaken in the clearing. Again.[/p] [p]You stand, looking around for the Inari-fox.[/p] [p]A hole opens in the ground in front of you. You jump back.[/p] [p]A woman climbs from the hole. She seems to suck the light from the stars above.[/p] [p]You hear her voice hissing in your head.[/p] [p]“I am Izanami, and you...you are Inari's chosen. You should not be here.”[/p]"]
var teaText = ["[p]You can't seem to recall having any dreams last night...[/p] [p]Maybe you should try different ingredients.[/p]", "[p]Recently, you've been having bizarre dreams, but you struggle to recall them after.[/p] [p]Try brewing some tea to focus your mind, so you can remember.[/p]", "[p]You shake awake. What in the world?[/p] [p]You’ve never dreamed so clearly...[/p] [p]and it seemed like that fox knew you.[/p] [p]And the forest...It’s like you’ve been there before.[/p] [p]Was it because of the tea you drank?[/p]", "[p]You open your eyes slowly. What's going on?!?[/p] [p]Not only were you dreaming of the same place, but that fox was there again?!?[/p] [p]What could it all mean?[/p] [p]You need some relaxing tea to clear your head.[/p] [p]Maybe you'll have another dream tonight.[/p]", "[p]You wake peacefully, slowly.[/p] [p]You feel like you’re almost to the end of a long journey.[/p] [p]On the edge of a precipice...But you aren't scared.[/p] [p]You know what you need to do...[/p]", "[p]Inari...? And they gave you some kind of special flower for your tea...[/p] [p]That can't have really happened, right?[/p] [p]Only...The flower is RIGHT THERE...[/p] [p]Maybe you should use it...[/p]"]
var instructions = "(Select ingredients to brew.)"
## TEXT STUFF

signal revealDatsura
signal fastTimer
signal enoughChoices

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
var teaScene = false
var gameStart
var pauseTeaTrack

###########################
## UI NAVIGATION METHODS ##
###########################

func _ready():
	#teaText = GetTextFromFile("TeaText")
	#dreamText = GetTextFromFile("DreamText")
	ResetGame()
	$UI.HideTeaScene()
	$UI.HideDreamScene()
	$UI.ShowMainMenu()
	WeatherOn()
	

#func GetTextFromFile(filename):
	##var textFile = ResourceLoader.load("res://Assets/TextFiles/" + filename + ".txt")
	#var file = FileAccess.open(ResourceLoader("res://Assets/TextFiles/" + filename + ".txt"), FileAccess.READ)
	#var data = []
	#while(not textFile.eof_reached()):
		#data.append(textFile.get_line())
	#
	#return data

func WeatherOn():
	if(not $Audio/Effects/Weather.playing):
		$Audio/Effects/Weather.set_volume_db(-80.0)
		$Audio/Effects/Weather.play()
		$Audio/Effects/WeatherController.play("WeatherUp")

func WeatherOff():
	$Audio/Effects/WeatherController.play("WeatherDown")
	$Audio/WeatherTimer.start()

func WeatherTimerFinish():
	$Audio/Effects/Weather.stop()

func WeatherStopped():
	if (not $Audio/Music/TeaTheme.playing):
		$Audio/Effects/Weather.play()
	elif($Audio/Music/TeaTheme.stream_paused):
		$Audio/Effects/Weather.play()

func StartGame():
	gameReset = false
	gameStart = true
	$UI.HideMainMenu()
	GoToTeaScene(teaText[sceneCount], instructions)

func ResetGame():
	datsuraGiven = false
	gameReset = true
	peaceful = true
	pauseTeaTrack = false
	teaScene = false
	sceneOptions = ['A', 'B', 'C']
	choiceTracker = [0, 0, 0]
	datsuraSelected = false
	sceneCount = 1
	TrackOperations("BothTracks")

func ReturnToMenu():
	ResetGame()
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowMainMenu()
	WeatherOn()

func QuitGame():
	get_tree().quit()

func ContinueGame():
	$UI.HideDreamScene()
	$UI.HideTeaScene()
	$UI.ShowContinueScene()

func GoToDream(dreamTextOption):
	teaScene = false
	if(not peaceful):
		sceneCount += 1
		WeatherOn()
		if(not $Audio/Music/DreamTheme.playing):
			print("Dream Track not playing.")
			sceneChange = true
			TrackOperations("DreamTheme")
		$UI.HideTeaScene()
		$UI.ShowDreamScene(dreamTextOption)
	else:
		fastTimer.emit()
		$UI.HideTeaScene()
		$UI.ShowDreamScene(dreamTextOption)

func GoToTeaScene(teaTextOption, instruction):
	teaScene = true
	choiceCount = 0
	choiceTracker = [0, 0, 0]
	WeatherOff()
	if($Audio/Music/DreamTheme.playing):
		print("DRERAM THEME playing.")
		sceneChange = true
		TrackOperations("TeaTheme")
	elif(gameStart):
		$Audio/Music/TeaTheme.set_volume_db(10.0)
		$Audio/Music/TeaTheme.play()
		gameStart = false
	
	$UI.HideDreamScene()
	$UI.ShowTeaScene(teaTextOption, instruction)

func ActivationIngredientSelected():
	choiceTracker[0] += 1
	choiceCount += 1
	print("Activation ingredient selected.")
	if (choiceCount >= CHOICE_REQ):
		enoughChoices.emit()

func NegationIngredientSelected():
	choiceTracker[1] += 1
	choiceCount += 1
	print("Negation ingredient selected.")
	if (choiceCount >= CHOICE_REQ):
		enoughChoices.emit()

func NeutralIngredientSelected():
	choiceTracker[2] += 1
	choiceCount += 1
	print("Neutral ingredient selected.")
	if (choiceCount >= CHOICE_REQ):
		enoughChoices.emit()

func DatsuraSelected():
	datsuraSelected = true
	enoughChoices.emit()

func BrewTea():
	$Audio/Effects/PouringWater.play()

func DrinkTea():
	var RNG = RandomNumberGenerator.new()
	if(datsuraGiven == true):
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
			datsuraGiven = true
			revealDatsura.emit()
			peaceful = false
			GoToDream(dreamText[4])

func Proceed():
	print("SCENE COUNT NOW: ", sceneCount)
	
	if(sceneCount > 5):
		if(peaceful == false):
			$UI.GameOver()
		else:
			peaceful = true
			GoToTeaScene(teaText[0], instructions)
	else:
		if(peaceful == false):
			GoToTeaScene(teaText[sceneCount], instructions)
		else:
			peaceful = true
			GoToTeaScene(teaText[0], instructions)


func MusicFinished():
	if(not sceneChange):
		print("Scene NOT changed.")
		if(teaScene == true):
			print("Replaying TEA TRACK.")
			teaScene = false
			$Audio/Music/TeaTheme.play()
		else:
			print("Replaying DREAM TRACK.")
			$Audio/Music/DreamTheme.play()
	else:
		print("Scene changed.")
		print("Not replaying track.")

func TrackOperations(track):
	if (track == "TeaTheme"):
		print("Turning down DREAM TRACK.")
		$Audio/Music/MusicFader.play("TeaUp")
		$Audio/Music/TeaTheme.stream_paused = false
		#$Audio/Music/TeaTheme.set_volume_db(0.0)
	elif (track == "DreamTheme"):
		print("Turning down TEA TRACK.")
		$Audio/Music/MusicFader.play("DreamUp")
		$Audio/Music/DreamTheme.play()
		pauseTeaTrack = true
	elif (track == "BothTracks"):
		$Audio/Music/MusicFader.play("BothDown")
	
	print("Starting FADE TIMER.")
	$Audio/FadeTimer.start()

func FadeTimerEnd():
	if(gameReset == true):
		print("Game is being reset.")
		print("Stopping both tracks.")
		$Audio/Music/TeaTheme.stop()
		$Audio/Music/DreamTheme.stop()
		gameReset = false
	else:
		print("Game is not being reset.")
		if(pauseTeaTrack):
			print("Stopping TEA TRACK.")
			$Audio/Music/TeaTheme.stream_paused = true
			#$Audio/Music/TeaTheme.set_volume_db(0.0)
			pauseTeaTrack = false
		else:
			print("Stopping DREAM TRACK.")
			$Audio/Music/DreamTheme.stop()
	
	if(sceneChange == true):
		sceneChange = false

func WaterPourFinished():
	DrinkTea()
