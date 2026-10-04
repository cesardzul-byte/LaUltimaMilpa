## Ítem de inventario y mercado (GDD §8 y §12).
class_name ItemData
extends Resource

@export var id: StringName
@export var icon: Texture2D
@export var buy_price: int = 0 ## Cacao. 0 = no se compra.
@export var sell_price: int = 0 ## Cacao. 0 = no se vende.
