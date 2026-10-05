extends Control
## Escena de prueba de ISS-12.
## Checks automáticos de MayaNumber; en headless sale con código 0 (todo PASS) o 1 (algún FAIL).
## Prueba manual: flechas arriba/abajo cambian el número "En vivo" de 1 en 1, izquierda/derecha
## de 20 en 20 y T alterna GameState.tutorial_active (número arábigo debajo de cada número).

var _failed: bool = false

@onready var _zero: MayaNumber = $Cases/Zero
@onready var _seven: MayaNumber = $Cases/Seven
@onready var _nineteen: MayaNumber = $Cases/Nineteen
@onready var _twenty: MayaNumber = $Cases/Twenty
@onready var _forty_five: MayaNumber = $Cases/FortyFive
@onready var _four_hundred: MayaNumber = $Cases/FourHundred
@onready var _live: MayaNumber = $Cases/Live
@onready var _live_caption: Label = $Cases/LiveCaption


func _ready() -> void:
	await _run_checks()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(1 if _failed else 0)


# El rótulo sigue a value aunque cambie desde el inspector remoto del editor.
func _process(_delta: float) -> void:
	_live_caption.text = "En vivo\n%d" % _live.value


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_up"):
		_live.value += 1
	elif event.is_action_pressed(&"ui_down"):
		_live.value = maxi(_live.value - 1, 0)
	elif event.is_action_pressed(&"ui_right"):
		_live.value += 20
	elif event.is_action_pressed(&"ui_left"):
		_live.value = maxi(_live.value - 20, 0)
	elif event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_T:
		GameState.tutorial_active = not GameState.tutorial_active
	else:
		return
	get_viewport().set_input_as_handled()


func _run_checks() -> void:
	var dot: Texture2D = MayaNumber.DOT_TEXTURE
	var bar: Texture2D = MayaNumber.BAR_TEXTURE
	var shell: Texture2D = MayaNumber.SHELL_TEXTURE
	var tutorial_before: bool = GameState.tutorial_active
	GameState.tutorial_active = false
	await get_tree().process_frame

	# Criterio: 0 es una concha.
	_check_layout(_zero, "0", [[shell, Vector2(0, 0)]], Vector2(16, 8))
	# Criterio: 7 es 1 barra con 2 puntos encima (centrados).
	_check_layout(_seven, "7", [[dot, Vector2(4, 0)], [dot, Vector2(8, 0)], [bar, Vector2(0, 5)]], Vector2(16, 9))
	# 19: 4 puntos y 3 barras.
	_check_layout(_nineteen, "19", [
		[dot, Vector2(0, 0)], [dot, Vector2(4, 0)], [dot, Vector2(8, 0)], [dot, Vector2(12, 0)],
		[bar, Vector2(0, 5)], [bar, Vector2(0, 10)], [bar, Vector2(0, 15)],
	], Vector2(16, 19))
	# Criterio: 20 son dos niveles, un punto arriba y una concha abajo.
	_check_layout(_twenty, "20", [[dot, Vector2(6, 0)], [shell, Vector2(0, 6)]], Vector2(16, 14))
	# 45 = [2, 5]: dos puntos arriba y una barra abajo.
	_check_layout(_forty_five, "45", [[dot, Vector2(4, 0)], [dot, Vector2(8, 0)], [bar, Vector2(0, 6)]], Vector2(16, 10))
	# 400 = [1, 0, 0]: tres niveles.
	_check_layout(_four_hundred, "400", [[dot, Vector2(6, 0)], [shell, Vector2(0, 6)], [shell, Vector2(0, 16)]], Vector2(16, 24))

	# Criterio: cambiar value en ejecución redibuja.
	_live.value = 7
	_check_layout(_live, "value 7 en ejecución", [[dot, Vector2(4, 0)], [dot, Vector2(8, 0)], [bar, Vector2(0, 5)]], Vector2(16, 9))
	_live.value = 20
	_check_layout(_live, "value 7 → 20 en ejecución", [[dot, Vector2(6, 0)], [shell, Vector2(0, 6)]], Vector2(16, 14))

	# Criterio: con tutorial_active se ve el arábigo debajo; sin él, no.
	GameState.tutorial_active = true
	await get_tree().process_frame
	var label: Label = _seven.get_node(^"ArabicLabel")
	_check(_seven.is_showing_arabic() and label.visible and label.text == "7", "tutorial_active = true muestra el 7 arábigo")
	_check(label.position.y >= 9.0 + _seven.level_gap, "el arábigo queda debajo de los glifos")
	_check(_seven.get_combined_minimum_size().y > 9.0, "el tamaño incluye el arábigo")
	GameState.tutorial_active = false
	await get_tree().process_frame
	_check(not _seven.is_showing_arabic() and not label.visible, "tutorial_active = false oculta el arábigo")
	_check(_seven.get_combined_minimum_size() == Vector2(16, 9), "sin arábigo el tamaño vuelve a 16×9")

	# Criterio: escala 1 y sin suavizado.
	for number: MayaNumber in [_zero, _seven, _twenty]:
		_check(number.scale == Vector2.ONE, "%s a escala 1" % number.name)
		_check(number.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "%s sin suavizado (Nearest)" % number.name)

	GameState.tutorial_active = tutorial_before


# expected: [[textura, posición], ...] en orden de dibujo.
func _check_layout(number: MayaNumber, label: String, expected: Array, expected_size: Vector2) -> void:
	var glyphs: Array[Dictionary] = number.get_glyphs()
	var ok: bool = glyphs.size() == expected.size()
	if ok:
		for i: int in glyphs.size():
			ok = ok and glyphs[i][&"texture"] == expected[i][0] and glyphs[i][&"position"] == expected[i][1]
	_check(ok, "%s: glifos %s" % [label, _describe(glyphs)])
	_check(number.get_combined_minimum_size() == expected_size,
			"%s: tamaño %s (esperado %s)" % [label, number.get_combined_minimum_size(), expected_size])


func _describe(glyphs: Array[Dictionary]) -> String:
	var parts: PackedStringArray = []
	for glyph: Dictionary in glyphs:
		var texture: Texture2D = glyph[&"texture"]
		parts.append("%s@%s" % [texture.resource_path.get_file().get_basename(), glyph[&"position"]])
	return ", ".join(parts)


func _check(condition: bool, label: String) -> void:
	print("%s: %s" % ["PASS" if condition else "FAIL", label])
	if not condition:
		_failed = true
