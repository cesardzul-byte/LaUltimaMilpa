## Numeración maya vigesimal: concha = 0, punto = 1, barra = 5.
## Solo convierte números; el dibujo lo hace MayaNumber (maya_number.tscn).
class_name MayaNumeral
extends RefCounted

const BASE: int = 20
const BAR_VALUE: int = 5
const MAX_DIGIT: int = BASE - 1


## Dígitos en base 20, de la posición mayor a la menor: 45 → [2, 5], 400 → [1, 0, 0].
## Solo enteros >= 0; un negativo produce push_error y se trata como 0.
static func to_digits(n: int) -> Array[int]:
	if n < 0:
		push_error("MayaNumeral.to_digits(): %d es negativo; se usa 0." % n)
		n = 0
	var digits: Array[int] = []
	# Al menos un dígito: 0 → [0].
	while true:
		digits.push_front(n % BASE)
		@warning_ignore("integer_division")
		n = n / BASE
		if n == 0:
			break
	return digits


## Barras y puntos de un dígito de 0 a 19, como Vector2i(barras, puntos): 19 → (3, 4).
## Un dígito fuera de rango produce push_error y se limita a 0..19.
static func digit_parts(d: int) -> Vector2i:
	if d < 0 or d > MAX_DIGIT:
		push_error("MayaNumeral.digit_parts(): %d está fuera de 0..%d." % [d, MAX_DIGIT])
		d = clampi(d, 0, MAX_DIGIT)
	@warning_ignore("integer_division")
	return Vector2i(d / BAR_VALUE, d % BAR_VALUE)
