## Verificación de MayaNumeral. No es autoload. Ejecutar con:
## godot --headless --path . --script res://src/maya_numerals/maya_numeral_check.gd
## Termina con código 0 si todo pasa y con 1 si algo falla.
extends SceneTree

# Por ruta y no por class_name: así no depende de la caché de clases del editor.
const Numeral: GDScript = preload("res://src/maya_numerals/maya_numeral.gd")

var _failures: int = 0


func _initialize() -> void:
	_test_to_digits()
	_test_digit_parts()
	_test_negative()

	if _failures == 0:
		print("maya_numeral_check OK")
		quit(0)
	else:
		printerr("maya_numeral_check: %d caso(s) fallaron" % _failures)
		quit(1)


func _test_to_digits() -> void:
	# Casos del criterio de aceptación de ISS-12.
	_expect_digits(0, [0])
	_expect_digits(7, [7])
	_expect_digits(19, [19])
	_expect_digits(20, [1, 0])
	_expect_digits(45, [2, 5])
	_expect_digits(400, [1, 0, 0])
	# Bordes entre posiciones.
	_expect_digits(21, [1, 1])
	_expect_digits(399, [19, 19])
	_expect_digits(401, [1, 0, 1])
	_expect_digits(8000, [1, 0, 0, 0])

	var digits: Array[int] = Numeral.to_digits(45)
	_expect(digits.is_typed() and digits.get_typed_builtin() == TYPE_INT, "to_digits(): devuelve Array[int]")


func _test_digit_parts() -> void:
	_expect_parts(19, Vector2i(3, 4)) # Criterio: 3 barras y 4 puntos.
	_expect_parts(0, Vector2i(0, 0))
	_expect_parts(1, Vector2i(0, 1))
	_expect_parts(4, Vector2i(0, 4))
	_expect_parts(5, Vector2i(1, 0))
	_expect_parts(7, Vector2i(1, 2))
	_expect_parts(10, Vector2i(2, 0))
	_expect_parts(15, Vector2i(3, 0))
	# Cada dígito se reconstruye con sus partes.
	for d: int in 20:
		var parts: Vector2i = Numeral.digit_parts(d)
		_expect(parts.x * 5 + parts.y == d and parts.y < 5, "digit_parts(%d) reconstruye el dígito" % d)


func _test_negative() -> void:
	print("(se esperan 2 errores de MayaNumeral a continuación: son parte de la prueba)")
	_expect_digits(-5, [0])
	_expect_parts(25, Vector2i(3, 4))


func _expect_digits(n: int, expected: Array[int]) -> void:
	var digits: Array[int] = Numeral.to_digits(n)
	_expect(digits == expected, "to_digits(%d) = %s (esperado %s)" % [n, digits, expected])


func _expect_parts(d: int, expected: Vector2i) -> void:
	var parts: Vector2i = Numeral.digit_parts(d)
	_expect(parts == expected, "digit_parts(%d) = %s (esperado %s)" % [d, parts, expected])


func _expect(condition: bool, label: String) -> void:
	if not condition:
		_failures += 1
		printerr("FALLA: ", label)
