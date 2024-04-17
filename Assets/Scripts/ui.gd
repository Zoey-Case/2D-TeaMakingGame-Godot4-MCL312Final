extends CanvasLayer

# Ingredient variables...
signal activation
signal negation
signal neutral
signal datsura

# Ritual signals...
signal teaLeavesFire
signal teaLeavesWindow
signal stirTea
signal refillKettle

# UI Signals...
signal proceed
signal brewTea
signal startGame
signal quitGame
signal returnToMenu
signal teaScene
signal dreamScene
signal menuScene

var inScene = ""

# INGREDIENT SIGNAL FUNCTIONS
func Activation01():
	$TeaScene/IngredientButtons/Activation01.disabled = true
	activation.emit()

func Activation02():
	$TeaScene/IngredientButtons/Activation02.disabled = true
	activation.emit()

func Activation03():
	$TeaScene/IngredientButtons/Activation03.disabled = true
	activation.emit()

func Activation04():
	$TeaScene/IngredientButtons/Activation04.disabled = true
	activation.emit()
	
func Negation01():
	$TeaScene/IngredientButtons/Negation01.disabled = true
	negation.emit()
	
func Negation02():
	$TeaScene/IngredientButtons/Negation02.disabled = true
	negation.emit()
	
func Neutral01():
	$TeaScene/IngredientButtons/Neutral01.disabled = true
	neutral.emit()

func Neutral02():
	$TeaScene/IngredientButtons/Neutral02.disabled = true
	neutral.emit()
	
func Datsura():
	$TeaScene/IngredientButtons/Datsura.disabled = true
	datsura.emit()

func Lavender():
	$TeaScene/IngredientButtons/Lavender.disabled = true
	datsura.emit()

func Milk():
	$TeaScene/IngredientButtons/Milk.disabled = true
	datsura.emit()

func Mint():
	$TeaScene/IngredientButtons/Mint.disabled = true
	datsura.emit()

func Sugar():
	$TeaScene/IngredientButtons/Sugar.disabled = true
	datsura.emit()
	

# RITUAL SIGNAL FUNCTIONS
func TeaLeavesFirePressed():
	teaLeavesFire.emit()
func TeaLEavesWindowPressed():
	teaLeavesWindow.emit()
func StirTeaPressed():
	stirTea.emit()
func RefillKettlePressed():
	refillKettle.emit()

# OTHER SIGNAL FUNCTIONS...
func BrewButtonPressed():
	brewTea.emit()
func StartButtonPressed():
	startGame.emit()
func QuitButtonPressed():
	quitGame.emit()
func ExitButtonPressed():
	returnToMenu.emit()
func ContinueButtonPressed():
	proceed.emit()
	

# UI CONTROLLER METHODS...
func ShowDreamMessage(text):
	$DreamScene/DreamMessage.text = text
	$DreamScene/DreamMessage.show()
	$DreamScene/DreamMessage.TypeWriter()

func ShowTeaMessage(text, instructions):
	$TeaScene/TeaMessage.text = text + "[p]" + instructions + "[/p]"
	$TeaScene/TeaMessage.show()
	$TeaScene/TeaMessage.TypeWriter()

func ShowAlert(alert):
	print("Alert: ", alert)
	$TeaScene/Alert.text = "[center]" + alert + "[/center]"
	$TeaScene/Alert.show()
	$TeaScene/AlertTimer.start()

func HideAlert():
	$TeaScene/Alert.hide()

func HideDreamScene():
	$DreamScene/DreamBackdrop.hide()
	$DreamScene/DreamMessage.hide()
	$DreamScene/ContinueButton.hide()
	
func HideMainMenu():
	$UIbuttons/ExitButton.show()
	$UIbuttons/StartButton.hide()
	$UIbuttons/QuitButton.hide()
	
func HideTeaScene():
	HideIngredients()
	$TeaScene/TeaBackdrop.hide()
	$TeaScene/BrewButton.hide()
	$TeaScene/TeaMessage.hide()
	
func ShowDreamScene(text):
	inScene = "dream"
	dreamScene.emit()
	$DreamScene/DreamBackdrop.show()
	ShowDreamMessage(text)
	$DreamScene/ContinueTimer.start()

func ShowMainMenu():
	inScene = "menu"
	menuScene.emit()
	$UIbuttons/ExitButton.hide()
	$UIbuttons/StartButton.show()
	$UIbuttons/QuitButton.show()
	
func ShowTeaScene(text, instructions):
	inScene = "tea"
	teaScene.emit()
	$TeaScene/TeaBackdrop.show()
	$TeaScene/BrewButtonTimer.start()
	InitializeIngredients()
	ShowTeaMessage(text, instructions)

func HideIngredients():
	$TeaScene/IngredientButtons/Activation01.hide()
	$TeaScene/IngredientButtons/Activation02.hide()
	$TeaScene/IngredientButtons/Activation03.hide()
	$TeaScene/IngredientButtons/Activation04.hide()
	$TeaScene/IngredientButtons/Negation01.hide()
	$TeaScene/IngredientButtons/Negation02.hide()
	$TeaScene/IngredientButtons/Neutral01.hide()
	$TeaScene/IngredientButtons/Neutral02.hide()
	$TeaScene/IngredientButtons/Lavender.hide()
	$TeaScene/IngredientButtons/Milk.hide()
	$TeaScene/IngredientButtons/Mint.hide()
	$TeaScene/IngredientButtons/Sugar.hide()

func InitializeIngredients():
	var activeIngredients = ["Baobab", "Blackthorn", "Irrwurz", "Lotus", "Sanjivani"]
	var otherIngredients = ["Colocasia", "Ginseng", "Osage", "Raskovnik"]
	var negateIngredients = ["Basil", "Cycad"]
	var activeLocations = [[1383, 74], [1497, 74], [1677, 74], [1796, 74], [915, 223], [1089, 223], [1207, 223]]
	var otherLocations = [[1383, 223], [1497, 223], [1677, 223], [1796, 223]]
	var activeChoices = []
	var negateChoices = []
	var otherChoices = []
	var negateChosen = [false, false]
	var RNG = 0
	
	# Select 4 ACTIVATION Ingredients...
	for index in 4:
		# Randomly determine ingredient.
		RNG = RandomNumberGenerator.new()
		var iLength = len(activeIngredients) - 1
		var locLength = len(activeLocations) - 1
		var randomNumbers = [RNG.randi_range(0, iLength), RNG.randi_range(0, locLength)]
		
		# Add new ingredient to list of chosen ingredients.
		activeChoices.append([activeIngredients[randomNumbers[0]], activeLocations[randomNumbers[1]]])
		
		# Delete new ingredient from original list, to prevent repeated selection.
		activeIngredients.pop_at(randomNumbers[0])
		activeLocations.pop_at(randomNumbers[1])
		
		print(activeChoices[index][0], "Chosen at location: ", activeChoices[index][1])
	
	# Select 2 OTHER Ingredients...
	for index in 2:
		# Randomly determine ingredient.
		RNG = RandomNumberGenerator.new()
		var iLength = len(otherIngredients) + len(negateIngredients) - 1
		var locLength = len(otherLocations) - 1
		var randomNumbers = [RNG.randi_range(0,iLength), RNG.randi_range(0,locLength)]
		
		# Determine whether new ingredient is a negation ingredient.
		if (randomNumbers[0] >= len(otherIngredients)):
			# Add new ingredient to list of chosen ingredients.
			randomNumbers[0] -= len(otherIngredients)
			negateChosen[index] = true
			negateChoices.append([negateIngredients[randomNumbers[0]], otherLocations[randomNumbers[1]]])
			otherChoices.append(["",[0,0]])
			
			# Delete new ingredient from original list, to prevent repeated selection.
			negateIngredients.pop_at(randomNumbers[0])
			otherLocations.pop_at(randomNumbers[1])
			
			print(negateChoices[index][0], "Chosen at location: ", negateChoices[index][1])
		else:
			# Add new ingredient to list of chosen ingredients.
			negateChoices.append(["",[0,0]])
			otherChoices.append([otherIngredients[randomNumbers[0]], otherLocations[randomNumbers[1]]])
			
			# Delete new ingredient from original list, to prevent repeated selection.
			otherIngredients.pop_at(randomNumbers[0])
			otherLocations.pop_at(randomNumbers[1])
			
			print(otherChoices[index][0], "Chosen at location: ", otherChoices[index][1])
			
	
	# Configure the ACTIVATION Ingredients...
	SetupButton($TeaScene/IngredientButtons/Activation01, activeChoices[0])
	SetupButton($TeaScene/IngredientButtons/Activation02, activeChoices[1])
	SetupButton($TeaScene/IngredientButtons/Activation03, activeChoices[2])
	SetupButton($TeaScene/IngredientButtons/Activation04, activeChoices[3])
	
	# Configure the OTHER Ingredients...
	if (negateChosen[0] == true):
		SetupButton($TeaScene/IngredientButtons/Negation01, negateChoices[0])
	elif (negateChosen[0] == false):
		SetupButton($TeaScene/IngredientButtons/Neutral01, otherChoices[0])
	
	if (negateChosen[1] == true):
		SetupButton($TeaScene/IngredientButtons/Negation02, negateChoices[1])
	elif (negateChosen[1] == false):
		SetupButton($TeaScene/IngredientButtons/Neutral02, otherChoices[1])
	
	# Configure the NEUTRAL ingredients...
	$TeaScene/IngredientButtons/Lavender.show()
	$TeaScene/IngredientButtons/Milk.show()
	$TeaScene/IngredientButtons/Mint.show()
	$TeaScene/IngredientButtons/Sugar.show()

func SetupButton(button, list):
	match(list[0]):
		"Baobab":
			button.icon = ResourceLoader.load("res://Assets/Icons/Baobab.png")
		"Blackthorn":
			button.icon = ResourceLoader.load("res://Assets/Icons/Blackthorn.png")
		"Irrwurz":
			button.icon = ResourceLoader.load("res://Assets/Icons/Irrwurz.png")
		"Lotus":
			button.icon = ResourceLoader.load("res://Assets/Icons/Lotus.png")
		"Sanjivani":
			button.icon = ResourceLoader.load("res://Assets/Icons/Sanjivani.png")
		"Colocasia":
			button.icon = ResourceLoader.load("res://Assets/Icons/Colocasia.png")
		"Ginseng":
			button.icon = ResourceLoader.load("res://Assets/Icons/Ginseng.png")
		"Osage":
			button.icon = ResourceLoader.load("res://Assets/Icons/Osage.png")
		"Raskovnik":
			button.icon = ResourceLoader.load("res://Assets/Icons/Raskovnik.png")
		"Basil":
			button.icon = ResourceLoader.load("res://Assets/Icons/Basil.png")
		"Cycad":
			button.icon = ResourceLoader.load("res://Assets/Icons/Cycad.png")
		_:
			print("NO ICON SELECTED!")
	
	button.position.x = list[1][0]
	button.position.y = list[1][1]
	button.show()

func ContinueGame():
	if(inScene == "dream"):
		$DreamScene/ContinueButton.show()

func ShowBrewButton():
	if(inScene == "tea"):
		$TeaScene/BrewButton.show()

func RevealDatsura():
	if(inScene == "tea"):
		$TeaScene/IngredientButtons/Datsura.show()
