# Códice — Nivel 1 (Dzibilchaltún)

| id | Título | Evento de desbloqueo (señal) | Condición | Fuentes | Estado |
|---|---|---|---|---|---|
| kool | Milpa (kool) | crop_planted | Primera siembra (cualquier cultivo) | CORDEMEX, TERAN1994, BASTARRACHEA1992, LANDA, REDFIELD1934 | pendiente |
| ixiim | Maíz (ixi'im) | crop_harvested | Cosecha de maíz (`crop_id == "maize"`) | CORDEMEX, BRICKER1998, TERAN1994, REDFIELD1934 | pendiente |
| waay | Wáay | creature_killed | Primer wáay eliminado | CORDEMEX, BRICKER1998, HOUSTON1989, REDFIELD1934 | pendiente |
| alux | Alux | offering_delivered | Ofrenda de saka' en el altar de los aluxes (`item_id == "saka"`). Ver nota 1 | CORDEMEX, REDFIELD1934 | pendiente |
| kisin | Kisin y Metnal | wave_started | Inicio de la noche 1 | CORDEMEX, THOMPSON1970, LANDA, CHRISTENSON2007 | pendiente |
| cha_chaak | Ch'a' Cháak | ritual_finished | Ritual Ch'a' Cháak completado (puntuación ≥ umbral) | LANDA, CORDEMEX, BRICKER1998, REDFIELD1934, TERAN1994 | pendiente |
| maya_numerals | Numerales mayas 0–19 | phase_changed | Primer resumen del amanecer (`phase == GameState.Phase.DAWN`) | BASTARRACHEA1992, BRICKER1998, CORDEMEX, LANDA | pendiente |
| kakaw | Cacao (kakaw) | cacao_changed | Primer cambio de cacao durante el juego. Ver nota 2 | CORDEMEX, LANDA | pendiente |
| uulum | Pavo (úulum) | inventory_changed | Primera pluma de pavo (`item_id == "turkey_feather"`). Ver nota 3 | CORDEMEX, BRICKER1998, LANDA, REDFIELD1934 | pendiente |
| tsiibil_chaaltun | Dzibilchaltún y cenote Xlacah | phase_changed | Primera Tarde del nivel 1 (`phase == GameState.Phase.AFTERNOON`) | ANDREWS1980, INAH, CORDEMEX | pendiente |

*Todas las entradas están en estado **pendiente** hasta revisión del hablante (ISS-41).*
*Fuente INAH consultada: 2026-10-04 (fichas oficiales de zonas arqueológicas en inah.gob.mx).*

## Notas para la Fase 2

1. **alux.** El altar (`alux_altar`) emite `offering_delivered` con `item_id == "saka"`. El templo emite la misma señal con los ítems de su ofrenda (GDD §9), que no incluye saka'. Por eso quien escuche la señal filtra por `item_id`: el códice desbloquea `alux` solo con `saka`, y el templo no cuenta el saka' en `GameState.offering_progress`.
2. **kakaw.** Cuenta cualquier `cacao_changed` emitido durante el juego (compra, venta, cacao de un wáay, reparación o devolución por pago exacto), así que no hace falta guardar el total anterior. No cuentan la carga de `starting_cacao` al iniciar el nivel ni `GameState.restore()`.
3. **uulum.** También cuenta una pluma comprada en el mercado (respaldo del GDD §8). Se acepta: la entrada trata del pavo, la pluma viene de uno y el corral empieza con 2 pavos.

## Ubicación de las citas

Para la revisión de ISS-41. Landa se cita por sección (§) y Redfield por página, siempre del "Ejemplar consultado" que indica `fuentes.md` en las claves `LANDA` y `REDFIELD1934`. No está comprobado que coincidan con las ediciones de referencia (Porrúa 1959 y Carnegie 1934), así que conviene cotejarlas.

| id | Afirmación | Ubicación |
|---|---|---|
| kool | Pedir permiso a los guardianes del monte antes de desmontar | REDFIELD1934, p. 126 |
| kool | Quema de la maleza; siembra con las lluvias y palo puntiagudo, cinco o seis granos | LANDA §XXIII |
| ixiim | Saka' ofrecido a los dioses | REDFIELD1934, p. 140 |
| ixiim | Primicias de una milpa nueva ofrecidas a los dioses | REDFIELD1934, p. 126 |
| waay | El wáay es el hechicero en forma animal; el perro, entre las formas comunes | REDFIELD1934, p. 178 |
| waay | Historias de wáay; la sal como remedio | REDFIELD1934, p. 179 |
| waay | Al final el wáay va a Metnal | REDFIELD1934, p. 180 |
| alux | Tamaño, barba y corona de barro; viven en montículos y figuras de barro | REDFIELD1934, pp. 119–120 |
| alux | Salen de noche; no silbar ni gritar; saka' para que no hagan daño; la milpa que cuidan siempre está verde | REDFIELD1934, p. 121 |
| kisin | Mitnal: lugar más bajo, adonde iban los malos (hambre, frío, cansancio, tristeza) | LANDA §XXXIII |
| cha_chaak | Rumbos y colores (oriente rojo, norte blanco, poniente negro, sur amarillo) | LANDA §XXXIV |
| cha_chaak | Cuatro Cháak en las cuatro esquinas del cielo | REDFIELD1934, p. 113 |
| cha_chaak | Se hace en sequía; participan todos los hombres | REDFIELD1934, p. 138 |
| cha_chaak | Ofrenda de saka' | REDFIELD1934, p. 140 |
| cha_chaak | Incienso; cuatro niños atados al altar croan como ranas | REDFIELD1934, p. 142 |
| maya_numerals | Cuenta de cinco en cinco hasta veinte, luego por 20, 400 y 8000; uso en el comercio del cacao | LANDA §XXIV |
| kakaw | Bebida espumosa de maíz y cacao | LANDA §XXI |
| kakaw | Comercio con Tabasco y Ulúa; cuentas de piedra y conchas coloradas como moneda; fiar y prestar sin usura | LANDA §XXIII |
| kakaw | Árboles de cacao en las heredades | LANDA §XXIV |
| kakaw | Fiesta de los dueños de cacaotales a Chac y otros dioses (mes Muan) | LANDA §XL |
| uulum | «Tierra de pavos y venados» | LANDA §II |
| uulum | Las mujeres crían aves de la tierra para comer | LANDA §XXXII |
| uulum | Ofrenda de cabezas de pavo con pan y bebidas de maíz | LANDA §XXXVI |
| uulum | El pavo, indispensable como ofrenda sagrada y comida de fiesta | REDFIELD1934, p. 47 |
| uulum | *Cutz* = pavo de monte | REDFIELD1934, p. 48 |

Todavía no tienen página anotada las afirmaciones que vienen de THOMPSON1970, TERAN1994, HOUSTON1989, CHRISTENSON2007, ANDREWS1980, INAH, CORDEMEX, BRICKER1998 y BASTARRACHEA1992.
