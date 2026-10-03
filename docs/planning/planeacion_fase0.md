# Planeación del prototipo — La Última Milpa (nivel 1, Dzibilchaltún)

Equipo:

| Clave | Rol | Usuario |
|---|---|---|
| P1 | Programación de juego | @cesardzul-byte |
| P2 | Programación de sistemas | @jogedelapa01-alt |
| P3 | Arte | @Pao-Parra |
| P4 | Diseño, narrativa, audio y pruebas | @ALEXANDER242164/@Ronnie |

Calendario:

| Día | D1 | D2 | D3 | D4 | D5 | D6 | D7 | D8 | D9 |
|---|---|---|---|---|---|---|---|---|---|
| Fecha | mar 29/09 | mié 30/09 | jue 01/10 | vie 02/10 | sáb 03/10 | dom 04/10 | lun 05/10 | mar 06/10 | mié 07/10 |

---

## 1. Supuestos

1. **Fecha de inicio.** `2026-29-09` se interpreta como 29 de septiembre de 2026 (martes). Todas las fechas son de 2026.
2. **Capacidad.** Las fases llegan al día 9, así que se planea sobre 9 días: 4 personas × 5 h × 9 días = 180 h. La consigna habla de 8 días hábiles; por eso la carga planeada total es de **162 h** (equivale a unos 8 días de capacidad) y lo que sobra queda como colchón, casi todo en la Fase 4.
3. **Congelamiento.** La Fase 3 solo conecta e integra lo que ya existe (flujo del nivel, tutorial, integración del minijuego, exportación) y recibe arte final. El congelamiento de funciones aplica desde el cierre del D7. La Fase 4 no tiene funciones nuevas.
4. **Deseables.** Solo caben porque los sistemas MVP leen sus datos de Resources: el Wáay Kot es un `CreatureData` con `flies = true`, la colmena de meliponas es un `AnimalData` con `needs_food = false` y la estatua de báalam es un `DefenseData` con daño en área. Por eso los deseables son tres issues pequeños (datos, arte y honda). Funcionan como primer colchón: si se atrasa un issue MVP del mismo responsable, el deseable se cancela **antes** de aplicar el plan de recorte.
5. **Plan de recorte.** Si aun así falta tiempo: (1) el Ch'a' Cháak pasa a cinemática (ISS-35 e ISS-43 se sustituyen por una secuencia de ilustraciones); (2) el mapa regional pasa a un menú de tres botones (ISS-28 sin ilustración).
6. **IDs y números de GitHub.** Los issues se crean en el orden ISS-01 … ISS-54. Si el repositorio no tiene issues ni PR previos y los 54 se crean antes de abrir el primer PR, entonces ISS-NN = #NN. Si no, hay que sumar el desplazamiento al copiar las dependencias.
7. **Fechas y orden dentro del día.** La fecha de entrega de un issue es el último día en que se trabaja. Solo ISS-49, ISS-50 e ISS-51 se reparten entre D8 y D9 (la tabla de carga muestra las horas de cada día). Cuando un issue depende de otro con la misma fecha, empieza en cuanto se fusiona el PR del que depende: ISS-01 e ISS-02 son lo primero del D1, e ISS-53 es lo último del D9.
8. **Ramas.** Se respeta la decisión de hacer PR a `main`. Hoy el remoto tiene `develop` como rama por defecto; ISS-01 deja `main` como rama por defecto y protegida. Si el equipo prefiere integrar en `develop`, solo cambia la rama destino.
9. **Estructura existente.** El commit `bcbc64f` ya creó las carpetas (`docs/art_guide`, `docs/culture`, `docs/design`, `src/creatures/waay_pek`, `src/levels/level_01_dzibilchaltun`, etc.). Las entregas usan esas rutas. Todavía no existe `project.godot`.
10. **Placeholders con la ruta final.** P3 entrega cada placeholder con el nombre, el tamaño y la distribución de cuadros del arte final. El arte final reemplaza el archivo sin tocar escenas, así que ningún issue de programación depende del arte final.
11. **Escenas y dueños.** `milpa.tscn` (mapa y marcadores) es de P1; `level_01.tscn` y `main.tscn` (instancian los sistemas) son de P2. Los demás sistemas se enganchan por grupos de nodos y señales del EventBus, sin editar la escena de otra persona en la misma fase.
12. **Código en inglés.** Archivos, clases, variables y señales van en inglés (como las carpetas existentes). Los textos visibles van en español y en maya yucateco.
13. **P4 y escenas sencillas.** P4 no programa sistemas. Con apoyo de IA monta tres piezas de presentación que solo escuchan señales: la intro, la pantalla de fin y el director de audio. Si se complica, P1 lo absorbe con la hora libre que tiene el D7.
14. **Personas externas.** P4 agenda desde el D1 a un hablante de maya yucateco (revisión el D6) y, el D7, a 3–5 jugadores ajenos al equipo (playtest el D8).
15. **Derrota.** La consigna no la define. Se asumen dos casos: (1) si la vida de Ya'ax llega a 0 por el ataque de cualquier criatura, incluido Kisin, se reinicia el día actual desde una copia del estado que se guarda en memoria al amanecer (sin guardar en disco); (2) si la ofrenda del templo no está completa al cerrar la Tarde del día 5, la noche 5 ocurre igual, pero al derrotar a Kisin no hay ritual: se muestra el final «sin lluvia» y la partida se reinicia desde el día 1.
16. **Issues de corrección.** ISS-49, ISS-50 e ISS-51 son contenedores. Cada error concreto se registra como un issue `tipo:bug` nuevo, enlazado al contenedor.
17. **Área del título.** El `[Área]` del título es el área funcional (por ejemplo, `[Proyecto]`, `[Ciclo]`, `[Nivel]` o `[Pruebas]`) y puede no coincidir con un label. Los labels `area:*` son solo los del conjunto definido; los issues transversales llevan todas las áreas que tocan.
18. **Versión de Godot.** Se usa la versión estable 4.x vigente el D1. ISS-01 la anota con su número exacto y las cuatro computadoras la usan.

---

## 2. Resumen de fases

| Fase (milestone) | Fechas (vence) | Objetivo | Hito | Issues | Horas |
|---|---|---|---|---|---|
| **Fase 0 — Preparación** | D1: 29/09 (vence 2026-09-29) | El proyecto de Godot abre igual en las cuatro computadoras, con autoloads, clases de datos y componentes base. Existen la guía de arte con sus placeholders, el GDD y el glosario, así que desde el D2 todos trabajan en paralelo sin bloquearse. | Proyecto abre sin errores en las 4 computadoras | 7 (ISS-01 a 07) | 20 |
| **Fase 1 — Núcleo jugable** | D2–D4: 30/09 al 02/10 (vence 2026-10-02) | Se juega un día completo con placeholders: mañana en la milpa (sembrar, regar, cosechar, pavos, reparar), tarde provisional, atardecer con defensas, noche con Wáay Pek' y lanza, y amanecer con resumen en numeración maya. | **Un día completo jugable con placeholders** | 18 (ISS-08 a 25) | 60 |
| **Fase 2 — Contenido del nivel 1** | D5–D6: 03/10 al 04/10 (vence 2026-10-04) | Cada pieza de contenido del nivel 1 funciona por separado: mapa del mundo y mapa regional con sus tres sitios, mercado, códice, aluxes, jefe, Ch'a' Cháak, intro, fin y audio. Los textos mayas están revisados por un hablante. | Contenido del nivel 1 completo y probado por separado | 16 (ISS-26 a 41) | 40 |
| **Fase 3 — Integración y congelamiento** | D7: 05/10 (vence 2026-10-05) | El nivel 1 se juega de inicio a fin (intro → mapa del mundo → 5 días → ritual → fin) y ya se exporta a Windows y Web. Desde el cierre de esta fase no entran funciones nuevas. | **Nivel 1 jugable de inicio a fin** | 6 (ISS-42 a 47) | 18 |
| **Fase 4 — Pruebas y entrega** | D8–D9: 06/10 al 07/10 (vence 2026-10-07) | Hay un playtest con personas ajenas al equipo, los errores encontrados están corregidos, el balance está ajustado y se entregan las builds finales de Windows y Web. | Builds finales entregadas | 7 (ISS-48 a 54) | 24 de 40 (40 % libre) |
| **Total** | 9 días | | | **54** | **162 de 180** |

---

## 3. Plan detallado por fase

Formato de cada issue: título, metadatos, descripción, entrega esperada, limitaciones y criterios de aceptación. Las dependencias usan los IDs ISS-NN.

### Fase 0 — Preparación (D1, 2026-09-29)

**Objetivo:** el proyecto de Godot abre igual en las cuatro computadoras, con autoloads, clases de datos y componentes base. Existen la guía de arte con sus placeholders, el GDD y el glosario, así que desde el D2 todos trabajan en paralelo sin bloquearse.
**Inicio:** 2026-09-29 · **Fin:** 2026-09-29 · **Milestone:** `Fase 0 — Preparación` (vence 2026-09-29)

#### ISS-01 · [Proyecto] Configurar el proyecto de Godot 4 y el repositorio

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-29 (D1, primera tarea del día)
- **Dependencias:** ninguna
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:config` `area:ui` `area:player` `prioridad:mvp` `rol:sistemas`

**Descripción.** Crea `project.godot` sobre la estructura de carpetas que ya existe, con la configuración de pixel art y el mapa de entradas del juego, para que las cuatro computadoras abran exactamente el mismo proyecto. También deja listas las reglas del repositorio: una rama por issue y PR con revisión.

**Entrega esperada.**
- `project.godot`: resolución base 480×270, ventana de 1920×1080, stretch mode `viewport`, escala entera, filtro de texturas `Nearest` por defecto y escena principal `src/main.tscn` (vacía por ahora).
- Mapa de entradas: `move_up`, `move_down`, `move_left`, `move_right` (WASD y flechas), `interact` (E), `attack` (J o clic izquierdo), `cycle_tool` (Q), `pause` (Esc).
- Capas de física con nombre: `player`, `creatures`, `walls`, `crops`, `animals`, `interactables`, `hitbox`, `hurtbox`.
- `.gitattributes` (fin de línea LF en texto; png, wav, ogg y ttf como binarios).
- `.github/pull_request_template.md` (issue que cierra, cómo probarlo y checklist).
- `docs/design/convenciones_tecnicas.md`: versión exacta de Godot, guía de estilo de GDScript con tipado estático, formato de ramas `tipo/numero-descripcion`, regla de un responsable por escena y por fase, y rutas de carpetas.
- `README.md` con la versión de Godot y cómo abrir el proyecto.
- En GitHub: `main` como rama por defecto y protegida (se necesita 1 aprobación para fusionar).

**Limitaciones.**
- No crea autoloads ni scripts de juego (eso es ISS-05) ni configura la exportación (ISS-44).
- No crea labels, milestones ni issues; eso se hace a mano.
- Tiempo máximo: 2 h, porque el resto del día depende de este issue.

**Criterios de aceptación.**
- [ ] Al abrir el proyecto en las cuatro computadoras con la misma versión 4.x no aparecen errores y `project.godot` no cambia.
- [ ] Al ejecutar, la ventana de 1920×1080 muestra el viewport de 480×270 escalado ×4 y sin suavizado.
- [ ] El mapa de entradas contiene las 9 acciones listadas.
- [ ] Un push directo a `main` es rechazado y un PR no se puede fusionar sin 1 aprobación.
- [ ] `docs/design/convenciones_tecnicas.md` indica la versión exacta de Godot y el formato de ramas.

---

#### ISS-02 · [Diseño] Redactar el GDD breve con valores iniciales de balance

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-29 (D1, primera tarea del día)
- **Dependencias:** ninguna
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:docs` `area:milpa` `area:criaturas` `area:economia` `prioridad:mvp` `rol:diseno`

**Descripción.** Documento corto que fija el bucle del día, los controles, las reglas de victoria y derrota y los números iniciales: duración de cada fase, agua, crecimiento, vida y daño, precios en cacao y oleadas. Con él, P2 define los campos de las clases de datos (ISS-05) y P4 llena los `.tres` (ISS-13).

**Entrega esperada.**
- `docs/design/gdd.md` con estas secciones: bucle y duración de cada fase; controles; cultivos (maíz, frijol, calabaza); pavos; aluxes y ofrenda de saka'; criaturas y jefe; defensas; economía y descuento por pago exacto; ofrenda del templo; victoria y derrota; lista de efectos de sonido y pistas de música.
- Tabla de valores: campo, valor inicial, unidad y archivo `.tres` donde vivirá.

**Limitaciones.**
- Los valores son un punto de partida; el balance final se hace en ISS-52.
- No incluye guion ni textos narrativos (ISS-14) ni diseño del nivel 2 (ISS-54).
- Máximo tres páginas.

**Criterios de aceptación.**
- [ ] `docs/design/gdd.md` existe y su tabla incluye cada campo numérico que usarán los `.tres`, con valor y unidad.
- [ ] La suma de las duraciones de las fases de un día da entre 4 y 6 minutos.
- [ ] Define la victoria (5 noches, ofrenda completa y ritual) y la derrota (supuesto 15).
- [ ] Lista los ítems de la ofrenda del templo con sus cantidades.
- [ ] Lista los efectos de sonido y las pistas de música, cada uno con el evento que lo dispara.
- [ ] No usa "nahual", "Xibalbá" ni "tres hermanas", ni animales llegados con los españoles.

---

#### ISS-03 · [Cultura] Investigar y redactar el glosario en maya yucateco

- **Responsable:** P4, diseño (@ALEXANDER242164)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-29 (D1)
- **Dependencias:** ninguna
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:investigacion` `area:cultura` `area:narrativa` `prioridad:mvp` `rol:diseno`

**Descripción.** Reúne todos los términos mayas que aparecerán en el juego con su escritura en el alfabeto normalizado actual del maya yucateco, su significado y su fuente. Es la referencia única de ortografía para textos, códice, interfaz y nombres de recursos, y la base de la revisión con un hablante (ISS-41).

**Entrega esperada.**
- `docs/culture/glosario.md`: tabla con término, pronunciación aproximada, significado, uso en el juego, fuente y estado (`pendiente` o `verificado`).
- Términos mínimos: Ya'ax, Kisin, Metnal, wáay, Wáay Pek', Wáay Kot, Cháak, Ch'a' Cháak, milpa, saka', alux, tunk'ul, báalam, copal, cacao, albarrada, pavo (doméstico y ocelado), abeja melipona, maíz, frijol, calabaza, los cuatro rumbos, Xlakaj, Dzibilchaltún, Uxmal, Chichén Itzá, Ek' Balam y los numerales del 0 al 19.
- Sección "No usar", con reemplazos: nahual → wáay, Xibalbá → Metnal, tres hermanas → milpa; y la lista de animales y plantas llegados con los españoles (gallina, cerdo, vaca, chivo, caballo, caña de azúcar, cítricos, plátano).
- `docs/culture/fuentes.md` con la bibliografía.
- Nombre o iniciales del hablante revisor (con su permiso) y la fecha acordada para el D6.

**Limitaciones.**
- No redacta las entradas del códice (ISS-19).
- Cubre solo el nivel 1 y los nombres de las ciudades bloqueadas.
- Cada término necesita al menos una fuente publicada; sin fuente, no entra al juego.

**Criterios de aceptación.**
- [ ] `glosario.md` tiene al menos 30 términos con las 6 columnas llenas.
- [ ] Cada término cita una fuente que aparece en `fuentes.md`.
- [ ] La sección "No usar" contiene los tres reemplazos y la lista de animales y plantas.
- [ ] Hay un hablante de maya yucateco confirmado para el D6 y está anotado en el documento.

---

#### ISS-04 · [Arte] Definir la guía de estilo y crear placeholders con rutas finales

- **Responsable:** P3, arte (@Pao-Parra)
- **Estimación:** 5 h · **Fecha de entrega:** 2026-09-29 (D1)
- **Dependencias:** ninguna
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:arte` `area:player` `area:milpa` `area:criaturas` `area:ui` `prioridad:mvp` `rol:arte`

**Descripción.** Fija la paleta, los tamaños y la distribución de cuadros de cada hoja de sprites, y entrega placeholders con esas mismas rutas y medidas. Así programación trabaja con placeholders desde el D2 y el arte final solo reemplaza archivos, sin tocar escenas.

**Entrega esperada.**
- `docs/art_guide/guia_estilo.md`: paleta de 32 colores como máximo, tamaños (tiles de 16×16, Ya'ax, criaturas, íconos, glifos de numeración), orden de animaciones y cuadros por hoja, convención de nombres y dónde va el archivo fuente en `art_source/`.
- `docs/art_guide/paleta.png`.
- Tabla de assets en la guía con ruta, tamaño de cuadro y número de cuadros por animación.
- Placeholders PNG de colores planos en su ruta final:
  - `assets/sprites/characters/`: `ya_ax.png`.
  - `assets/sprites/crops/`: `maize.png`, `beans.png`, `squash.png`.
  - `assets/sprites/animals/`: `turkey.png`, `melipona_hive.png`.
  - `assets/sprites/creatures/`: `waay_pek.png`, `waay_kot.png`, `alux.png`.
  - `assets/sprites/props/`: `albarrada.png`, `copal_torch.png`, `balam_statue.png`, `alux_altar.png`, `tunkul.png`, `frog.png`.
  - `assets/sprites/effects/`: `spear_slash.png`, `sling_stone.png`.
  - `assets/ui/maya_numerals/`: `dot.png`, `bar.png`, `shell.png`.
  - `assets/ui/icons/`: un ícono por ítem y recurso.
  - `assets/illustrations/`: `intro_01.png`, `intro_02.png`, `intro_03.png`, `world_map.png`, `region_map.png`.

**Limitaciones.**
- No es arte final.
- El tileset placeholder lo hace P1 en ISS-07.
- Los placeholders de los deseables (`waay_kot`, `melipona_hive`, `balam_statue`, `sling_stone`) se incluyen porque cuestan minutos y así ISS-33 no espera arte.

**Criterios de aceptación.**
- [ ] Cada archivo de la tabla existe con el tamaño exacto que indica la guía.
- [ ] Los placeholders solo usan colores de la paleta, que tiene 32 colores como máximo.
- [ ] Ningún nombre de archivo tiene espacios, acentos ni mayúsculas.
- [ ] La guía indica las animaciones y el número de cuadros de cada hoja.
- [ ] Al escalar ×4 en Godot, los placeholders se ven sin suavizado.

---

#### ISS-05 · [Proyecto] Crear los autoloads y las clases Resource de datos

- **Responsable:** P2, sistemas (@jogedelapa01-alt)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-29 (D1, después de ISS-01 e ISS-02)
- **Dependencias:** ISS-01, ISS-02
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:feature` `area:milpa` `area:criaturas` `area:economia` `area:codice` `prioridad:mvp` `rol:sistemas`

**Descripción.** Crea `GameState` (estado global de la partida), `EventBus` (señales entre sistemas) y las clases Resource tipadas para cultivos, criaturas, animales, defensas, ítems, oleadas, nivel, códice, ritmo del ritual y tutorial. Así los sistemas se comunican sin referencias directas entre ellos y P4 puede crear `.tres` desde el editor sin tocar código.

**Entrega esperada.**
- `src/autoload/game_state.gd`: día (1 a 5), fase, agua y agua máxima, cacao, inventario (`Dictionary` de `StringName` a `int`), progreso de la ofrenda, entradas del códice desbloqueadas, tutorial activo, estadísticas del día y `snapshot()` / `restore()` en memoria.
- `src/autoload/event_bus.gd` con señales tipadas: `phase_changed`, `day_started`, `wave_started`, `wave_cleared`, `crop_planted`, `crop_harvested`, `water_changed`, `cacao_changed`, `inventory_changed`, `creature_killed`, `animal_died`, `offering_delivered`, `codex_unlocked`, `ritual_finished`, `player_died`.
- Clases de datos:
  - `src/milpa/crops/crop_data.gd`
  - `src/creatures/base/creature_data.gd` (incluye `flies`)
  - `src/milpa/animals/animal_data.gd` (incluye `needs_food`)
  - `src/milpa/defenses/defense_data.gd` (`blocks`, `radius`, `damage_per_second`, `cost`)
  - `src/economy/item_data.gd`
  - `src/waves/wave_data.gd`
  - `src/levels/level_data.gd`
  - `src/codex/codex_entry_data.gd`
  - `src/minigames/cha_chaak/rhythm_chart_data.gd`
  - `src/levels/tutorial_data.gd`
- Un `.tres` de ejemplo por clase, en su carpeta de `data/`.
- `src/autoload/game_state_check.gd`: script de verificación con `assert` para `snapshot()` y `restore()`.

**Limitaciones.**
- Solo estado y señales; no implementa lógica de juego.
- Los valores reales los llena P4 en ISS-13.
- Solo se permiten estos dos autoloads.
- Sin guardado en disco: la copia de `snapshot()` vive en memoria.

**Criterios de aceptación.**
- [ ] `GameState` y `EventBus` aparecen en Proyecto > Configuración > Autoload y el proyecto corre sin errores.
- [ ] Desde el inspector se puede crear un `.tres` de cada una de las 10 clases.
- [ ] `game_state_check.gd` pasa: después de `snapshot()`, cambiar valores y llamar a `restore()`, el agua, el cacao y el inventario vuelven a los valores guardados.
- [ ] `event_bus.gd` declara las 15 señales con parámetros tipados.
- [ ] Ninguna variable, parámetro ni función queda sin tipo estático.

---

#### ISS-06 · [Combate] Crear componentes de salud, daño e interacción

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 2 h · **Fecha de entrega:** 2026-09-29 (D1, después de ISS-01)
- **Dependencias:** ISS-01
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:feature` `area:combate` `area:player` `prioridad:mvp` `rol:juego`

**Descripción.** Crea nodos reutilizables para tener vida, recibir golpes, dar golpes y poder usarse con la tecla de interactuar. Los usarán Ya'ax, las criaturas, los pavos, los cultivos, las albarradas y los objetos interactivos, así que ningún sistema reimplementa el daño ni la interacción.

**Entrega esperada.**
- `src/components/health_component.gd`: `max_health`, `current_health`, señales `damaged(amount)` y `died`.
- `src/components/hitbox_component.gd`: `Area2D` con `damage` y equipo de origen.
- `src/components/hurtbox_component.gd`: `Area2D` que recibe una hitbox, aplica el daño al `HealthComponent` y tiene invulnerabilidad breve configurable.
- `src/components/interactable_component.gd`: `Area2D` con texto de ayuda y señal `interacted(actor)`.
- `src/components/components_demo.tscn`: escena de prueba.

**Limitaciones.**
- Sin arte ni sonido.
- No implementa ataques ni IA (ISS-15 e ISS-16).
- Composición por nodos, sin cadenas de herencia de escenas.

**Criterios de aceptación.**
- [ ] En `components_demo.tscn`, cuando una hitbox toca una hurtbox, la vida baja exactamente `damage`; al llegar a 0 se emite `died` una sola vez.
- [ ] Una hitbox del mismo equipo no hace daño.
- [ ] `interacted` solo se emite si el actor está dentro del área y se pulsa `interact`.
- [ ] Los componentes usan las capas de física definidas en ISS-01.

---

#### ISS-07 · [Mapas] Crear la escena de prueba de la milpa con TileMapLayer

- **Responsable:** P1, juego (@cesardzul-byte)
- **Estimación:** 3 h · **Fecha de entrega:** 2026-09-29 (D1, después de ISS-01)
- **Dependencias:** ISS-01
- **Milestone:** Fase 0 — Preparación
- **Labels:** `tipo:feature` `area:mapas` `area:milpa` `prioridad:mvp` `rol:juego`

**Descripción.** Arma el escenario donde transcurre el nivel 1: terreno con TileMapLayer, colisiones en bordes y rocas, marcadores de parcelas, corral, casa, altar de los aluxes, puntos de aparición de criaturas y cámara. Es la base para probar todos los sistemas de la Fase 1. El tileset final solo sustituye la imagen.

**Entrega esperada.**
- `src/levels/level_01_dzibilchaltun/milpa.tscn`: TileMapLayer `ground` y `obstacles` (esta con capa de física), Y-sort y `Camera2D` con límites. El mapa mide unos 40×24 tiles.
- Grupos de `Marker2D`: `plots` (9 o más), `animal_pen`, `alux_altar`, `house`, `creature_spawns` (4 o más, en los bordes) y `player_start`.
- `src/levels/level_01_dzibilchaltun/milpa_tileset.tres` con rejilla de 16×16.
- `assets/tilesets/milpa.png` como placeholder de colores planos.

**Limitaciones.**
- Placeholder: no pinta el arte final. P3 reemplaza `assets/tilesets/milpa.png` en ISS-11 con la misma rejilla.
- No tiene lógica de cultivos, criaturas ni jugador.
- En la Fase 1, el único responsable de `milpa.tscn` es P1. Los demás sistemas encuentran los marcadores por grupo, sin editar la escena.

**Criterios de aceptación.**
- [ ] La escena se ejecuta sola (F6) y la cámara nunca muestra nada fuera de los límites del mapa.
- [ ] Un `CharacterBody2D` en la capa `player` choca con los bordes y las rocas.
- [ ] Existen los grupos de marcadores listados, con al menos 9 parcelas y 4 puntos de aparición.
- [ ] El TileSet usa una rejilla de 16×16 y la textura `assets/tilesets/milpa.png`.
