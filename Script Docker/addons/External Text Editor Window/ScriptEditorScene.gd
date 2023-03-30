@tool
extends Control

var currentfile
@export var tabsize :int

func _ready():
	$VBoxContainer/TextEdit.set_tab_size(tabsize)
	$VBoxContainer/HBoxContainer/MenuButton.get_popup().id_pressed.connect(
		func menufunc(id):
			var item_pressed = $VBoxContainer/HBoxContainer/MenuButton.get_popup().get_item_text(id)
			
			match item_pressed:
				"Load": 
					print(item_pressed)
					loadfunc()
				"Save":
					savefunc(currentfile)
				"close":
					if currentfile == "":
						print("you have not saved this file. are you sure you want to close it?")
						$ConfirmationDialog.dialog_text = "You have not saved the file. \nare you sure you want to close it?"
						$ConfirmationDialog.popup()
					elif FileAccess.file_exists(currentfile):
						$VBoxContainer/HBoxContainer/Label.text = ""
						$VBoxContainer/TextEdit.text = ""
				"save as":
					savefunc(null)
			)

func loadfunc():
	$FileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	$FileDialog.popup()
	
func savefunc(path):
	if path == null:
		$FileDialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		$FileDialog.popup()
	elif path != null:
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string($VBoxContainer/TextEdit.text)
		file.close()
		print("file saved to " + path)
	

func _on_open_file_file_selected(path):
	print(path)
	$VBoxContainer/HBoxContainer/Label.text = path
	if $FileDialog.file_mode == FileDialog.FILE_MODE_OPEN_FILE:
		currentfile = path
		var file = FileAccess.open(path, FileAccess.READ)
		$VBoxContainer/TextEdit.text = file.get_as_text()
		file.close()
	elif $FileDialog.file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string($VBoxContainer/TextEdit.text)
		file.close()


func _on_button_button_down() -> void:
	if currentfile != null:
		print("refreshing!!")
		var file = FileAccess.open(currentfile, FileAccess.READ)
		print(file.get_as_text())
		%TextEdit.text = file.get_as_text()
		file.close()
	else: print("no file open: can't refresh a null file")
	pass # Replace with function body.


func _on_confirmation_dialog_confirmed() -> void:
	$VBoxContainer/TextEdit.text = ""
	currentfile = null
	pass # Replace with function body.
