extends CanvasLayer

var heartIcon: Texture2D = load("res://assets/sprites/heart.png")

func updateHealth(lives):
	#remove all heart icons
	for child in $lives.get_children():
		child.queue_free()
#set hearts in the UI based on the number of lives
	for i in lives:
		var heart = TextureRect.new()
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		heart.texture = heartIcon
		$lives.add_child(heart)




func _on_score_timer_timeout() -> void:
	Global.score += 100
	$score.text = str(Global.score)
	pass # Replace with function body.
