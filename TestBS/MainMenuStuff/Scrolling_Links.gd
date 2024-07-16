extends AnimatedSprite2D

@onready var link_button:LinkButton = $LinkButton

var links_list:Array[String] = ["https://discord.com/invite/2K3Z8gHs5A", "https://bit.ly/support_abysmal", "https://www.youtube.com/playlist?list=PLZyki5ywlF11ckxdBZVth1z9GVXwcTMg1", "https://x.com/abysmal_studios", "https://www.instagram.com/abysmal_studios/", "https://www.tiktok.com/@abysmal_studios", "https://ryang12143.itch.io/abyssal"]

var current_link:String = ""

var timer:float = 0

var fading_in:bool = false

var fading_out:bool = false

func _ready():
	self_modulate.a = 1
	set_frame(0)
	current_link = links_list[get_frame()]

func _process(delta):
	timer += delta
	if (timer > 6.5):
		timer = 0
		fading_out = true
	
	if(fading_in):
		if(self_modulate.a < 1):
			self_modulate.a += delta
		else:
			fading_in = false
	
	if(fading_out):
		if(self_modulate.a > 0):
			self_modulate.a -= delta
		else:
			if(get_frame() == 6):
				set_frame(0)
			else:
				set_frame(get_frame() + 1)
			current_link = links_list[get_frame()]
			fading_out = false
			fading_in = true

func _on_link_button_pressed():
	OS.shell_open(current_link)
