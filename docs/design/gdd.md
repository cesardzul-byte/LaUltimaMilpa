# GDD — La Última Milpa (nivel 1: Dzibilchaltún)

Versión 0.3. Valores iniciales; el balance final se hace en ISS-52. Términos y grafías según `docs/culture/glosario.md`. Todos los números están en la §12.

## 1. Bucle del día

| Fase | Duración | Qué se hace |
|---|---|---|
| Mañana | 100 s | Sembrar, regar, cosechar, alimentar pavos, reparar albarradas |
| Tarde | 70 s | Mapa regional: mercado (plaza) u ofrenda en el templo |
| Atardecer | 30 s | Colocar antorchas de copal; ofrenda de saka' en el altar |
| Noche | 110 s | Oleada de wáay; al terminar el tiempo, los que quedan se retiran |
| Amanecer | 20 s | Resumen en numeración maya; los cultivos crecen; el agua se rellena; `GameState.snapshot()` |

**Total: 330 s = 5:30 min.** El nivel dura 5 días.

## 2. Controles

| Acción | Teclas | Uso |
|---|---|---|
| `move_up/down/left/right` | WASD / flechas | Moverse |
| `interact` | E | Sembrar, regar, cosechar, alimentar, reparar, comerciar, ofrendar |
| `attack` | J / clic izquierdo | Lanza (honda si es la herramienta activa) |
| `cycle_tool` | Q | Cambiar herramienta, semilla o defensa |
| `pause` | Esc | Pausa |

## 3. Cultivos (maíz, frijol, calabaza)

- 9 parcelas (`plots`). Sembrar: `interact` en parcela vacía con una semilla activa.
- Regar con el cántaro (`water_jar`) gasta el `water_per_day` del cultivo del agua de `GameState`. El agua se rellena al máximo cada amanecer.
- Al amanecer, cada parcela regada ese día avanza un día. Tras `wither_days` días seguidos sin agua, la planta se seca y la parcela queda vacía.
- Los wáay pueden dañar cultivos; con vida 0, la parcela queda vacía.

## 4. Pavos

- El corral empieza con 2 pavos (`turkey`, úulum). Cada día comen `feed_per_day` maíz (`interact` en el corral).
- Un pavo alimentado da 1 `turkey_feather` cada `produce_interval` días. Si pasa `days_unfed_to_escape` días sin comer, escapa.
- Los wáay atacan a los pavos; con vida 0 se emite `animal_died`.
- Deseable: colmena de meliponas (`melipona_hive`, `needs_food = false`) que da `honey`.

## 5. Aluxes y ofrenda de saka'

- Los aluxes son los guardianes de la milpa, no enemigos: no se les puede atacar.
- Ofrenda: `interact` en el altar (`alux_altar`) con 1 `saka` antes de la noche. Bendición de esa noche: las criaturas aparecen más espaciadas (`blessing_spawn_mult`).
- Sin ofrenda ese día, al amanecer un alux camina por la milpa, retrasa `mischief_growth_loss` día en `mischief_plots` parcelas al azar y desaparece (animación `vanish`).

## 6. Criaturas y jefe

- Kisin, señor de Metnal, envía a los wáay cada noche. No aparece en pantalla: solo se nombra en la intro y en los textos. Los wáay atacan a Ya'ax, a los pavos, a los cultivos y a las albarradas que les cierran el paso.
- Wáay Pek' (terrestre, MVP). Wáay Kot (vuela y salta albarradas, deseable; si se recorta, sus lugares en las oleadas pasan a Wáay Pek').
- **Jefe:** el Gran Wáay Pek' (`gran_waay_pek`) aparece en la noche 5 con su oleada. Usa el sprite del Wáay Pek' escalado ×2, tiene más vida y un patrón propio: además de morder, cada `charge_cooldown` segundos embiste en línea recta hacia Ya'ax. Esa noche no tiene límite de tiempo: termina al derrotarlo.
- Las criaturas aparecen en `creature_spawns` (4 o más) y sueltan cacao al morir.

## 7. Defensas

- **Albarrada** (koot): cercas de piedra ya colocadas alrededor de la milpa y el corral. Bloquean el paso (capa `walls`). En la Mañana se reparan con `interact`, que cuesta cacao.
- **Antorcha de copal:** se coloca en suelo libre en la Tarde o el Atardecer y quema a las criaturas en su radio.
- **Estatua de báalam** (deseable): daño en área.

## 8. Economía y descuento por pago exacto

- Moneda: cacao. El mercado está en la plaza del mapa regional: en la Tarde, el botón de la plaza abre la pantalla del mercado. No hay mercado en la milpa. Se compran semillas, saka', copal y, como respaldo, cosechas y plumas; se venden cosechas, plumas y miel.
- **Pago exacto:** la compra se cobra junta y el total se muestra en numeración maya. El jugador arma el pago con fichas de punto (1) y barra (5). Si la suma es igual al total, recibe de vuelta `floor(total × exact_payment_discount)` cacao, así que las compras menores de 10 cacao no tienen descuento. Si paga de más, recibe el cambio sin descuento; si paga de menos, no hay venta.

## 9. Ofrenda del templo

Se entrega en el templo del mapa regional durante la Tarde, en una o varias visitas. Los ítems entregados salen del inventario y el progreso se guarda en `GameState`. Debe estar completa al cerrar la Tarde del día 5.

| Ítem | Cantidad |
|---|---|
| `maize` | 10 |
| `beans` | 8 |
| `squash` | 4 |
| `turkey_feather` | 3 |
| `copal` | 2 |
| cacao | 30 |

Con el inventario inicial y las 9 parcelas (5 de maíz, 2 de frijol y 2 de calabaza), la ofrenda se completa incluso con el rendimiento mínimo.

## 10. Victoria y derrota

**Victoria:** sobrevivir 5 noches con la ofrenda completa y derrotar al Gran Wáay Pek'. Al amanecer empieza el ritual Ch'a' Cháak, un minijuego de ritmo con el tunk'ul. Con `pass_score` o más llega la lluvia y se pasa a la pantalla de fin. Si falla, el ritual se repite. Si el plan de recorte convierte el ritual en cinemática, se da por superado.

**Derrota:**

1. **Vida en 0 (supuesto 15):** la causa cualquier criatura en cualquier noche, incluido el Gran Wáay Pek' en la noche 5. Se emite `player_died` y `GameState.restore()` devuelve todo al snapshot del amanecer; se repite el día actual. No se guarda en disco.
2. **Ofrenda incompleta:** el Gran Wáay Pek' aparece igual en la noche 5. Si al derrotarlo la ofrenda no está completa, no hay ritual: la pantalla de fin muestra el final "sin lluvia" y la partida se reinicia desde el día 1.

## 11. Efectos de sonido y música

| ID | Evento | ID | Evento |
|---|---|---|---|
| `sfx_plant` | Sembrar | `sfx_trade` | Comprar o vender |
| `sfx_water` | Regar | `sfx_exact_payment` | Pago exacto con descuento |
| `sfx_harvest` | Cosechar | `sfx_offering_saka` | Ofrenda en el altar |
| `sfx_crop_withered` | Un cultivo se seca o muere | `sfx_alux_mischief` | Travesura del alux al amanecer |
| `sfx_feed` | Alimentar pavos | `sfx_temple_offering` | Entrega en el templo |
| `sfx_turkey_escape` | Un pavo escapa | `sfx_wave_start` | Empieza la noche |
| `sfx_repair` | Reparar albarrada | `sfx_boss_appear` | Aparece el Gran Wáay Pek' |
| `sfx_place_defense` | Colocar antorcha o estatua | `sfx_rhythm_hit` | Acierto en el tunk'ul |
| `sfx_spear_swing` | Ataque con lanza | `sfx_rhythm_miss` | Fallo en el tunk'ul |
| `sfx_sling_throw` | Disparo de honda (deseable) | `sfx_ui` | Cambiar herramienta o botón de menú |
| `sfx_hit` | Un golpe impacta | `sfx_player_hurt` | Ya'ax recibe daño |
| `sfx_creature_death` | Muere una criatura | `sfx_player_death` | Ya'ax muere |
| `music_intro` | Cinemática inicial | `music_night` | Fase Noche (noches 1–4) |
| `music_morning` | Fase Mañana | `music_boss` | Noche 5 |
| `music_afternoon` | Fase Tarde y mapas | `music_dawn` | Amanecer (resumen) |
| `music_dusk` | Fase Atardecer | `music_ritual` | Ch'a' Cháak |
| `music_end` | Pantalla de fin | | |

Total: 24 efectos y 9 pistas.

## 12. Tabla de valores

**Nivel** — `data/levels/level_01.tres` (`LevelData`)

| Campo | Valor | Unidad |
|---|---|---|
| `morning_duration` / `afternoon_duration` / `dusk_duration` / `night_duration` / `dawn_duration` | 100 / 70 / 30 / 110 / 20 | s |
| `days` / `boss_night` | 5 / 5 | día |
| `max_water` | 100 | agua |
| `starting_cacao` | 30 | cacao |
| `starting_inventory` | `maize_seed` 5, `beans_seed` 2, `squash_seed` 2, `maize` 6 | unidades |
| `starting_turkeys` | 2 | pavos |
| `exact_payment_discount` | 0.10 | fracción |
| `blessing_spawn_mult` | 1.3 | × intervalo |
| `mischief_plots` / `mischief_growth_loss` | 2 / 1 | parcelas / día |
| `offering_requirements` | §9 | unidades |

**Cultivos** — `data/crops/{maize,beans,squash}.tres` (`CropData`)

| id | `growth_days` (días) | `water_per_day` (agua) | `wither_days` (días) | `yield_min`–`yield_max` (unid.) | `max_health` (HP) |
|---|---|---|---|---|---|
| `maize` | 3 | 10 | 2 | 3–5 | 20 |
| `beans` | 2 | 8 | 2 | 3–5 | 20 |
| `squash` | 3 | 12 | 2 | 2–3 | 20 |

**Ítems** — `data/items/<id>.tres` (`ItemData`); "—" = no se comercia

| id | `buy_price` (cacao) | `sell_price` (cacao) |
|---|---|---|
| `maize` / `beans` / `squash` | 5 / 4 / 6 | 3 / 2 / 4 |
| `maize_seed` / `beans_seed` / `squash_seed` | 3 / 2 / 3 | — |
| `saka` / `copal` | 8 / 6 | — |
| `turkey_feather` | 8 | 5 |
| `honey` (deseable) | — | 6 |

**Animales** — `data/animals/<id>.tres` (`AnimalData`)

| id | `max_health` (HP) | `needs_food` | `feed_per_day` (maíz) | `produce_item` | `produce_interval` (días) | `days_unfed_to_escape` (días) |
|---|---|---|---|---|---|---|
| `turkey` | 30 | true | 1 | `turkey_feather` | 2 | 2 |
| `melipona_hive` (deseable) | 20 | false | 0 | `honey` | 2 | — |

**Criaturas** — `data/creatures/<id>.tres` (`CreatureData`)

| id | `max_health` (HP) | `move_speed` (px/s) | `damage` (HP) | `attack_cooldown` (s) | `attack_range` (px) | `flies` | `cacao_drop_min`–`max` (cacao) |
|---|---|---|---|---|---|---|---|
| `waay_pek` | 50 | 60 | 10 | 1.5 | 24 | false | 3–6 |
| `waay_kot` (deseable) | 35 | 90 | 8 | 1.0 | 32 | true | 5–8 |
| `gran_waay_pek` | 400 | 40 | 25 | 2.5 | 48 | false | 0 |

**Defensas** — `data/defenses/<id>.tres` (`DefenseData`)

| id | `blocks` | `max_health` (HP) | `radius` (px) | `damage_per_second` (HP/s) | `cost` (cacao) | `repair_amount` (HP) | `repair_cost` (cacao) |
|---|---|---|---|---|---|---|---|
| `albarrada` | true | 150 | 0 | 0 | 0 (ya colocada) | 50 | 2 |
| `copal_torch` | false | 60 | 64 | 5 | 12 | — | — |
| `balam_statue` (deseable) | false | 150 | 96 | 10 | 18 | — | — |

**Oleadas** — `data/waves/wave_0N.tres` (`WaveData`)

| Noche | `creatures` (id × cantidad) | `spawn_interval` (s) |
|---|---|---|
| 1 | `waay_pek` ×3 | 8 |
| 2 | `waay_pek` ×5 | 7 |
| 3 | `waay_pek` ×4, `waay_kot` ×2 | 6 |
| 4 | `waay_pek` ×6, `waay_kot` ×2 | 5 |
| 5 | `gran_waay_pek` ×1, `waay_pek` ×4 | 6 |

**Ritual** — `data/levels/cha_chaak_chart.tres` (`RhythmChartData`): `bpm` 90 pulsos/min, `length` 45 s, `hit_window` 0.15 s, `pass_score` 0.7 (fracción).

**Ya'ax, armas y jefe** — campos sin clase de datos en ISS-05; son `@export` de sus escenas:

| Destino | Campo | Valor | Unidad |
|---|---|---|---|
| `src/player/player.tscn` | `max_health` / `move_speed` / `invulnerability_time` | 100 / 80 / 0.5 | HP / px/s / s |
| `src/combat/weapons/spear.tscn` | `damage` / `range` / `cooldown` | 25 / 24 / 0.6 | HP / px / s |
| `src/combat/weapons/sling.tscn` (deseable) | `damage` / `range` / `cooldown` | 15 / 160 / 1.2 | HP / px / s |
| `src/creatures/bosses/gran_waay_pek.tscn` | `scale` / `charge_cooldown` / `charge_speed` | 2 / 6 / 160 | × / s / px/s |
