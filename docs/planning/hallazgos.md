# Hallazgos — ISS-14 · Guion y textos del nivel 1

Revisión del PR #41 (rama `docs/14-guion-textos`, commit `55a3b4d`) del 2026-10-14. Revisa `docs/design/guion.md` y `data/levels/tutorial_01.tres` contra el issue, el GDD v0.3, el glosario y el código de `develop`.

**Resultado:** cumple los 5 criterios de aceptación y toda la entrega esperada. Hay 2 ajustes de texto que conviene hacer antes del merge (H1 y H2). Los demás hallazgos no bloquean y corresponden a otros issues.

## 1. Criterios de aceptación

| # | Criterio | Estado | Evidencia |
|---|---|---|---|
| 1 | 9 secciones; intro con 3 tarjetas de 2 oraciones como máximo | ✅ | 9 títulos `## 1.` a `## 9.`. Las tarjetas tienen 2, 2 y 1 oraciones. |
| 2 | `steps` igual a la sección 4 | ✅ | 10 pasos, mismo texto y orden. Godot 4.7.2 headless carga `TutorialData` con los 10 pasos y conserva acentos y apóstrofos. |
| 3 | Términos mayas con la grafía del glosario | ✅ | Los 17 términos de la §9 están en `glosario.md`, y no hay términos mayas fuera de la lista. La columna «Secciones» de la §9 es exacta. |
| 4 | Sin «nahual», «Xibalbá», «tres hermanas» ni animales del Viejo Mundo | ✅ | No hay resultados, tampoco con las grafías prohibidas del glosario §3.2 y §3.3. |
| 5 | Líneas de las §2 y §3 de 40 caracteres o menos | ✅ | Máximo: 39 (§2) y 38 (§3). |

El guion también coincide con el código y con los demás issues. El orden de Q es el de `TOOLS` en `player.gd`. Los textos de acción son los de `plot.gd` y los de ISS-21 e ISS-22. Las filas del resumen usan las claves de `day_stats` de ISS-18, y los ids de ítems y defensas existen en `data/`.

## 2. Hallazgos

| # | Hallazgo | Dónde | Acción propuesta | Responsable |
|---|---|---|---|---|
| H1 | El descuento por pago exacto se promete siempre. Según el GDD §8 (`floor(total × 0.10)`), las compras menores de 10 cacao no tienen descuento. | `guion.md` §6 (Plaza) y §7 (Mercado, línea 2) | Precisar «en compras de 10 cacao o más» en la §6 y suavizar la línea del comerciante. | ISS-14, antes del merge |
| H2 | «Resiste la última noche» no es exacto si la ofrenda se completa antes del día 5. | `guion.md` §7 (Templo, línea 5) | Cambiar a «Resiste hasta la última noche». | ISS-14, antes del merge |
| H3 | El plural se forma de dos maneras: «los wáay» usa el plural invariable del español y «los aluxo'ob», el plural maya. Además, el PR dice que el glosario no tiene «aluxes», pero sí aparece en `glosario.md` (fila de saka') y en el GDD §5. | `guion.md` §1, tarjeta 2 | Llevarlo como duda al hablante en ISS-41 y unificar el criterio en el glosario §1. | ISS-41 |
| H4 | Los textos fuera de las §2 y §3 superan los 40 caracteres: tutorial hasta 77, diálogos unos 70, sitios hasta 136. No incumplen ningún criterio, pero no caben en una línea a 480 px. | `guion.md` §4 a §8 | Usar etiquetas con ajuste de línea automático (`autowrap`) en el tutorial, los mapas, el mercado, el templo y los finales. | Issues de la Fase 2 que muestren esos textos |
| H5 | El GDD §7 dice que la antorcha se coloca «en la Tarde o el Atardecer». El guion, el GDD §1 y ISS-21 dicen solo el Atardecer, y en la Tarde el jugador está en el mapa regional. | `gdd.md` §7 | Corregir el GDD §7 a «en el Atardecer». | Diseño (GDD) |
| H6 | `intro_01` a `intro_03` todavía son placeholders de color sólido. La columna «Qué muestra» de la §1 funciona como encargo para el ilustrador. | `assets/illustrations/` | Revisar que el arte final coincida con la §1 al entregarlo. | Issue de arte de la intro |

## 3. Proceso

- **Retraso:** la entrega era el 2026-09-30 (D2) y el PR se abrió el 2026-10-14, 14 días tarde. ISS-18 e ISS-24 dependen de este issue y están en el camino crítico de la Fase 1, que no tiene holgura. `src/ui/day_summary/` y `src/ui/hud/` siguen vacías, así que todavía no hay textos que sustituir.
- **Responsable:** la planeación asigna el issue a P4 (@ALEXANDER242164) y el commit es de CesarDzl. Si la reasignación se acordó, conviene anotarla en el issue #19.
- **Descripción del PR #41:** el checklist dice que la rama es `feat/ISS-14-guion-textos`, pero es `docs/14-guion-textos`. Hay que corregir esa línea. El PR sigue sin revisiones.
