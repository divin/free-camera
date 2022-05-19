tool
extends EditorPlugin

func _enter_tree():
	self.add_custom_type("FreeCamera", "Camera", preload("res://addons/FreeCamera/scripts/FreeCamera.gd"), preload("FreeCamera.png"))

func _exit_tree():
	self.remove_custom_type("FreeCamera")
