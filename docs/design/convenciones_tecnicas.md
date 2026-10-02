# Convenciones técnicas

## Versión de Godot
**Godot 4.7.2 stable** (estándar, GDScript). Todo el equipo usa exactamente esta versión.

## Guía de estilo de GDScript
- Seguir la [guía oficial de estilo de GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- **Tipado estático obligatorio**: variables, parámetros y retornos con tipo.
  ```gdscript
  var health: int = 3
  func take_damage(amount: int) -> void:
  ```
- Archivos y carpetas en `snake_case`; clases (`class_name`) en `PascalCase`; constantes en `MAYUS_CON_GUION_BAJO`.
- Señales en pasado (`health_changed`), funciones privadas con prefijo `_`.
- Código y nombres en inglés; comentarios y documentación en español.

## Ramas
Formato `tipo/numero-descripcion`, donde `numero` es el de la issue.
Ejemplos: `feat/12-movimiento-jugador`, `fix/20-colision-muros`, `docs/5-guia-arte`.
Tipos: `feat`, `fix`, `docs`, `chore`, `refactor`.
Todo cambio llega a `main` mediante Pull Request con 1 aprobación.

## Responsabilidad
- **Un responsable por escena**: nadie edita una `.tscn` ajena sin avisar (evita conflictos de merge).
- **Un responsable por fase** del plan (`docs/planning/`).

## Rutas de carpetas
| Ruta | Contenido |
|---|---|
| `src/` | Escenas y scripts, por sistema (`player`, `creatures`, `combat`, ...) |
| `src/autoload/` | Singletons globales |
| `assets/` | Recursos importados al juego (sprites, audio, fuentes, shaders, UI) |
| `data/` | Datos del juego (cultivos, criaturas, niveles, oleadas, códice) |
| `art_source/` | Archivos fuente de arte; Godot los ignora (`.gdignore`) |
| `docs/` | Documentación; Godot la ignora (`.gdignore`) |
| `addons/` | Plugins |

## Proyecto
- Resolución base 480×270, ventana 1920×1080, stretch `viewport`, escala entera, filtro `Nearest`.
- Capas de física 2D: `player`, `creatures`, `walls`, `crops`, `animals`, `interactables`, `hitbox`, `hurtbox`.
- Acciones de entrada: `move_up/down/left/right`, `interact`, `attack`, `cycle_tool`, `pause`.
