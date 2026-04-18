extends MarginContainer






func setup(data:UpgradeData) -> void:
	var sb = StyleBoxTexture.new()
	var title: Label = $VBoxContainer/Name
	var desc: Label = $VBoxContainer/Desc
	var panel_container: PanelContainer = $PanelContainer
	sb.texture = data.icon
	print(title)
	title.text = data.title
	desc.text = data.description
	panel_container.add_theme_stylebox_override("panel",sb)
