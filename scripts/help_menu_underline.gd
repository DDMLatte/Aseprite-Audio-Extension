class_name UnderlineRenderer
extends Control

# Code for a special text effect for the url tags in the help menu.
# This is done to correct the spacing of the underlined text.

@export var label : RichTextLabel;
var underline : UnderlineEffect;

func _ready() -> void:
	underline = UnderlineEffect.new();
	label.install_effect(underline);
	show_behind_parent = true;

func _process(delta: float) -> void:
	queue_redraw();

const offset := Vector2(5.5, 3.0);
const thickness := 1.0;
var color := Color.from_string("#605f7d", Color.DIM_GRAY);
func _draw() -> void:
	draw_set_transform(offset);
	for array : Array[Transform2D] in underline.character_transforms:
		for i : int in range(array.size() - 1):
			var current_transform := array[i];
			var next_transform := array[i + 1];
			draw_line(current_transform.origin, next_transform.origin, color, thickness);
		
		var last_transform := array[array.size() - 1];
		draw_line(last_transform.origin, last_transform.origin + offset * Vector2.RIGHT, color, thickness);
	
	underline.character_transforms = [];

class UnderlineEffect extends RichTextEffect:
	var bbcode := "underline";
	var character_transforms : Array[Array] = [];
	var last_start := 0;
	var current_array : Array[Transform2D] = [];

	func _process_custom_fx(char_fx: CharFXTransform) -> bool:
		if(char_fx.relative_index == 0):
			current_array = [];
			character_transforms.push_back(current_array);
		
		current_array.push_back(char_fx.transform);
		return true;
