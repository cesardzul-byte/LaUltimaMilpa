@tool
class_name MayaNumber
extends Control
## Dibuja `value` en numeración maya con los glifos de assets/ui/maya_numerals/.
## Los niveles se apilan de arriba (posición mayor) hacia abajo en una columna de 16 px.
## En cada nivel van los puntos arriba de las barras, o una concha si el dígito es 0.
## Con GameState.tutorial_active muestra el número arábigo debajo.
## Se usa instanciando maya_number.tscn (trae el Label del número arábigo).

const DOT_TEXTURE: Texture2D = preload("res://assets/ui/maya_numerals/dot.png")
const BAR_TEXTURE: Texture2D = preload("res://assets/ui/maya_numerals/bar.png")
const SHELL_TEXTURE: Texture2D = preload("res://assets/ui/maya_numerals/shell.png")
const COLUMN_WIDTH: int = 16 ## px; ancho de la barra y de la concha.

## Entero a mostrar. Un negativo produce push_error y se dibuja 0.
@export var value: int = 0:
	set(new_value):
		value = new_value
		_refresh()
## Separación vertical entre niveles (posiciones vigesimales), en px.
@export_range(0, 8) var level_gap: int = 2:
	set(new_value):
		level_gap = new_value
		_refresh()
## Separación vertical entre la fila de puntos y las barras, y entre barras, en px.
@export_range(0, 4) var part_gap: int = 1:
	set(new_value):
		part_gap = new_value
		_refresh()

var _glyphs: Array[Dictionary] = [] ## {&"texture": Texture2D, &"position": Vector2}, en orden de dibujo.
var _min_size: Vector2 = Vector2.ZERO
var _shows_arabic: bool = false

@onready var _arabic_label: Label = $ArabicLabel


func _ready() -> void:
	# En el editor no existe el autoload GameState: solo se previsualizan los glifos.
	set_process(not Engine.is_editor_hint())
	_refresh()


# GameState no emite señal al cambiar tutorial_active: se compara una vez por cuadro.
func _process(_delta: float) -> void:
	if GameState.tutorial_active != _shows_arabic:
		_refresh()


func _draw() -> void:
	for glyph: Dictionary in _glyphs:
		draw_texture(glyph[&"texture"], glyph[&"position"])


func _get_minimum_size() -> Vector2:
	return _min_size


## Glifos que se dibujan, en orden. Para pruebas y depuración; no modificar.
func get_glyphs() -> Array[Dictionary]:
	return _glyphs


## true si el número arábigo está visible debajo de los glifos.
func is_showing_arabic() -> bool:
	return _shows_arabic


# Recalcula los glifos, el número arábigo y el tamaño, y pide redibujar.
func _refresh() -> void:
	if not is_node_ready():
		return # _ready() lo llama cuando el Label ya existe.
	_glyphs.clear()
	var y: int = 0
	var digits: Array[int] = MayaNumeral.to_digits(value)
	for i: int in digits.size():
		if i > 0:
			y += level_gap
		y = _add_level(digits[i], y)
	var content_height: int = y

	_shows_arabic = not Engine.is_editor_hint() and GameState.tutorial_active
	_arabic_label.visible = _shows_arabic
	_min_size = Vector2(COLUMN_WIDTH, content_height)
	if _shows_arabic:
		_arabic_label.text = str(maxi(value, 0))
		var label_size: Vector2 = _arabic_label.get_combined_minimum_size()
		# Centrado bajo la columna; un número ancho (p. ej. 400) sobresale por igual a los lados.
		_arabic_label.position = Vector2(roundf((COLUMN_WIDTH - label_size.x) / 2.0), content_height + level_gap)
		_arabic_label.size = label_size
		_min_size.y += level_gap + label_size.y

	update_minimum_size()
	queue_redraw()


# Agrega los glifos de un dígito a partir de y y devuelve la y donde termina el nivel.
func _add_level(digit: int, top: int) -> int:
	if digit == 0:
		_add_glyph(SHELL_TEXTURE, Vector2(0, top))
		return top + SHELL_TEXTURE.get_height()

	var parts: Vector2i = MayaNumeral.digit_parts(digit)
	var y: int = top
	if parts.y > 0:
		# Puntos pegados y centrados: con 4 llenan los 16 px; el dibujo redondeado los separa.
		var dot_width: int = DOT_TEXTURE.get_width()
		@warning_ignore("integer_division")
		var x: int = (COLUMN_WIDTH - parts.y * dot_width) / 2
		for _i: int in parts.y:
			_add_glyph(DOT_TEXTURE, Vector2(x, y))
			x += dot_width
		y += DOT_TEXTURE.get_height()
	for i: int in parts.x:
		if i > 0 or parts.y > 0:
			y += part_gap
		_add_glyph(BAR_TEXTURE, Vector2(0, y))
		y += BAR_TEXTURE.get_height()
	return y


func _add_glyph(texture: Texture2D, position_in_column: Vector2) -> void:
	_glyphs.append({&"texture": texture, &"position": position_in_column})
