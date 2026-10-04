# Planeación del prototipo — Fase 1: Núcleo jugable

Continúa [planeacion_fase0.md](planeacion_fase0.md): mismo equipo, mismo calendario, supuestos 1 a 18 y tabla de fases. Este archivo agrega los supuestos 19 a 35 y el plan detallado de la Fase 1 (ISS-08 a ISS-25).

| Día | D2 | D3 | D4 |
|---|---|---|---|
| Fecha | mié 30/09 | jue 01/10 | vie 02/10 |

---

## 1. Supuestos (continuación)

19. **Calendario real.** Las fechas se calculan desde FECHA_INICIO (D2 a D4 = 30/09 al 02/10). El equipo confirma que va atrasado: la Fase 0 se fusionó entre el 01/10 y el 03/10. Si se recorre el calendario, todas las fechas se mueven los mismos días y la tabla de carga no cambia.
20. **Números de GitHub.** Los issues y sus dependencias se identifican por su ID del plan (ISS-08 a ISS-25), que va en el cuerpo del issue. El número que asigne GitHub puede no coincidir y no se ajusta.
21. **Ramas.** Como en la Fase 0, los PR van a `develop` (supuesto 8). La rama lleva el número de GitHub: `feat/13-movimiento-ya-ax`.
22. **Quién integra.** P1 coloca sus entidades en `milpa.tscn` (Ya'ax, albarradas y corral). P2 coloca los sistemas en `level_01.tscn` (ciclo, parcelas, oleadas y HUD) y ahí instancia el resumen del amanecer de P4 (ISS-24). Nadie edita la escena de otro. No hay issue de integración: el hito se comprueba con la lista del final de esta fase al revisar el último PR del D4.
23. **Grupos y equipos de daño.** Los sistemas se encuentran por grupos: `player`, `crops` (solo parcelas sembradas), `animals`, `walls`, `creatures` y `day_cycle`. Las hurtboxes de cultivos, pavos, albarradas y antorchas usan el equipo `PLAYER`, así la lanza no las daña (regla de `HitboxComponent`).
24. **Estado del mundo y derrota.** ISS-10 agrega `GameState.world`, un diccionario que `snapshot()` copia en profundidad. Parcelas, pavos y albarradas guardan ahí su estado y lo leen al cargarse. Al morir Ya'ax se llama a `restore()` y se recarga la escena, así que el día se repite (supuesto 15) desde la Fase 1.
25. **Cambios de recursos.** Todo cambio de agua, cacao o inventario pasa por `GameState.use_water()`, `add_cacao()` y `add_item()` (ISS-10), que emiten la señal. `cacao_changed` e `inventory_changed` envían el total nuevo, no la diferencia.
26. **Acciones por fase.** Sembrar, regar, cosechar, alimentar pavos y reparar albarradas solo funcionan en la Mañana. Las antorchas se colocan en la Tarde o el Atardecer (GDD §7).
27. **Datos sin deseables ni jefe.** ISS-13 no crea Wáay Kot, colmena, estatua de báalam ni miel (eso es ISS-33). Las noches 3 y 4 usan Wáay Pek' en lugar de Wáay Kot (GDD §6) y la noche 5 no trae jefe; el issue del jefe (Fase 2) lo agrega.
28. **Tarde provisional.** La Tarde muestra un panel con los tres sitios; cualquier botón cierra la fase (ISS-24). El mapa regional, el mercado y el templo llegan en la Fase 2.
29. **Antorchas.** El GDD no dice cuánto duran. Se asume que se apagan al amanecer y no se guardan. Se revisa en ISS-52.
30. **IA sin rutas.** El Wáay Pek' camina en línea recta hacia el objetivo más cercano y golpea la albarrada que lo bloquea (GDD §6). No se usa `NavigationAgent2D`.
31. **Arte de la fase.** P3 entrega en versión final lo que más se ve en un día: tileset, Ya'ax, Wáay Pek' y golpe de lanza. Cultivos, pavo, albarrada, antorcha e íconos finales pasan a la Fase 2. `turkey_feather` no tiene ícono placeholder; se agrega con el arte de interfaz de la Fase 2.
32. **P4 y el resumen del amanecer.** Igual que en el supuesto 13, P4 arma con IA una pieza de presentación que solo escucha señales y lee `GameState`: el resumen del amanecer (ISS-18). Si no queda lista el D3, ISS-24 instancia la versión parcial y lo que falte se registra como bug en la Fase 2.
33. **Orden de IDs.** El orden de los IDs respeta las dependencias. ISS-19 (D4) conserva el número que ya cita la Fase 0, por eso va antes que ISS-20 (D3).
34. **Jefe: Gran Wáay Pek'.** Se elige la opción más barata: el jefe de la noche 5 es el Gran Wáay Pek', con el sprite del Wáay Pek' escalado (ISS-25), más vida y un patrón de ataque propio. Su id es `gran_waay_pek`. Kisin sigue siendo el señor de Metnal que envía a los wáay, pero no aparece en pantalla. Así no hace falta arte nuevo para el jefe. Ya están actualizados el GDD (v0.3: §6, §10, §11 y §12) y el glosario.
35. **Mercado en la plaza.** Se elige la opción más barata: el mercado es la plaza del mapa regional, una pantalla que se abre desde su botón. No hay mercado en la casa de la milpa, así que no hace falta un interactuable ni un recorrido. Ya están actualizados el GDD (§1 y §8) y el glosario.

---

## 3. Plan detallado por fase (continuación)

### Fase 1 — Núcleo jugable (D2–D4, 2026-09-30 al 2026-10-02)

**Objetivo:** se juega un día completo con placeholders: mañana en la milpa (sembrar, regar, cosechar, pavos, reparar), tarde provisional, atardecer con defensas, noche con Wáay Pek' y lanza, y amanecer con resumen en numeración maya.
**Inicio:** 2026-09-30 · **Fin:** 2026-10-02 · **Milestone:** `Fase 1 — Núcleo jugable` (vence 2026-10-02)
**Hito:** un día completo jugable con placeholders (lista de comprobación al final de esta sección).

#### ISS-08 · [Jugador] Implementar el movimiento en 8 direcciones de Ya'ax

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-30 (D2, primera tarea del día)
- **Dependencias:** ISS-04, ISS-06, ISS-07
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:player` `prioridad:mvp` `rol:juego`

**Descripción.** Crea a Ya'ax como `CharacterBody2D` que se mueve en 8 direcciones con velocidad constante, con animaciones por dirección y vida propia. Es el personaje con el que se juegan todas las fases del día; sin él no se puede probar ningún otro sistema de la milpa.

**Entrega esperada.**
- `src/player/player.tscn`: `CharacterBody2D` en la capa `player` con máscara `walls`, colisión en los pies, `AnimatedSprite2D` con `assets/sprites/characters/ya_ax.png` (cuadros de 16×24), `HealthComponent`, `HurtboxComponent` (equipo `PLAYER`) y grupo `player`.
- `src/player/player.gd`:
  - `@export` `move_speed` (80), `max_health` (100) e `invulnerability_time` (0.5).
  - Movimiento con `Input.get_vector()` y variable `facing` con la última dirección (la usan la lanza y las antorchas).
  - Animaciones `idle`, `walk_down`, `walk_up`, `walk_side` (volteada con `flip_h` hacia la izquierda), `hurt` y `die`.
  - Al morir emite `EventBus.player_died` una vez y bloquea el control.
- `milpa.tscn`: instancia de Ya'ax en el marcador `player_start`. La `Camera2D` existente pasa a ser hija de Ya'ax y conserva sus límites.

**Limitaciones.**
- No incluye herramientas ni interacción (ISS-09) ni ataque (ISS-15).
- No reinicia el día: solo emite la señal; el reinicio lo hace ISS-10.
- Arte placeholder; el final llega en ISS-20 sin tocar la escena.

**Criterios de aceptación.**
- [ ] En `milpa.tscn` (F6), Ya'ax se mueve en 8 direcciones con WASD y con flechas, y en diagonal avanza los mismos px/s que en línea recta.
- [ ] No atraviesa los bordes ni las rocas de la capa `walls`.
- [ ] Usa `walk_down`, `walk_up` o `walk_side` según la dirección, `walk_side` se voltea hacia la izquierda y vuelve a `idle` al soltar las teclas.
- [ ] La cámara sigue a Ya'ax y nunca muestra nada fuera de los 640×384 px del mapa.
- [ ] `move_speed`, `max_health` e `invulnerability_time` son `@export` con 80, 100 y 0.5 (GDD §12).
- [ ] Con una `HitboxComponent` de equipo `ENEMY` en la escena de prueba, Ya'ax reproduce `hurt`; al llegar a 0 de vida reproduce `die`, emite `player_died` una sola vez y deja de moverse.

---

#### ISS-09 · [Jugador] Implementar las herramientas y la interacción de Ya'ax

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-30 (D2, después de ISS-08)
- **Dependencias:** ISS-05, ISS-08
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:player` `area:milpa` `prioridad:mvp` `rol:juego`

**Descripción.** Da a Ya'ax una herramienta activa que se cambia con Q (lanza, cántaro, semillas y antorcha de copal) y muestra sobre su cabeza qué hará E junto a cada objeto. Los sistemas de la milpa no leen el teclado: reciben `interacted(actor)` y consultan `actor.active_tool`.

**Entrega esperada.**
- `src/player/player.gd`:
  - `active_tool: StringName` con la lista fija `[&"spear", &"water_jar", &"maize_seed", &"beans_seed", &"squash_seed", &"copal_torch"]`.
  - `cycle_tool` avanza a la siguiente herramienta y salta las semillas con 0 unidades en `GameState.inventory`.
  - Señal `tool_changed(tool_id: StringName)`.
- `src/player/player.tscn`: `Area2D` `InteractionSensor` (máscara `interactables`), `Label` `InteractionPrompt` con el `prompt_text` del interactuable en el que está Ya'ax y animación `use_tool` al pulsar E dentro de un interactuable.

**Limitaciones.**
- No implementa el efecto de cada herramienta: sembrar, regar y cosechar (ISS-17), colocar antorchas (ISS-21), alimentar pavos (ISS-22) ni atacar (ISS-15).
- El ícono de la herramienta lo dibuja el HUD (ISS-24); aquí solo se emite la señal.
- Sin honda (deseable, Fase 2).

**Criterios de aceptación.**
- [ ] Q recorre las herramientas en el orden de la lista y vuelve a la primera; cada cambio emite `tool_changed` con el id correcto.
- [ ] Con 0 `beans_seed` en el inventario, Q salta `beans_seed`.
- [ ] Junto a un `InteractableComponent` aparece su `prompt_text` sobre Ya'ax y desaparece al alejarse.
- [ ] Al pulsar E dentro de un interactuable de prueba, este recibe `interacted` con Ya'ax como actor, imprime `actor.active_tool` y Ya'ax reproduce `use_tool`.

---

#### ISS-10 · [Ciclo] Implementar el ciclo de fases del día

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-30 (D2, primera tarea del día)
- **Dependencias:** ISS-05, ISS-07
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:milpa` `area:criaturas` `prioridad:mvp` `rol:sistemas`

**Descripción.** Controla el paso Mañana → Tarde → Atardecer → Noche → Amanecer con las duraciones de `level_01.tres` y avisa cada cambio por `EventBus`. También arranca la partida desde `LevelData`, rellena el agua y guarda la copia del día al amanecer, y repite el día cuando muere Ya'ax. Todos los sistemas de la Fase 1 dependen de estas señales.

**Entrega esperada.**
- `src/day_cycle/day_cycle.gd` (nodo con `@export var level: LevelData`, grupo `day_cycle`):
  - Un `Timer` con la duración de cada fase; emite `phase_changed` en cada cambio y `day_started(day)` en cada Mañana.
  - En el Amanecer rellena el agua a `max_water`; al terminar, suma un día, pasa a la Mañana y llama a `GameState.snapshot()`.
  - En la noche `boss_night`, la Noche termina con `wave_cleared` en lugar del temporizador.
  - `time_left() -> float` y `advance_phase()` públicos, para el HUD, el panel de la Tarde y la tecla de depuración.
  - Al recibir `player_died`: `GameState.restore()` y `get_tree().reload_current_scene()`.
- Acción `debug_skip_phase` (F2) en `project.godot`; solo funciona si `OS.is_debug_build()`.
- `src/autoload/game_state.gd`:
  - `level: LevelData` y `world: Dictionary` (estado de parcelas, pavos y albarradas; `snapshot()` lo copia en profundidad).
  - `start_level(level)`: día 1, Mañana, agua llena, cacao e inventario iniciales, `world` vacío y primer `snapshot()`.
  - `add_item(id, delta)`, `add_cacao(delta)` y `use_water(amount)`: devuelven `false` si el resultado sería negativo; si no, cambian el valor y emiten `inventory_changed`, `cacao_changed` o `water_changed` con el total nuevo.
- `src/autoload/game_state_check.gd`: casos nuevos para los tres helpers y para `world`.
- `src/levels/level_01_dzibilchaltun/level_01.tscn`: instancia `milpa.tscn` y el nodo `DayCycle` con `data/levels/level_01.tres`.
- `src/main.tscn` instancia `level_01.tscn` (provisional hasta el flujo del nivel de la Fase 3).

**Limitaciones.**
- La Tarde es solo un temporizador; el panel provisional lo agrega ISS-24 y el mapa regional llega en la Fase 2.
- No hace crecer cultivos ni alimenta pavos: cada sistema escucha `phase_changed`.
- Tras el Amanecer del último día, el ciclo se detiene; el ritual y el final son de la Fase 3.
- Sin guardado en disco.

**Criterios de aceptación.**
- [ ] Con `level_01.tres`, las fases duran 100, 70, 30, 110 y 20 s (±0.5 s), en ese orden, y cada cambio emite `phase_changed` una sola vez.
- [ ] Al cambiar una duración en `level_01.tres`, el ciclo la usa sin tocar código.
- [ ] Cada Mañana emite `day_started` con el día correcto y `GameState.day` coincide.
- [ ] Al llegar el Amanecer, `GameState.water` vuelve a `max_water` y se emite `water_changed`.
- [ ] Al ejecutar desde el editor, F2 pasa a la fase siguiente.
- [ ] Si se emite `player_died` en la Noche del día 2, la escena se recarga en la Mañana del día 2 con el agua, el cacao, el inventario y `world` del snapshot.
- [ ] `game_state_check.gd` pasa completo, incluido el caso `add_item(&"maize", -10)` con 6 de maíz, que devuelve `false` y no cambia el inventario.
- [ ] F5 abre `level_01` desde `main.tscn` sin errores.

---

#### ISS-11 · [Arte] Dibujar el tileset final de la milpa

- **Responsable:** P3, arte (@Pao-Parra)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-09-30 (D2)
- **Dependencias:** ISS-04, ISS-07
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:arte` `area:mapas` `area:milpa` `prioridad:mvp` `rol:arte`

**Descripción.** Sustituye el placeholder de colores planos por el arte final del suelo y los obstáculos de la milpa: tierra roja y pedregosa del norte de Yucatán, tierra de cultivo, monte bajo y laja caliza. Como respeta la misma rejilla y las mismas celdas, `milpa.tscn` muestra el arte nuevo sin cambios.

**Entrega esperada.**
- `assets/tilesets/milpa.png`: 64×32 px. Las 4 celdas de la fila 0 (suelos) y las 2 de la fila 1 (obstáculos con colisión) conservan el uso que tienen en el placeholder.
- `art_source/tilesets/milpa.<ext>`: archivo editable con capas.

**Limitaciones.**
- No edita `milpa_tileset.tres` ni `milpa.tscn` (son de P1). No agrega celdas nuevas; las variantes quedan para la Fase 2.
- Sin tiles animados.
- Solo colores de la paleta. Nada ajeno a la época: alambre, postes, herramientas de metal ni plantas llegadas con los españoles (glosario §3.3).

**Criterios de aceptación.**
- [ ] `milpa.png` mide 64×32 y cada celda de 16×16 conserva el uso del placeholder.
- [ ] Solo usa colores de `docs/art_guide/paleta.png`.
- [ ] Tras reemplazar la imagen y abrir `milpa.tscn`, git no muestra cambios en `milpa.tscn` ni en `milpa_tileset.tres`.
- [ ] Al ejecutar `milpa.tscn` (F6), Ya'ax sigue chocando con las mismas rocas que antes.
- [ ] Existe `art_source/tilesets/milpa.<ext>` con el mismo nombre que el PNG.

---

#### ISS-12 · [Numeración] Implementar la conversión y el control de numeración maya

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-30 (D2)
- **Dependencias:** ISS-04, ISS-05
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:numeracion` `area:ui` `prioridad:mvp` `rol:sistemas`

**Descripción.** Convierte enteros a numeración maya vigesimal (concha = 0, punto = 1, barra = 5) y los dibuja con los glifos de `assets/ui/maya_numerals/`. Es la pieza que usan el HUD, el resumen del amanecer, el mercado y el códice para mostrar cualquier número. En el tutorial muestra también el número arábigo.

**Entrega esperada.**
- `src/maya_numerals/maya_numeral.gd` (`class_name MayaNumeral`, funciones estáticas): `to_digits(n) -> Array[int]` (base 20, de la posición mayor a la menor) y `digit_parts(d) -> Vector2i` (barras, puntos).
- `src/maya_numerals/maya_number.tscn` y `.gd` (`Control`): `@export var value: int`. Apila los niveles de arriba (mayor) hacia abajo; en cada nivel van los puntos arriba de las barras, o una concha si el dígito es 0. Ocupa una columna de 16 px y muestra el número arábigo debajo cuando `GameState.tutorial_active` es `true`.
- `src/maya_numerals/maya_numeral_check.gd`: verificación con `assert`, ejecutable con `--script`, igual que `game_state_check.gd`.

**Limitaciones.**
- Solo enteros mayores o iguales a 0; un negativo produce `push_error` y se dibuja 0.
- No incluye el armado del pago con fichas del mercado (Fase 2).
- Sin animaciones.

**Criterios de aceptación.**
- [ ] `maya_numeral_check.gd` pasa: 0 → [0], 7 → [7], 19 → [19], 20 → [1, 0], 45 → [2, 5], 400 → [1, 0, 0]; y `digit_parts(19)` = 3 barras y 4 puntos.
- [ ] En una escena de prueba, 0 se ve como una concha, 7 como 1 barra con 2 puntos encima y 20 como dos niveles: un punto arriba y una concha abajo.
- [ ] Cambiar `value` mientras corre el juego redibuja el número.
- [ ] Con `GameState.tutorial_active = true` se ve el número arábigo debajo; con `false`, no.
- [ ] Los glifos usan `dot.png`, `bar.png` y `shell.png` a escala 1, sin suavizado.

---

#### ISS-13 · [Diseño] Crear los recursos .tres con los valores del GDD

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-30 (D2)
- **Dependencias:** ISS-02, ISS-05
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:config` `area:milpa` `area:criaturas` `area:economia` `prioridad:mvp` `rol:diseno`

**Descripción.** Llena desde el inspector de Godot todos los `.tres` del MVP con los valores de la tabla del GDD §12. Así los sistemas de la Fase 1 leen datos reales desde el D3 y P4 puede balancear sin tocar código.

**Entrega esperada.**
- `data/crops/beans.tres` y `data/crops/squash.tres`.
- `data/items/`: `beans`, `squash`, `maize_seed`, `beans_seed`, `squash_seed`, `saka`, `copal` y `turkey_feather` (`.tres`). El `icon` se asigna desde `assets/ui/icons/` en los 8 ítems que tienen ícono, incluido el `maize.tres` que ya existe.
- `data/defenses/copal_torch.tres`.
- `data/waves/wave_02.tres` a `wave_05.tres`.
- `data/levels/level_01.tres` con las 5 oleadas en `waves`.
- Revisión de los `.tres` existentes (`maize`, `turkey`, `waay_pek`, `albarrada`) contra el GDD.

**Limitaciones.**
- Sin deseables ni jefe (supuesto 27): `wave_03` lleva 6 Wáay Pek', `wave_04` lleva 8 y `wave_05` lleva 4.
- `turkey_feather` queda sin ícono (supuesto 31).
- No cambia valores del GDD. Si encuentra un error, primero lo corrige en `docs/design/gdd.md` y lo indica en el PR.
- Los archivos se crean desde el inspector, no editando el texto a mano.

**Criterios de aceptación.**
- [ ] Existen los 15 archivos nuevos y cada uno abre en el inspector sin errores.
- [ ] Cada valor coincide con la tabla del GDD §12; el PR trae una casilla marcada por archivo revisado.
- [ ] `level_01.tres` tiene en `waves` 5 elementos, de `wave_01` a `wave_05`, en orden.
- [ ] Cada `id` está en minúsculas, sin acentos ni apóstrofos, y coincide con el nombre de su archivo.
- [ ] Los precios que el GDD marca con "—" valen 0.

---

#### ISS-14 · [Narrativa] Escribir el guion y los textos del juego

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-30 (D2)
- **Dependencias:** ISS-02, ISS-03
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:docs` `area:narrativa` `area:cultura` `prioridad:mvp` `rol:diseno`

**Descripción.** Redacta todos los textos que verá el jugador en el nivel 1: intro, avisos de fase, interfaz, tutorial, sitios de los mapas, diálogos del mercado y del templo, y los dos finales. Con él, la Fase 2 arma la intro, los mapas y el fin sin inventar textos, y el hablante revisa todo junto en ISS-41.

**Entrega esperada.**
- `docs/design/guion.md` con 9 secciones:
  1. Intro: 3 tarjetas, una por ilustración (`intro_01` a `intro_03`), de 2 oraciones como máximo cada una.
  2. Avisos de fase (Mañana, Tarde, Atardecer, Noche, Amanecer y noche del jefe).
  3. Interfaz: nombres visibles de herramientas, ítems, botones y filas del resumen del amanecer.
  4. Tutorial: de 6 a 10 pasos.
  5. Mapa del mundo: Dzibilchaltún y las tres ciudades bloqueadas, una oración cada una.
  6. Mapa regional: cenote Xlacah, plaza y Templo de las Siete Muñecas, de 1 a 2 oraciones cada uno.
  7. Mercado y templo: hasta 5 líneas de diálogo cada uno.
  8. Finales: con lluvia, sin lluvia y pantalla de fin del prototipo.
  9. Lista de términos mayas usados, con la marca "revisar con hablante".
- `data/levels/tutorial_01.tres` con los pasos del tutorial en `steps`.

**Limitaciones.**
- No incluye el códice (ISS-19) ni implementa la intro, el tutorial o los finales.
- Textos en español con términos mayas del glosario. Si hace falta un término nuevo, se agrega al glosario con su fuente en este mismo issue.
- Máximo 40 caracteres por línea en textos de interfaz y avisos, para que quepan en 480 px.

**Criterios de aceptación.**
- [ ] `guion.md` tiene las 9 secciones y la intro tiene exactamente 3 tarjetas de 2 oraciones como máximo.
- [ ] `tutorial_01.tres` tiene en `steps` los mismos pasos que la sección 4.
- [ ] Cada término maya del guion aparece en `docs/culture/glosario.md` con la misma grafía.
- [ ] Buscar "nahual", "Xibalbá", "tres hermanas", "gallina", "cerdo", "vaca", "chivo" y "caballo" en `guion.md` no da resultados.
- [ ] Ninguna línea de las secciones 2 y 3 pasa de 40 caracteres.

---

#### ISS-15 · [Combate] Implementar el ataque con lanza

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-10-01 (D3)
- **Dependencias:** ISS-08, ISS-09
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:combate` `area:player` `prioridad:mvp` `rol:juego`

**Descripción.** Ya'ax ataca con la lanza hacia donde mira al pulsar J o clic izquierdo. El golpe es una `HitboxComponent` del equipo `PLAYER`: daña a las criaturas, pero no a Ya'ax, ni a pavos, cultivos o albarradas. Es la única arma del MVP para defender la milpa de noche.

**Entrega esperada.**
- `src/combat/weapons/spear.tscn` y `spear.gd`: `HitboxComponent` (equipo `PLAYER`) que se activa unos 0.15 s a `range` px de Ya'ax en la dirección `facing`. `@export` `damage` (25), `range` (24) y `cooldown` (0.6). Efecto `assets/sprites/effects/spear_slash.png` (4 cuadros) girado según la dirección.
- `src/player/player.tscn`: instancia la lanza; `attack` la usa y reproduce la animación `attack` de Ya'ax.

**Limitaciones.**
- Sin honda (deseable, Fase 2), combos ni empuje.
- Sin sonido; el audio se conecta en la Fase 2.
- Arte placeholder; el efecto final llega en ISS-25.

**Criterios de aceptación.**
- [ ] Con J o clic izquierdo, una criatura de prueba (hurtbox `ENEMY`, 50 de vida) frente a Ya'ax pierde exactamente 25.
- [ ] Una criatura de prueba detrás de Ya'ax o a más de 24 px no pierde vida.
- [ ] Pulsando `attack` sin parar, el objetivo no recibe más de un golpe cada 0.6 s.
- [ ] Una hurtbox de equipo `PLAYER` frente a Ya'ax no pierde vida.
- [ ] El efecto aparece en la dirección del ataque en las 8 direcciones.
- [ ] `damage`, `range` y `cooldown` son `@export` en `spear.tscn` con los valores del GDD §12.

---

#### ISS-16 · [Criaturas] Implementar la criatura base y la IA del Wáay Pek'

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-10-01 (D3)
- **Dependencias:** ISS-06, ISS-08, ISS-10
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:criaturas` `area:combate` `prioridad:mvp` `rol:juego`

**Descripción.** Crea la criatura nocturna que lee su `CreatureData`: busca el objetivo más cercano (pavo, cultivo sembrado o Ya'ax), camina hacia él y lo ataca; si una albarrada le cierra el paso, la golpea hasta romperla. Al morir suelta cacao y al terminar la noche se retira. El Wáay Kot y el jefe reutilizan la misma base cambiando solo datos y sprite.

**Entrega esperada.**
- `src/creatures/base/creature.gd` (`class_name Creature`, sobre `CharacterBody2D`):
  - `@export var data: CreatureData`; capa `creatures`, máscara `walls` (sin `walls` si `data.flies` es `true`); grupo `creatures`.
  - `HealthComponent` con `data.max_health`, `HurtboxComponent` (equipo `ENEMY`) e `HitboxComponent` (equipo `ENEMY`, `data.damage`) que se activa a `attack_range` cada `attack_cooldown`.
  - Objetivo: el nodo más cercano de los grupos `animals`, `crops` y `player`. Si choca con un nodo del grupo `walls`, lo ataca.
  - Al morir: `GameState.add_cacao(randi_range(cacao_drop_min, cacao_drop_max))`, `EventBus.creature_killed(data.id)` y desaparece.
  - Si `phase_changed` llega con una fase distinta de la Noche, deja de atacar, camina al marcador `creature_spawns` más cercano y desaparece.
- `src/creatures/waay_pek/waay_pek.tscn`: usa la base con `data/creatures/waay_pek.tres` y `AnimatedSprite2D` con `waay_pek.png` (32×32: `idle`, `walk`, `attack`, `hurt`).
- `src/creatures/creature_test.tscn`: escena de prueba con un pavo, un cultivo y una albarrada falsos (nodos con `HealthComponent` y hurtbox `PLAYER` en sus grupos).

**Limitaciones.**
- Sin búsqueda de rutas (supuesto 30).
- No hace aparecer criaturas (ISS-23).
- Sin Wáay Kot ni jefe (Fase 2); solo se deja lista la opción `flies`.

**Criterios de aceptación.**
- [ ] En `creature_test.tscn`, el Wáay Pek' va hacia el objetivo más cercano de `animals`, `crops` o `player`, y a 24 px o menos le quita 10 de vida cada 1.5 s.
- [ ] Si la albarrada falsa le cierra el paso, la ataca hasta dejarla en 0 y luego sigue hacia su objetivo.
- [ ] Con 2 golpes de lanza muere: emite `creature_killed(&"waay_pek")` una vez, `GameState.cacao` sube entre 3 y 6 y la criatura desaparece.
- [ ] Al emitir `phase_changed` con el Amanecer, deja de atacar, camina al `creature_spawns` más cercano y desaparece.
- [ ] Al cambiar `move_speed` o `damage` en `waay_pek.tres`, el comportamiento cambia sin tocar código.
- [ ] Con `flies = true` en un `.tres` de prueba, la criatura atraviesa la albarrada.

---

#### ISS-17 · [Milpa] Implementar parcelas con siembra, riego, crecimiento y cosecha

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-10-01 (D3)
- **Dependencias:** ISS-09, ISS-10, ISS-13
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:milpa` `prioridad:mvp` `rol:sistemas`

**Descripción.** Cada marcador `plots` de la milpa se vuelve una parcela donde Ya'ax siembra maíz, frijol o calabaza, la riega con agua limitada y la cosecha cuando madura. Al amanecer, las parcelas regadas avanzan un día y las que pasan `wither_days` sin agua se secan. Es el centro de la Mañana y la fuente de la ofrenda.

**Entrega esperada.**
- `src/milpa/crops/plot.tscn` y `plot.gd`:
  - `InteractableComponent` con `prompt_text` según el estado (Sembrar, Regar o Cosechar), `Sprite2D` con la hoja del cultivo (`hframes = 4`), y `HealthComponent` y `HurtboxComponent` (equipo `PLAYER`) activos solo si hay cultivo. Está en el grupo `crops` solo mientras tiene cultivo.
  - Sembrar: con `<cultivo>_seed` activa en una parcela vacía → `add_item(semilla, -1)` y `crop_planted`.
  - Regar: con `water_jar`, si está sembrada y no se regó hoy → `use_water(water_per_day)`.
  - Cosechar: si está madura (`growth >= growth_days`), con cualquier herramienta → `add_item(cultivo, randi_range(yield_min, yield_max))`, `crop_harvested` y la parcela queda vacía.
  - Amanecer: si se regó, `growth + 1`; si no, `dry_days + 1`, y con `dry_days >= wither_days` la parcela queda vacía.
  - Cuadro visible: `floor(growth × 3 / growth_days)` (semilla, brote, planta, madura).
  - Con vida 0, la parcela queda vacía.
- `src/milpa/crops/plot_manager.gd`: nodo en `level_01.tscn` que crea un `plot.tscn` en cada marcador `plots` y guarda y lee el estado en `GameState.world[&"plots"]`.

**Limitaciones.**
- Las acciones solo funcionan en la Mañana (supuesto 26).
- Sin la travesura de los aluxes (Fase 2).
- Arte placeholder; los valores se balancean en ISS-52.

**Criterios de aceptación.**
- [ ] Con `maize_seed` activa y 5 semillas, E en una parcela vacía siembra maíz y deja 4 semillas; sin semillas no siembra.
- [ ] Regar maíz baja `GameState.water` exactamente 10; regarlo otra vez el mismo día no gasta agua; con menos de 10 de agua no se riega.
- [ ] Un maíz regado los días 1, 2 y 3 se cosecha en la Mañana del día 4, suma entre 3 y 5 `maize` y la parcela queda vacía.
- [ ] Un cultivo sin riego durante 2 amaneceres seguidos se seca y la parcela queda vacía.
- [ ] El cuadro del cultivo cambia al amanecer según su crecimiento.
- [ ] Fuera de la Mañana, E sobre una parcela no hace nada.
- [ ] Un golpe de criatura que deja el cultivo en 0 vacía la parcela.
- [ ] Tras `player_died` y la recarga, cada parcela vuelve al estado del snapshot.
- [ ] Al cambiar `growth_days` en `beans.tres`, el frijol tarda los días nuevos sin tocar código.

---

#### ISS-18 · [UI] Crear la pantalla del resumen del amanecer

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-10-01 (D3)
- **Dependencias:** ISS-10, ISS-12, ISS-14
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:ui` `area:numeracion` `prioridad:mvp` `rol:diseno`

**Descripción.** Al llegar el Amanecer muestra, en numeración maya, lo que pasó en el día: cosecha, wáay derrotados, pavos perdidos, cacao y agua usada. Cierra el bucle del día y hace que el jugador lea números mayas desde el primer día. Es una pieza de presentación: solo escucha `EventBus` y lee `GameState` (supuesto 32).

**Entrega esperada.**
- `src/ui/day_summary/day_summary.tscn` y `.gd` (`CanvasLayer`):
  - Acumula en `GameState.day_stats` las claves `harvested`, `creatures_killed`, `animals_lost`, `water_used` y `cacao_earned` a partir de `crop_harvested`, `creature_killed`, `animal_died`, `water_changed` y `cacao_changed`; todo vuelve a 0 con `day_started`.
  - Con `phase_changed` en el Amanecer muestra un panel con el título y el número del día y una fila por dato (ícono + `MayaNumber` de ISS-12). Se oculta al empezar la Mañana.
  - Textos tomados de `guion.md` (secciones 2 y 3).
- `src/ui/day_summary/day_summary_test.tscn`: escena de prueba con botones que emiten señales falsas.

**Limitaciones.**
- No detiene ni avanza el ciclo; el Amanecer dura lo que marca `level_01.tres`.
- No se instancia en `level_01.tscn`: eso lo hace P2 en ISS-24.
- Sin animaciones ni sonido; íconos placeholder.

**Criterios de aceptación.**
- [ ] En la escena de prueba, tras emitir `crop_harvested(&"maize", 4)` dos veces, `creature_killed` tres veces y `animal_died` una vez, al emitir el Amanecer el panel muestra 8, 3 y 1 en numeración maya.
- [ ] El número del día aparece en numeración maya en el título.
- [ ] Al emitir `day_started`, todos los valores de `GameState.day_stats` vuelven a 0.
- [ ] El panel se oculta al emitir `phase_changed` con la Mañana.
- [ ] Con `tutorial_active = true`, cada número también se ve en arábigo.
- [ ] Los textos del panel son los de `guion.md`.
- [ ] El script solo usa `EventBus` y `GameState`: no tiene rutas a nodos de otros sistemas.

---

#### ISS-19 · [Códice] Redactar las 10 entradas del códice

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-10-02 (D4)
- **Dependencias:** ISS-03, ISS-05
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:investigacion` `area:codice` `area:cultura` `prioridad:mvp` `rol:diseno`

**Descripción.** Escribe 10 entradas breves de información cultural verificada que el jugador desbloquea en el nivel 1. Cada una cita fuentes de `docs/culture/fuentes.md` y usa la grafía del glosario. El sistema del códice (Fase 2) solo las muestra, y el hablante las revisa en ISS-41.

**Entrega esperada.**
- 10 archivos `data/codex/<id>.tres` (`CodexEntryData`), incluido `alux.tres` revisado. Lista propuesta: `kool` (milpa), `ixiim` (maíz), `waay`, `alux`, `kisin` (Kisin y Metnal), `cha_chaak` (Cháak, los cuatro rumbos y el Ch'a' Cháak), `maya_numerals`, `kakaw` (cacao como moneda), `uulum` (pavo) y `tsiibil_chaaltun` (Dzibilchaltún y el cenote Xlacah). P4 puede cambiar alguna si lo justifica en el PR.
- `docs/culture/codice.md`: tabla con id, título, evento de desbloqueo y fuentes.

**Limitaciones.**
- `meaning` de 60 a 120 palabras.
- No implementa la pantalla del códice ni el desbloqueo (Fase 2).
- Solo términos del glosario. Las entradas quedan "pendiente" hasta ISS-41.

**Criterios de aceptación.**
- [ ] Hay 10 `.tres` en `data/codex/` y todos abren sin errores en el inspector.
- [ ] Cada entrada tiene `term`, `pronunciation`, `meaning` de 60 a 120 palabras, `in_game_use` y al menos una fuente en `sources`.
- [ ] Cada clave de `sources` existe en `docs/culture/fuentes.md`.
- [ ] Cada `term` coincide con la grafía de `glosario.md`.
- [ ] En `codice.md`, cada entrada tiene como evento de desbloqueo una señal que ya existe en `event_bus.gd`.
- [ ] Buscar "nahual", "Xibalbá" y "tres hermanas" en `data/codex/` no da resultados.

---

#### ISS-20 · [Arte] Dibujar la hoja de sprites final de Ya'ax

- **Responsable:** P3, arte (@Pao-Parra)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-10-01 (D3)
- **Dependencias:** ISS-04, ISS-08
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:arte` `area:player` `prioridad:mvp` `rol:arte`

**Descripción.** Reemplaza el placeholder de Ya'ax con su arte final: un joven milpero maya hacia el año 900 d.C., con las 8 animaciones de la guía de estilo. Como conserva el tamaño y la distribución de cuadros, `player.tscn` lo muestra sin cambios.

**Entrega esperada.**
- `assets/sprites/characters/ya_ax.png`: 64×192, cuadros de 16×24, con `idle` 4, `walk_down` 4, `walk_up` 4, `walk_side` 4, `attack` 3, `use_tool` 3, `hurt` 2 y `die` 4.
- `art_source/characters/ya_ax.<ext>`.

**Limitaciones.**
- Ropa y objetos de la época: taparrabo y manta de algodón, sandalias y lanza con punta de pedernal. Nada de sombrero de ala, machete ni otras herramientas de metal, ni ropa con botones.
- No edita `player.tscn` ni cambia el orden de las filas.
- Solo colores de la paleta.

**Criterios de aceptación.**
- [ ] `ya_ax.png` mide 64×192, sin espacios entre cuadros, con una animación por fila en el orden de la guía.
- [ ] En las filas con menos de 4 cuadros, los sobrantes son transparentes.
- [ ] Solo usa colores de `paleta.png`.
- [ ] Al ejecutar `milpa.tscn`, cada animación muestra sus cuadros y git no muestra cambios en `player.tscn`.
- [ ] P4 aprueba en el PR que la ropa y la lanza no tienen elementos posteriores a la Conquista.
- [ ] Existe `art_source/characters/ya_ax.<ext>`.

---

#### ISS-21 · [Milpa] Implementar las albarradas y las antorchas de copal

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-10-02 (D4)
- **Dependencias:** ISS-09, ISS-10, ISS-13, ISS-16
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:milpa` `area:combate` `prioridad:mvp` `rol:juego`

**Descripción.** Las albarradas rodean la milpa y el corral, cierran el paso a los wáay y pierden vida cuando las golpean; en la Mañana, Ya'ax las repara pagando cacao. En la Tarde y el Atardecer, Ya'ax coloca antorchas de copal que queman a las criaturas cercanas durante la Noche. Son las dos defensas del MVP.

**Entrega esperada.**
- `src/milpa/defenses/albarrada.tscn` y `albarrada.gd`:
  - `StaticBody2D` en la capa `walls` y grupo `walls`; `HealthComponent` y `HurtboxComponent` (equipo `PLAYER`) con los datos de `albarrada.tres`.
  - Sprite de 3 cuadros: intacta (más de 50 %), dañada y destruida. Destruida no bloquea.
  - `InteractableComponent` "Reparar": solo en la Mañana, suma `repair_amount` y cobra `repair_cost` con `add_cacao()`.
  - Estado en `GameState.world[&"walls"]`.
- `milpa.tscn`: segmentos de albarrada que cierran la milpa y el corral, cada uno con una entrada de 1 tile.
- `src/milpa/defenses/copal_torch.tscn` y `copal_torch.gd`:
  - Con `copal_torch` activa, en la Tarde o el Atardecer, E fuera de un interactuable coloca una antorcha en el tile libre frente a Ya'ax si alcanza el cacao (`cost`).
  - En la Noche quita `damage_per_second` por segundo a cada criatura dentro de `radius`.
  - Se apaga al amanecer (supuesto 29).

**Limitaciones.**
- No se construyen albarradas nuevas; las que hay ya están colocadas (GDD §7).
- Sin estatua de báalam (deseable, Fase 2) ni efectos de luz.
- Arte placeholder.

**Criterios de aceptación.**
- [ ] Un Wáay Pek' que llega a una albarrada la golpea; por debajo de 75 de vida se ve dañada, en 0 se ve destruida y deja de bloquear.
- [ ] En la Mañana, E sobre una albarrada dañada con 2 o más de cacao suma 50 de vida (máximo 150) y resta 2 de cacao; fuera de la Mañana o sin cacao no hace nada.
- [ ] Ya'ax no atraviesa albarradas intactas y puede entrar y salir por las entradas de la milpa y del corral.
- [ ] En el Atardecer, con `copal_torch` activa y 12 o más de cacao, E en suelo libre coloca una antorcha y resta 12; en la Mañana, o sobre otra antorcha, no se coloca.
- [ ] Un Wáay Pek' quieto a menos de 64 px de una antorcha pierde 50 de vida en 10 s (±1 s) durante la Noche.
- [ ] Al amanecer, las antorchas desaparecen; tras `player_died`, las albarradas vuelven a la vida del snapshot.

---

#### ISS-22 · [Milpa] Implementar los pavos y el corral

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-10-02 (D4)
- **Dependencias:** ISS-09, ISS-10, ISS-16
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:milpa` `prioridad:mvp` `rol:juego`

**Descripción.** El corral empieza con 2 pavos que caminan dentro. Ya'ax los alimenta con maíz cada mañana y, si comen, dan plumas para la ofrenda y el mercado. Si pasan días sin comer escapan, y de noche los wáay los atacan.

**Entrega esperada.**
- `src/milpa/animals/turkey.tscn` y `turkey.gd`: `CharacterBody2D` en la capa `animals` y grupo `animals`, `HealthComponent` (30), `HurtboxComponent` (equipo `PLAYER`) y `AnimatedSprite2D` con `turkey.png` (`idle` 2, `walk` 4). Camina al azar dentro del corral.
- `src/milpa/animals/turkey_pen.tscn` y `turkey_pen.gd`, instanciado en `milpa.tscn` en el marcador `animal_pen`:
  - Crea `starting_turkeys` pavos con los datos de `data/animals/turkey.tres`.
  - `InteractableComponent` "Alimentar": solo en la Mañana, resta `feed_per_day` de `maize` por pavo y los marca como alimentados.
  - Amanecer: cada pavo alimentado da 1 `turkey_feather` cada `produce_interval` días; uno sin comer durante `days_unfed_to_escape` días escapa (desaparece).
  - Un pavo con vida 0 emite `animal_died(&"turkey")`.
  - Estado en `GameState.world[&"turkeys"]`.

**Limitaciones.**
- Sin colmena de meliponas (deseable, ISS-33).
- No se compran pavos nuevos y los pavos no salen del corral.
- Arte placeholder.

**Criterios de aceptación.**
- [ ] Al iniciar el nivel hay 2 pavos en el corral, el valor de `starting_turkeys` en `level_01.tres`.
- [ ] Con 6 de `maize`, E en el corral resta 2 y marca a los pavos como alimentados; una segunda vez el mismo día no resta nada; con menos de 2 de maíz no los alimenta.
- [ ] Si los pavos comen 2 días seguidos, en el segundo amanecer el inventario suma 1 `turkey_feather` por pavo.
- [ ] Un pavo que no come durante 2 amaneceres seguidos desaparece.
- [ ] Un Wáay Pek' que alcanza a un pavo lo mata en 3 golpes y se emite `animal_died(&"turkey")` una sola vez.
- [ ] Tras `player_died`, el número de pavos y sus contadores vuelven al snapshot.

---

#### ISS-23 · [Criaturas] Implementar el generador de oleadas nocturnas

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-10-02 (D4, primera tarea del día)
- **Dependencias:** ISS-10, ISS-13, ISS-16
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:criaturas` `prioridad:mvp` `rol:sistemas`

**Descripción.** Al empezar la Noche, lee la oleada del día en `level_01.tres` y hace aparecer las criaturas en los marcadores `creature_spawns`, una cada `spawn_interval` segundos. Avisa el inicio y el fin de la oleada, que usan el ciclo (noche del jefe), el HUD y el audio.

**Entrega esperada.**
- `src/waves/wave_spawner.gd` (nodo en `level_01.tscn`):
  - `@export var creature_scenes: Dictionary[StringName, PackedScene]`, con `waay_pek` → `waay_pek.tscn`.
  - Con `phase_changed` en la Noche emite `wave_started(day)` y crea las criaturas de `level.waves[day - 1]` en un marcador `creature_spawns` al azar, una cada `spawn_interval`.
  - Emite `wave_cleared(day)` cuando ya aparecieron todas y no queda ninguna viva.
  - Si un id no tiene escena, muestra `push_warning` y lo salta.

**Limitaciones.**
- La retirada al amanecer la hace cada criatura (ISS-16).
- Sin jefe, Wáay Kot ni bendición de los aluxes (Fase 2).

**Criterios de aceptación.**
- [ ] En la Noche 1 aparecen exactamente 3 Wáay Pek', con 8 s (±0.5 s) entre una y otra, cada una en un marcador `creature_spawns`.
- [ ] En la Noche 2 aparecen 5, según `wave_02.tres`, sin cambiar código.
- [ ] Se emite `wave_started(n)` al empezar la Noche n y `wave_cleared(n)` cuando ya aparecieron todas y no queda ninguna viva.
- [ ] Si la Noche termina antes de que aparezcan todas, deja de crear criaturas.
- [ ] Un id sin escena registrada produce una advertencia y la oleada sigue con las demás.

---

#### ISS-24 · [UI] Implementar el HUD y la tarde provisional

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-10-02 (D4, después de ISS-23)
- **Dependencias:** ISS-09, ISS-10, ISS-12, ISS-14, ISS-18
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:feature` `area:ui` `area:numeracion` `area:mapas` `prioridad:mvp` `rol:sistemas`

**Descripción.** Muestra en pantalla, con numeración maya, lo que el jugador necesita para decidir: día, fase y tiempo restante, agua, cacao, vida de Ya'ax y herramienta activa. En la Tarde muestra un panel provisional con los tres sitios del mapa regional. Con este issue se instancia el resumen del amanecer y el día completo queda jugable.

**Entrega esperada.**
- `src/ui/hud/hud.tscn` y `hud.gd` (`CanvasLayer`):
  - Día (`MayaNumber`), nombre de la fase (texto de `guion.md`) y barra de tiempo restante (`time_left()` del nodo en el grupo `day_cycle`).
  - Agua (barra y `MayaNumber`), cacao (ícono y `MayaNumber`), vida de Ya'ax (barra) e ícono de la herramienta activa (`assets/ui/icons/`).
  - Se actualiza por señales: `EventBus`, `tool_changed` y `damaged` del nodo en el grupo `player`.
  - Panel de la Tarde con 3 botones (Cenote Xlacah, Plaza y Templo de las Siete Muñecas); cada uno llama a `advance_phase()`.
- `level_01.tscn`: instancias de `hud.tscn` y de `day_summary.tscn` (ISS-18).

**Limitaciones.**
- El panel de la Tarde no lleva a ningún sitio; solo cierra la fase (supuesto 28).
- Sin menú de pausa ni minimapa.
- Íconos y marcos placeholder.

**Criterios de aceptación.**
- [ ] Al regar, el agua del HUD baja en el mismo cuadro en que cambia `GameState.water`; al reparar una albarrada pasa lo mismo con el cacao.
- [ ] Todos los números del HUD están en numeración maya y, con `tutorial_active = true`, también en arábigo.
- [ ] La barra de tiempo llega a 0 cuando cambia la fase, y el nombre de la fase cambia con `phase_changed`.
- [ ] Q cambia el ícono de la herramienta activa.
- [ ] La barra de vida baja cuando un Wáay Pek' golpea a Ya'ax.
- [ ] En la Tarde aparece el panel con 3 botones y cualquiera pasa al Atardecer; en las demás fases el panel no se ve.
- [ ] Al amanecer aparece el resumen de ISS-18 dentro de `level_01`.
- [ ] El HUD ocupa como máximo una franja de 24 px arriba y otra de 24 px abajo de la pantalla de 480×270.

---

#### ISS-25 · [Arte] Dibujar el Wáay Pek' y el golpe de lanza finales

- **Responsable:** P3, arte (@Pao-Parra)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-10-02 (D4)
- **Dependencias:** ISS-04, ISS-15, ISS-16
- **Milestone:** Fase 1 — Núcleo jugable
- **Labels:** `tipo:arte` `area:criaturas` `area:combate` `prioridad:mvp` `rol:arte`

**Descripción.** Arte final de la criatura principal de la noche, un wáay con forma de perro (*pek'*), y del efecto del golpe de lanza. Como conserva el tamaño y la distribución de cuadros, `waay_pek.tscn` y `spear.tscn` los muestran sin cambios. El jefe de la noche 5 reutiliza este sprite escalado.

**Entrega esperada.**
- `assets/sprites/creatures/waay_pek.png`: 128×128, cuadros de 32×32, con `idle` 4, `walk` 4, `attack` 4 y `hurt` 2.
- `assets/sprites/effects/spear_slash.png`: 128×32, con `slash` 4.
- Archivos editables en `art_source/`, según la guía de estilo §5.

**Limitaciones.**
- Perro mesoamericano, sin razas europeas, con rasgos sobrenaturales dibujados con colores de la paleta.
- Sin Wáay Kot (deseable, Fase 2).
- No edita `waay_pek.tscn` ni `spear.tscn`.

**Criterios de aceptación.**
- [ ] `waay_pek.png` mide 128×128 con 4 filas en el orden de la guía, y `spear_slash.png` mide 128×32.
- [ ] Solo usa colores de `paleta.png`.
- [ ] En `creature_test.tscn` cada animación muestra sus cuadros y git no muestra cambios en `waay_pek.tscn` ni en `spear.tscn`.
- [ ] Con `scale = 2` en la escena de prueba (tamaño del jefe), el sprite se ve sin suavizado.
- [ ] La referencia del perro mesoamericano está en la descripción del PR y P4 la aprueba.
- [ ] Los archivos editables existen en `art_source/`.

---

#### Carga de la Fase 1

| Persona | D2 · 30/09 | D3 · 01/10 | D4 · 02/10 | Total |
|---|---|---|---|---|
| P1 juego | ISS-08 (3) + ISS-09 (2) = 5 | ISS-16 (3) + ISS-15 (2) = 5 | ISS-21 (3) + ISS-22 (2) = 5 | 15 |
| P2 sistemas | ISS-10 (3) + ISS-12 (2) = 5 | ISS-17 (5) = 5 | ISS-23 (2) + ISS-24 (3) = 5 | 15 |
| P3 arte | ISS-11 (5) = 5 | ISS-20 (5) = 5 | ISS-25 (5) = 5 | 15 |
| P4 diseño | ISS-13 (2) + ISS-14 (3) = 5 | ISS-18 (5) = 5 | ISS-19 (5) = 5 | 15 |
| **Total** | **20** | **20** | **20** | **60 de 60** |

La fase está al 100 % y no tiene holgura: un atraso en ISS-10, ISS-16, ISS-17 o ISS-18 mueve el hito. Cadenas: ISS-10 → ISS-17 → hito · ISS-08 → ISS-09 → ISS-21 / ISS-22 · ISS-10 → ISS-16 → ISS-23 · ISS-12 + ISS-14 → ISS-18 → ISS-24.

#### Hito: comprobación al cierre del D4

Se comprueba con F5 al revisar el último PR fusionado del D4. Cada casilla que falle se registra como issue `tipo:bug` en la Fase 2.

- [ ] F5 abre `level_01` en la Mañana del día 1 con 100 de agua, 30 de cacao y el inventario inicial de `level_01.tres`.
- [ ] En la Mañana se siembra, se riega, se cosecha un cultivo maduro (usando F2 para adelantar días), se alimenta a los pavos y se repara una albarrada.
- [ ] En la Tarde aparece el panel provisional y un botón pasa al Atardecer.
- [ ] En el Atardecer se coloca una antorcha de copal.
- [ ] En la Noche aparecen 3 Wáay Pek', atacan pavos, cultivos, albarradas o a Ya'ax, y la lanza los derrota.
- [ ] En el Amanecer los cultivos regados avanzan, el agua se rellena y el resumen muestra el día en numeración maya; después empieza la Mañana del día 2.
- [ ] Si Ya'ax muere, el día se repite desde la Mañana.
- [ ] La consola de Godot no muestra errores durante el día.
