extends Node

enum LazerColor {
	RED,
	GREEN,
	BLUE
}

var LazerColorToGodotColor = {
	Global.LazerColor.RED: Color.RED,
	Global.LazerColor.GREEN: Color.GREEN,
	Global.LazerColor.BLUE: Color.BLUE
}
