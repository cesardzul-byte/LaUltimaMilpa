# Game Design Document — La Última Milpa (Prototipo Nivel 1: Dzibilchaltún)

Versión: 0.1 (valores iniciales — balance final en ISS-52)  
Motor: Godot 4.x | Resolución base: 480×270 (×4 entero) | Pixel art, paleta ≤32 colores

---

## 1. Bucle del día y duración de fases

Un día = 4 fases jugables + transición de amanecer. Duración total objetivo: **4:30–5:00 min**.

| Fase | Duración | Actividad principal | Transición |
|------|----------|---------------------|------------|
| **Mañana** | 100 s | Sembrar, regar, cosechar, alimentar pavos, reparar defensas | EventBus `phase_changed(MORNING → AFTERNOON)` |
| **Tarde** | 70 s | Mercado (trueque cacao), preparar ofrenda saka', colocar/reparar defensas | `phase_changed(AFTERNOON → DUSK)` |
| **Atardecer** | 30 s | Colocación final de defensas, encender antorchas copal | `phase_changed(DUSK → NIGHT)` |
| **Noche** | 110 s | Oleadas de criaturas (Wáay Pek', Aluxes, Wáay Kot, Jefe) | `phase_changed(NIGHT → DAWN)` + `wave_cleared` |
| **Amanecer** | 20 s | Resumen día (numeración maya), snapshot estado, guarda en memoria | `day_started` (día+1) |

**Total día:** 330 s = **5:30 min** (margen para iterar en ISS-52).

---

## 2. Controles (Input Map — ISS-01)

| Acción | Teclas | Uso |
|--------|--------|-----|
| `move_up` | W / ↑ | Movimiento |
| `move_down` | S / ↓ | Movimiento |
| `move_left` | A / ← | Movimiento |
| `move_right` | D / → | Movimiento |
| `interact` | E | Sembrar, regar, cosechar, hablar, mercado, ofrenda |
| `attack` | J / Clic izq | Lanza (melee) |
| `cycle_tool` | Q | Cambiar herramienta/semilla/defensa seleccionada |
| `pause` | Esc | Menú pausa |

---

## 3. Cultivos (Milpa: maíz, frijol, calabaza)

| Campo | Maíz | Frijol | Calabaza | Unidad | `.tres` destino |
|-------|------|--------|----------|--------|-----------------|
| `growth_days` | 3 | 2 | 4 | días | `crop_data.tres` (maize/beans/squash) |
| `water_per_day` | 10 | 8 | 12 | unidades/parcela/día | `crop_data.tres` |
| `yield_min` | 2 | 3 | 1 | unidades | `crop_data.tres` |
| `yield_max` | 4 | 5 | 2 | unidades | `crop_data.tres` |
| `cacao_value` | 5 | 4 | 6 | cacao/unidad | `item_data.tres` (maize_cob/bean_pod/squash) |
| `seed_cost` | 3 | 2 | 4 | cacao | `item_data.tres` (seed_maize/seed_bean/seed_squash) |
| `wither_days` | 2 | 2 | 3 | días sin agua | `crop_data.tres` |

- 9+ parcelas (marcadores `plots` en `milpa.tscn`).
- Siembra: `interact` en parcela vacía con semilla seleccionada.
- Riego: `interact` en parcela con agua en inventario (`water_jar`).
- Cosecha: `interact` en parcela lista → añade al inventario.

---

## 4. Pavos (Animales)

| Campo | Pavo ocelado | Pavo doméstico | Unidad | `.tres` destino |
|-------|--------------|----------------|--------|-----------------|
| `max_health` | 30 | 40 | HP | `animal_data.tres` (turkey_ocellated/turkey_domestic) |
| `feed_cost` | 5 | 3 | cacao/día | `animal_data.tres` |
| `produce_interval` | 2 | 1 | días | `animal_data.tres` |
| `produce_item` | `feather_ocellated` | `feather_domestic` | — | `item_data.tres` |
| `produce_value` | 8 | 3 | cacao/unidad | `item_data.tres` |
| `needs_food` | true | true | bool | `animal_data.tres` |
| `escape_chance` | 0.15 | 0.05 | 0–1 | `animal_data.tres` |

- Corral: marcador `animal_pen` en `milpa.tscn`.
- Alimentar: `interact` en corral con maíz en inventario.
- Si `current_health` = 0 o escapan → `animal_died` / se pierden.

---

## 5. Aluxes y ofrenda de saka'

| Campo | Valor | Unidad | `.tres` destino |
|-------|-------|--------|-----------------|
| `altar_cooldown` | 2 | días | `level_data.tres` |
| `saka_cost` | 15 | cacao | `item_data.tres` (saka_jar) |
| `blessing_duration` | 1 | noche | `level_data.tres` |
| `blessing_effect` | `creature_spawn_delay += 30%` | — | `level_data.tres` |
| `blessing_effect` | `crop_wither_rate -= 50%` | — | `level_data.tres` |

- Altar: marcador `alux_altar` en `milpa.tscn`.
- Ofrenda: `interact` en altar con `saka_jar` en inventario → desbloquea bendición esa noche.
- Si no se ofrenda: oleadas más agresivas (`wave_data.tres` `aggression_modifier = 1.3`).

---

## 6. Criaturas y Jefe

### Base (`creature_data.tres` — campos compartidos)
| Campo | Tipo | Unidad |
|-------|------|--------|
| `max_health` | int | HP |
| `move_speed` | float | px/s |
| `damage` | int | HP/golpe |
| `attack_cooldown` | float | s |
| `attack_range` | float | px |
| `flies` | bool | — |
| `xp_reward` | int | — |
| `cacao_drop_min` | int | cacao |
| `cacao_drop_max` | int | cacao |

### Instancias (valores iniciales)

| Criatura | max_health | move_speed | damage | attack_cd | range | flies | xp | cacao_drop | `.tres` |
|----------|------------|------------|--------|-----------|-------|-------|-----|------------|---------|
| **Wáay Pek'** (base) | 50 | 60 | 15 | 1.5 | 24 | false | 10 | 3–6 | `creatures/waay_pek.tres` |
| **Wáay Kot** (vuela) | 35 | 90 | 10 | 1.0 | 32 | true | 15 | 5–10 | `creatures/waay_kot.tres` |
| **Alux** (pequeño) | 25 | 50 | 8 | 2.0 | 16 | false | 8 | 2–4 | `creatures/alux.tres` |
| **Jefe: Kisin** (noche 5) | 300 | 40 | 30 | 2.5 | 48 | false | 100 | 50–80 | `creatures/boss_kisin.tres` |

- Spawns: marcadores `creature_spawns` (4+) en bordes de `milpa.tscn`.
- Oleadas definidas en `wave_data.tres` (ver §10).
- Kisin aparece solo noche 5 (condición en `level_data.tres` `boss_night = 5`).

---

## 7. Defensas

| Defensa | blocks | radius | dps | cost_cacao | durability | `.tres` |
|---------|--------|--------|-----|------------|------------|---------|
| Albarrada | true | 0 | 0 | 20 | 200 | `defense_data.tres` (albarrada) |
| Antorcha copal | false | 96 | 5 | 15 | 120 | `defense_data.tres` (copal_torch) |
| Estatua balam | false | 120 | 12 (área) | 40 | 150 | `defense_data.tres` (balam_statue) |
| Altar alux | false | 0 | 0 | 25 | ∞ | `defense_data.tres` (alux_altar) |
| Tunk'ul (tambor) | false | 160 | 0 (ralentiza) | 30 | 100 | `defense_data.tres` (tunkul) |

- Colocación: fase Tarde/Atardecer, `interact` en parcela libre con defensa seleccionada.
- Reparación: `interact` en defensa dañada + `wood` en inventario (costo 50% original).
- `blocks = true` → colisión física (capa `walls`). `dps > 0` → daño automático a criaturas en `radius`.

---

## 8. Economía y descuento por pago exacto

| Ítem | Precio base (cacao) | Precio venta (cacao) | `.tres` |
|------|---------------------|----------------------|---------|
| `maize_cob` | 5 | 3 | `item_data.tres` |
| `bean_pod` | 4 | 2 | `item_data.tres` |
| `squash` | 6 | 4 | `item_data.tres` |
| `feather_ocellated` | 8 | 5 | `item_data.tres` |
| `feather_domestic` | 3 | 2 | `item_data.tres` |
| `seed_maize` | 3 | — | `item_data.tres` |
| `seed_bean` | 2 | — | `item_data.tres` |
| `seed_squash` | 4 | — | `item_data.tres` |
| `water_jar` | 10 | — | `item_data.tres` |
| `saka_jar` | 15 | — | `item_data.tres` |
| `wood` | 8 | 5 | `item_data.tres` |
| `copal` | 12 | — | `item_data.tres` |
| `obsidian` | 25 | 15 | `item_data.tres` |

**Descuento pago exacto:** si el jugador entrega la cantidad exacta de cacao sin requerir cambio → **10% descuento** en la compra (redondeo abajo).  
Ejemplo: compra `water_jar` (10 cacao) entregando 10 → paga 9.

**Mercado:** accesible fase Tarde, marcador `house` en `milpa.tscn`. UI muestra precios, inventario, cacao actual.

---

## 9. Ofrenda del templo (Victoria)

Requerida para acceder al ritual final (noche 5). Ítems y cantidades:

| Ítem | Cantidad | Fuente |
|------|----------|--------|
| `maize_cob` | 20 | Cosecha maíz |
| `bean_pod` | 15 | Cosecha frijol |
| `squash` | 10 | Cosecha calabaza |
| `feather_ocellated` | 5 | Pavos ocelados |
| `copal` | 3 | Compra mercado / hallazgo |
| `obsidian` | 1 | Compra mercado (caro) |
| `cacao` | 50 | Acumulado trueque |

- Progreso guardado en `GameState.offering_progress` (Dictionary `StringName → int`).
- Entrega: `interact` en marcador `temple` (mapa regional, no en milpa) durante fase Tarde.
- Al completar → desbloquea ritual Ch'a Cháak noche 5.

---

## 10. Oleadas (waves)

| Ola | Noche | Criaturas (tipo × cantidad) | Intervalo spawn | `.tres` |
|-----|-------|----------------------------|-----------------|---------|
| 1 | 1 | Wáay Pek' ×3 | 8 s | `waves/wave_01.tres` |
| 2 | 2 | Wáay Pek' ×4, Alux ×2 | 7 s | `waves/wave_02.tres` |
| 3 | 3 | Wáay Pek' ×3, Wáay Kot ×2, Alux ×3 | 6 s | `waves/wave_03.tres` |
| 4 | 4 | Wáay Pek' ×5, Wáay Kot ×3, Alux ×4 | 5 s | `waves/wave_04.tres` |
| 5 | 5 | Kisin ×1, Wáay Pek' ×4, Wáay Kot ×2, Alux ×3 | 4 s | `waves/wave_05.tres` |

Campos `wave_data.tres`:
- `creatures: Array[Dictionary]` (clave: `creature_id`, `count`, `spawn_delay`)
- `aggression_modifier: float` (1.0 base, 1.3 si no hay bendición alux)
- `time_limit: int` (segundos; si expira → `wave_cleared` igual)

---

## 11. Victoria y Derrota

**Victoria (fin del prototipo nivel 1):**
1. Sobrevivir 5 noches (día 5 completado).
2. Ofrenda del templo completada (9. arriba).
3. Ritual Ch'a Cháak completado (minijuego ritmo, ISS-33/ISS-43).
4. Pantalla final con resumen y numeración maya.

**Derrota (supuesto 15):**
- Vida de Ya'ax (`GameState.player_health`) llega a 0.
- **Consecuencia:** Reinicio del **día actual** desde `GameState.snapshot()` guardado al amanecer (en memoria, sin disco).
- Se pierden: progreso de cultivos del día, cacao gastado, defensas colocadas ese día.
- Se conservan: inventario base, ofrenda templo, códice desbloqueado, día actual.

---

## 12. Efectos de sonido (SFX) y pistas de música

| ID | Evento disparador | Tipo | Notas |
|----|-------------------|------|-------|
| `sfx_plant` | Sembrar semilla | SFX | |
| `sfx_water` | Regar parcela | SFX | |
| `sfx_harvest` | Cosechar cultivo | SFX | |
| `sfx_feed_turkey` | Alimentar pavo | SFX | |
| `sfx_turkey_escape` | Pavo escapa | SFX | |
| `sfx_build_defense` | Colocar defensa | SFX | |
| `sfx_repair` | Reparar defensa | SFX | |
| `sfx_spear_swing` | Ataque lanza | SFX | |
| `sfx_spear_hit` | Lanza impacta | SFX | |
| `sfx_sling_throw` | Honda (deseable) | SFX | |
| `sfx_sling_hit` | Piedra impacta | SFX | |
| `sfx_creature_hit` | Criatura recibe daño | SFX | |
| `sfx_creature_death` | Criatura muere | SFX | |
| `sfx_player_hit` | Ya'ax recibe daño | SFX | |
| `sfx_player_death` | Ya'ax muere (derrota) | SFX | |
| `sfx_market_buy` | Compra en mercado | SFX | |
| `sfx_market_sell` | Venta en mercado | SFX | |
| `sfx_offering` | Entregar ofrenda saka'/templo | SFX | |
| `sfx_blessing` | Bendición alux activada | SFX | |
| `sfx_wave_start` | Inicio oleada noche | SFX | |
| `sfx_wave_clear` | Oleada completada | SFX | |
| `sfx_day_summary` | Pantalla amanecer | SFX | |
| `sfx_rhythm_hit` | Acierto Ch'a Cháak | SFX | |
| `sfx_rhythm_miss` | Fallo Ch'a Cháak | SFX | |
| `music_morning` | Fase Mañana | Música | Loop, ambiente milpa |
| `music_afternoon` | Fase Tarde | Música | Loop, mercado |
| `music_dusk` | Fase Atardecer | Música | Tensión creciente |
| `music_night` | Fase Noche | Música | Loop, combate |
| `music_dawn` | Amanecer | Música | Corta, resolución |
| `music_boss` | Noche 5 (Kisin) | Música | Intensa, única |
| `music_ritual` | Ch'a Cháak | Música | Ritmo, interactiva |
| `music_intro` | Cinemática inicial | Música | |
| `music_outro` | Pantalla final | Música | |

Total: **25 SFX + 10 pistas musicales**.

---

## 13. Tabla maestra de valores para `.tres`

| Sistema | Campo | Valor inicial | Unidad | Archivo `.tres` |
|---------|-------|---------------|--------|-----------------|
| **Ciclo** | `morning_duration` | 100 | s | `level_data.tres` |
| | `afternoon_duration` | 70 | s | `level_data.tres` |
| | `dusk_duration` | 30 | s | `level_data.tres` |
| | `night_duration` | 110 | s | `level_data.tres` |
| | `dawn_duration` | 20 | s | `level_data.tres` |
| | `boss_night` | 5 | día | `level_data.tres` |
| **Agua** | `max_water` | 100 | unidades | `game_state` (runtime) |
| | `water_jar_capacity` | 30 | usos | `item_data.tres` (water_jar) |
| **Cultivos** | Ver §3 tabla completa | — | — | `crop_data.tres` ×3 |
| **Pavos** | Ver §4 tabla completa | — | — | `animal_data.tres` ×2 |
| **Aluxes** | Ver §5 tabla completa | — | — | `level_data.tres` / `item_data.tres` |
| **Criaturas** | Ver §6 tabla completa | — | — | `creature_data.tres` ×4 |
| **Defensas** | Ver §7 tabla completa | — | — | `defense_data.tres` ×5 |
| **Economía** | Ver §8 tabla completa | — | — | `item_data.tres` ×13 |
| | `exact_payment_discount` | 0.10 | 0–1 | `level_data.tres` |
| **Ofrenda** | Ver §9 tabla completa | — | — | `level_data.tres` (offering_requirements) |
| **Oleadas** | Ver §10 tabla completa | — | — | `wave_data.tres` ×5 |
| **Jugador** | `max_health` | 100 | HP | `creature_data.tres` (player) |
| | `move_speed` | 80 | px/s | `creature_data.tres` (player) |
| | `spear_damage` | 25 | HP | `weapon_data.tres` (spear) |
| | `spear_range` | 32 | px | `weapon_data.tres` (spear) |
| | `spear_cooldown` | 0.6 | s | `weapon_data.tres` (spear) |
| | `invuln_time` | 0.5 | s | `hurtbox_component` (runtime) |
| **Ritual** | `rhythm_chart_difficulty` | 1.0 | 0–1 | `rhythm_chart_data.tres` |
| | `ritual_min_score` | 0.7 | 0–1 | `rhythm_chart_data.tres` |

---

## 14. Convenciones de nombres (para P2/P3/P4)

- Archivos/clases/variables/señales: **inglés** (`crop_data.gd`, `max_health`, `phase_changed`).
- Textos visibles (UI, diálogos, códice): **español + maya yucateco**.
- Rutas `data/`: `snake_case` singular (`crops/maize.tres`, `creatures/waay_pek.tres`).
- IDs de recursos: `StringName` (`"maize_cob"`, `"waay_pek"`).
- Prohibidos en código y textos: *nahual, Xibalbá, tres hermanas, gallina, cerdo, vaca, chivo, caballo, caña de azúcar, cítricos, plátano*.

---

## 15. Referencias culturales (mínimas para nivel 1)

| Término | Uso en juego | Fuente |
|---------|--------------|--------|
| Ya'ax | Protagonista | Glosario ISS-03 |
| Kisin | Jefe final (noche 5) | Glosario ISS-03 |
| Wáay Pek' / Wáay Kot | Criaturas nocturnas | Glosario ISS-03 |
| Chaac / Ch'a Cháak | Lluvia / ritual ritmo | Glosario ISS-03 |
| Saka' | Bebida ceremonial (maíz) | Glosario ISS-03 |
| Alux | Espíritus protectores | Glosario ISS-03 |
| Balam | Jaguar / estatua defensa | Glosario ISS-03 |
| Tunk'ul | Tambor ceremonial | Glosario ISS-03 |
| Dzibilchaltún / Uxmal / Chichén Itzá / Ek' Balam | Ciudades (mapa regional) | Glosario ISS-03 |

> **Nota:** Glosario completo (30+ términos) en `docs/culture/glosario.md` (ISS-03). Revisión con hablante nativo programada D6.

---

*Fin del GDD v0.1 — Valores sujetos a balance en ISS-52.*