extends RichTextLabel

func TypeWriter():
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "visible_ratio", 1.0, (len(self.get_parsed_text())/25.0)).from(0.0)
