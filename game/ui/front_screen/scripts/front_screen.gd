extends CanvasLayer

export (PackedScene) var game_over
export (PackedScene) var victory

################################################################################
# PUBLIC METHODS
################################################################################

func display_screen(new_screen):
	var screen = null
		
	remove_screen()
		
	match new_screen:
		'game_over':
			screen = game_over.instance()
		'victory':
			screen = victory.instance()
	
	add_child(screen)

#-------------------------------------------------------------------------------

func remove_screen():
	if get_child_count() == 0:
		return
	
	var screen = get_child(0)
	remove_child(screen)
	screen.queue_free()
