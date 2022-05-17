extends Node2D


var tile =preload("res://Tile.tscn")
var finish = preload("res://finish.tscn")
var player = preload("res://player.tscn")
var hubTexture = preload("res://hubTexture.tscn")
var altPath = preload("res://altPath.tscn")


const dir = [Vector2.LEFT,Vector2.RIGHT,Vector2.DOWN,Vector2.UP]
var dir_strength = [0,0,0,0]
var max_strength = 0
var choose = 0
var store_pos = [Vector2(0,0)]
var dummy_store_pos = []
var iteration_num = 0
var random = RandomNumberGenerator.new()
var stay_direction = 0
var d
var start = Vector2(0,0)
var end = Vector2(2,2)
var hub_pos = []
var hub_lenght = Vector2(0,0)
var prev_hub = Vector2(0,0)


var repeats = false
var isCreatingPath = false

var grid_size = 100
var grid_spread = 35
var grid_steps = 800
var grid = []
var current_pix = Vector2(0,0)
var current_pos = Vector2(0,0)

var hubNumber = 3
var hubStart = []
var dumbCounter = 0

var current_dir = Vector2.RIGHT
var last_dir = current_dir * -1
var isHub = false
var hubCounter = 0

func _ready():
	randomize()
	random.randomize()
	var ssss = grid_steps/ hubNumber
	print(ssss)
	for jj in hubNumber:
		hubStart.push_back(random.randi_range(0+(ssss*jj), ssss + (ssss*jj)))
		print(hubStart[jj])
	
	
	current_pix = Vector2(0,0)
	current_pos = Vector2(0,0)
	current_dir = Vector2.RIGHT
	last_dir = current_dir * -1
	var t = tile.instance()
	t.position = current_pix
	
	add_child(t)

	while (iteration_num < grid_steps):
		if(isHub):
			hubcreator(iteration_num)
		else:
			create_level(iteration_num)
		iteration_num += 1
		
		var time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")

	print(hub_pos)
		
	
	
func create_level(asd):
	
	
	#wanna controll the chance of the direction
	var temp_dir = dir.duplicate()
	
	var dist = end-current_pos
	dist = dist 
	#print(dist)
	#print("dist")
	dir_strength = [0,0,0,0]
	
	
	if (stay_direction <= 0):
		#var random_num = random.randi_range(0, 7)
		#print(random_num)
		#random_num = 0
		#if (random_num == 0 ):
		#	d = Vector2.RIGHT
		#elif (random_num >=2 && random_num <4):
		#	d = Vector2.LEFT
		#elif (random_num >=4 && random_num <6):
		#	d = Vector2.UP
		#else:
		#	d = Vector2.DOWN
		#eleji distancia maxima
		if(dist.x <= 0):
			dir_strength[0] = dist.x * -1
		if(dist.x >= 0):
			dir_strength[1] = dist.x 
		if(dist.y >= 0):
			dir_strength[2] = dist.y
		if(dist.y <= 0):
			dir_strength[3] = dist.y * -1
		max_strength = 0
		var iterr = 0
		
		d = dir[iterr]
		#choose the bigest one and set to d
		for u in dir_strength:
			if (u > max_strength):
				max_strength = u
				d = dir[iterr]
				#print(d)
				#print("if d")
			iterr += 1
			#print("for")
			#print(u)
		current_dir = d 
		#last_dir = current_dir * -1
		var random_num = 10
		#var random_num = random.randi_range(0, 7)
		if (random_num > 5):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
		stay_direction = random.randi_range(2, 4)
	else:
		stay_direction -=1
	
	while(abs(current_pos.x + d.x) > grid_size or abs(current_pos.y + d.y) > grid_size ):
		temp_dir.shuffle()
		d = temp_dir.pop_front()
		
	
	
	current_pos += d
	current_pix += d * grid_spread
	last_dir = d
	
	
	
	dummy_store_pos = store_pos.duplicate()
	dummy_store_pos.pop_back()
	for o in dummy_store_pos:
		if(current_pos == o ):
			repeats = true
			#si pones un break aca se jode todo :(
			#print("false")
	#spawns tile if it doesnt repeat
	
	if (repeats != true && asd != grid_steps-1):
		store_pos.push_back(current_pos)
		var t = tile.instance()
		t.position = current_pix
		add_child(t)
		
	#spawns player and exit
	if (asd == grid_steps-1):
		var t = finish.instance()
		t.position = current_pix
		add_child(t)
		
		
		
		t = player.instance()
		t.position = Vector2(0,0) + store_pos[1]
		move_child(t, 0)
		add_child(t)
		#print("end?")
	
	repeats = false
	for ggg in hubNumber:
		if (asd == hubStart[ggg]):
			#print(ggg)
			isHub = true
			hubCounter = asd
			hub_pos.push_back(current_pos)
			end = current_pos
	#print(current_pos)
	
	
	
	#print(store_pos[asd])
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("R"):
		var x = random.randi_range(0,hub_pos.size()-1)
		var xx = random.randi_range(0,hub_pos.size()-1)
		while xx == x:
			xx = random.randi_range(0,hub_pos.size()-1)
		print(xx)
		print(x)
		current_pos = hub_pos[x]
		current_pix = hub_pos[x] * 35
		isCreatingPath = true
		while isCreatingPath == true:
			createAltPath(hub_pos[xx])
		dumbCounter = 0




func hubcreator(asd):
	#wanna controll the chance of the direction
	var temp_dir = dir.duplicate()
	
	var dist = end-current_pos
	dist = dist 
	#print(dist)
	#print("dist")
	dir_strength = [0,0,0,0]
	
	
	if (stay_direction <= 0):
		#var random_num = random.randi_range(0, 7)
		#print(random_num)
		#random_num = 0
		#if (random_num == 0 ):
		#	d = Vector2.RIGHT
		#elif (random_num >=2 && random_num <4):
		#	d = Vector2.LEFT
		#elif (random_num >=4 && random_num <6):
		#	d = Vector2.UP
		#else:
		#	d = Vector2.DOWN
		#eleji distancia maxima
		if(dist.x <= 0):
			dir_strength[0] = dist.x * -1
		if(dist.x >= 0):
			dir_strength[1] = dist.x 
		if(dist.y >= 0):
			dir_strength[2] = dist.y
		if(dist.y <= 0):
			dir_strength[3] = dist.y * -1
		max_strength = 0
		var iterr = 0
		
		d = dir[iterr]
		#choose the bigest one and set to d
		for u in dir_strength:
			if (u > max_strength):
				max_strength = u
				d = dir[iterr]
				#print(d)
				#print("if d")
			iterr += 1
			#print("for")
			#print(u)
		current_dir = d 
		#last_dir = current_dir * -1
		#var random_num = 0
		var random_num = random.randi_range(0, 8)
		if (random_num > 5):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
		stay_direction = random.randi_range(0, 2)
	else:
		stay_direction -=1
	
	while(abs(current_pos.x + d.x) > grid_size or abs(current_pos.y + d.y) > grid_size ):
		temp_dir.shuffle()
		d = temp_dir.pop_front()
		
	
	
	current_pos += d
	current_pix += d * grid_spread
	last_dir = d
	
	
	
	dummy_store_pos = store_pos.duplicate()
	dummy_store_pos.pop_back()
	for o in dummy_store_pos:
		if(current_pos == o ):
			repeats = true
			
			#print("false")
	#spawns tile if it doesnt repeat
	
	if (repeats != true && asd != grid_steps-1):
		store_pos.push_back(current_pos)
		var t = hubTexture.instance()
		t.position = current_pix
		add_child(t)
		
	#spawns player and exit
	if (asd == grid_steps-1):
		var t = finish.instance()
		t.position = current_pix
		add_child(t)
		
		
		
		t = player.instance()
		t.position = Vector2(0,0) + store_pos[1]
		move_child(t, 0)
		add_child(t)
		print("end?2")
		print(asd)

	if (asd > hubCounter+200):
		isHub = false
		print("out of hub")
	repeats = false
	#print(current_pos)
	

func createAltPath(endX):
	dumbCounter += 1
	#wanna controll the chance of the direction
	var temp_dir = dir.duplicate()
	
	var dist = endX-current_pos
	print(dist)
	print(current_pos)
	print(current_pix)
	dist = dist 
	if ((abs(dist.x )<1 && abs(dist.y )<1) || dumbCounter > 1000):
		isCreatingPath = false
	#print(dist)
	#print("dist")
	dir_strength = [0,0,0,0]
	
	
	if (stay_direction <= 0):
		#var random_num = random.randi_range(0, 7)
		#print(random_num)
		#random_num = 0
		#if (random_num == 0 ):
		#	d = Vector2.RIGHT
		#elif (random_num >=2 && random_num <4):
		#	d = Vector2.LEFT
		#elif (random_num >=4 && random_num <6):
		#	d = Vector2.UP
		#else:
		#	d = Vector2.DOWN
		#eleji distancia maxima
		if(dist.x <= 0):
			dir_strength[0] = dist.x * -1
		if(dist.x >= 0):
			dir_strength[1] = dist.x 
		if(dist.y >= 0):
			dir_strength[2] = dist.y
		if(dist.y <= 0):
			dir_strength[3] = dist.y * -1
		max_strength = 0
		var iterr = 0
		
		d = dir[iterr]
		#choose the bigest one and set to d
		for u in dir_strength:
			if (u > max_strength):
				max_strength = u
				d = dir[iterr]
				#print(d)
				#print("if d")
			iterr += 1
			#print("for")
			#print(u)
		current_dir = d 
		#last_dir = current_dir * -1
		var random_num = 0
		#var random_num = random.randi_range(0, 7)
		if (random_num > 5):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
		stay_direction = 0
	else:
		stay_direction -=1
	
	
	
	current_pos += d
	current_pix += d * grid_spread
	last_dir = d
	
	
	
	dummy_store_pos = store_pos.duplicate()
	dummy_store_pos.pop_back()
	#for o in dummy_store_pos:
	#	if(current_pos == o ):
	#		repeats = true
	#i give up
			#si pones un break aca se jode todo :(
			#print("false")
	#spawns tile if it doesnt repeat
	
	if (repeats != true):
		store_pos.push_back(current_pos)
		var t = altPath.instance()
		t.position = current_pix
		add_child(t)
		
	
	repeats = false
	
	
	
	
#failed project
func prevHubCreator(asd):
	
	
	#creamos hubs
	#store pos hub
	#hub_pos = current_pos
	hub_pos.push_back(current_pos)
	#var newIteration = iteration_num + 50
	hub_lenght.x = 5
	hub_lenght.y = 5

	#do a for loop fo the x and y and print a  block
	#update the position? then set it to the center
	#print("j")
	#for x in hub_lenght.x:
	#	for y in hub_lenght.y:
			#print("asd")
			#current pix value is bad but getting close
	#		current_pix = Vector2(abs(x*grid_size)  + current_pos.x,abs(y*grid_size)  + current_pos.y)
	#		dummy_store_pos = store_pos.duplicate()
	#		dummy_store_pos.pop_back()
	#		for o in dummy_store_pos:
	#			if(current_pix  == o ):
	#				repeats = true
				
			#then place the tile and add the position
	#		if (repeats != true):
	#			store_pos.push_back(current_pix)
	#			var t = tile.instance()
	#			t.position = Vector2(0,0)
	#			add_child(t)
	#		print(current_pix)
	#		repeats = false
	#reset it?
	#print("hub created")
	#wanna controll the chance of the direction
	print("j")
	var temp_dir = dir.duplicate()
	
	var dist = end-current_pos
	dist = dist 
	#print(dist)
	#print("dist")
	dir_strength = [0,0,0,0]
	
	
	if (stay_direction <= 0):
		#var random_num = random.randi_range(0, 7)
		#print(random_num)
		#random_num = 0
		#if (random_num == 0 ):
		#	d = Vector2.RIGHT
		#elif (random_num >=2 && random_num <4):
		#	d = Vector2.LEFT
		#elif (random_num >=4 && random_num <6):
		#	d = Vector2.UP
		#else:
		#	d = Vector2.DOWN
		#eleji distancia maxima
		if(dist.x <= 0):
			dir_strength[0] = dist.x * -1
		if(dist.x >= 0):
			dir_strength[1] = dist.x 
		if(dist.y >= 0):
			dir_strength[2] = dist.y
		if(dist.y <= 0):
			dir_strength[3] = dist.y * -1
		max_strength = 0
		var iterr = 0
		
		d = dir[iterr]
		#choose the bigest one and set to d
		for u in dir_strength:
			if (u > max_strength):
				max_strength = u
				d = dir[iterr]
				#print(d)
				#print("if d")
			iterr += 1
			#print("for")
			#print(u)
		current_dir = d 
		#last_dir = current_dir * -1
		var random_num = 10
		#var random_num = random.randi_range(0, 7)
		if (random_num > 5):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
		stay_direction = random.randi_range(0, 2)
	else:
		stay_direction -=1
	#2 maneras, o la vivora o el cuadrado que no funciono
	while(abs(current_pos.x + d.x - prev_hub.x) >  hub_lenght.x or abs(current_pos.y + d.y - prev_hub.y) > hub_lenght.y ):
		temp_dir.shuffle()
		d = temp_dir.pop_front()
		
	
	
	current_pos += d
	current_pix += d * grid_spread
	last_dir = d
	
	
	
	dummy_store_pos = store_pos.duplicate()
	dummy_store_pos.pop_back()
	for o in dummy_store_pos:
		if(current_pos == o ):
			repeats = true
			break
			#print("false")
	#spawns tile if it doesnt repeat
	
	if (repeats != true):
		store_pos.push_back(current_pos)
		var t = tile.instance()
		t.position = current_pix
		add_child(t)
		
	#spawns player and exit
	
	repeats = false
	print(current_pos)

