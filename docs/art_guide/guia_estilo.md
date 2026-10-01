# Guía de estilo — La Última Milpa

## 1. Paleta
Paleta Aliasing 24 (Lospec), 24 colores. Archivo: `docs/art_guide/paleta.png`.


| # | Nombre | Hex |
|---|---|---|
| 1 | negro | `#121317` |
| 2 | blanco | `#ffffff` |
| 3 | gris-claro | `#b6b6c0` |
| 4 | gris-intermedio | `#696b6f` |
| 5 | gris-intermedio-alto | `#404247` |
| 6 | gris-alto | `#282a2e` |
| 7 | beige | `#d8b8a3` |
| 8 | cafe-claro | `#b67956` |
| 9 | cafe-intermedio | `#754427` |
| 10 | caoba | `#761917` |
| 11 | rust | `#c62423` |
| 12| naranja | `#cc5500` |
| 13| amarillo| `#efc12c` |
| 14| verde-claro| `#94a75b` |
| 15| verde-intermedio | `#458745` |
| 16| verde-intermedio-alto| `#336a33` |
| 17| verde-alto | `#224e22` |
| 18| deep-cyan | `#408080` |
| 19| azul-claro | `#72c6da` |
| 20| azul-intermedio | `#327acc` |
| 21| azul-alto | `#13406d` |
| 22| morado| `#49317e` |
| 23| violeta | `#8c4686` |
| 24| rosa | `#db5b82` |
## 2. Resolución y tamaños
Resolución base: 480×270, escalada ×4 a 1920×1080 con filtro Nearest (sin suavizado).
Pixel art puro: sin degradados ni transparencias parciales.

| Tipo | Tamaño de cuadro | Por qué |
|---|---|---|
| Tiles | 16×16 | Rejilla del mapa  |
| Ya'ax | 16×24 | Ancho de 1 tile, un poco más alto que una casilla |
| Alux | 16×16 | Es más pequeño que el Ya'ax |
| Wáay Pek' y Wáay Kot | 32×32 | Más grandes que Ya'ax: son amenaza |
| Cultivos | 16×16 (maíz 16×32 porque es alto) | Una parcela  |
| Animales | 16×16 | Un tile |
| Props | 16×16, 16×32 o 32×32 | Según el objeto (ver tabla de assets) |
| Efectos | 32×32 (piedra de honda 8×8) | |
| Íconos | 16×16 | |
| Glifos mayas | punto 4×4, barra 16×4, concha 16×8 | Se apilan en una columna de 16 px |
| Ilustraciones | 480×270 | Pantalla completa |

## 3. Hojas de sprites
Una hoja de sprites es una sola imagen PNG que reúne todos los dibujos de un personaje u objeto, acomodados en cuadrícula. Godot recorta cada dibujo y los muestra uno tras otro para crear la animación.
- **Cuadrícula sin espacios:** los cuadros van pegados entre sí, sin márgenes ni separaciones, para que Godot pueda recortarlos con exactitud.
- **Filas y columnas:** cada fila contiene una animación completa (por ejemplo, caminar) y cada columna es uno de sus dibujos. Los dibujos se leen de izquierda a derecha, en el orden en que se reproducen.
- **Ancho de la hoja:** se multiplica el ancho de un cuadro por el número de cuadros de la animación más larga. Ejemplo: Ya'ax mide 16 px de ancho y su animación más larga tiene 4 cuadros, así que la hoja mide 16 × 4 = 64 px de ancho.
- **Alto de la hoja:** se multiplica el alto de un cuadro por el número de animaciones. Ejemplo: Ya'ax mide 24 px de alto y tiene 8 animaciones, así que la hoja mide 24 × 8 = 192 px de alto.
- **Espacios vacíos:** si una animación tiene menos cuadros que la más larga, los lugares que sobran al final de su fila se dejan transparentes.
- **Animaciones de lado:** solo se dibuja la versión que mira hacia la derecha. Para que mire a la izquierda, Godot voltea la imagen automáticamente, así no hay que dibujarla dos veces.
## 4. Convención de nombres
- Solo minúsculas, números y guion bajo (`_`).
- Sin espacios, acentos, apóstrofos ni ñ. Ejemplo: Ya'ax → `ya_ax.png`.
- Archivos y animaciones en inglés (`maize`, `walk_down`); nombres mayas sin acentos (`waay_pek`, `tunkul`).
- Números con dos dígitos: `intro_01.png`.
## 5. Archivos fuente
Cada dibujo tiene dos versiones:
- **PNG final:** la imagen que usa el juego. Va en `assets/`.
- **Archivo editable:** el archivo del programa de dibujo, con sus capas (.psd, .kra, .aseprite, .piskel). Va en `art_source/` para poder corregir el dibujo más adelante.

El archivo editable lleva el mismo nombre que su PNG y se guarda en la carpeta de su tipo:
- Ya'ax, cultivos, animales y props → `art_source/characters/`
- Criaturas → `art_source/creatures/`
- Ilustraciones → `art_source/illustrations/`
- Íconos y numerales mayas → `art_source/ui/`

Ejemplo: `assets/sprites/characters/ya_ax.png` → `art_source/characters/ya_ax.kra`

## 6. Tabla de assets

| Ruta | Cuadro | Animaciones (cuadros) | Tamaño hoja |
|---|---|---|---|
| assets/sprites/characters/ya_ax.png | 16×24 | idle 4, walk_down 4, walk_up 4, walk_side 4, attack 3, use_tool 3, hurt 2, die 4 | 64×192 |
| assets/sprites/crops/maize.png | 16×32 | growth 4 (semilla, brote, planta, elote) | 64×32 |
| assets/sprites/crops/beans.png | 16×16 | growth 4 | 64×16 |
| assets/sprites/crops/squash.png | 16×16 | growth 4 | 64×16 |
| assets/sprites/animals/turkey.png | 16×16 | idle 2, walk 4 | 64×32 |
| assets/sprites/animals/melipona_hive.png | 16×16 | idle 2 | 32×16 |
| assets/sprites/creatures/waay_pek.png | 32×32 | idle 4, walk 4, attack 4, hurt 2 | 128×128 |
| assets/sprites/creatures/waay_kot.png | 32×32 | idle 4, fly 4, attack 4, hurt 2 | 128×128 |
| assets/sprites/creatures/alux.png | 16×16 | idle 4, walk 4, vanish 4 | 64×48 |
| assets/sprites/props/albarrada.png | 16×16 | intacta, dañada, destruida (3) | 48×16 |
| assets/sprites/props/copal_torch.png | 16×32 | burn 4 | 64×32 |
| assets/sprites/props/balam_statue.png | 32×32 | static 1 | 32×32 |
| assets/sprites/props/alux_altar.png | 32×32 | static 1 | 32×32 |
| assets/sprites/props/tunkul.png | 16×16 | hit 4 | 64×16 |
| assets/sprites/props/frog.png | 16×16 | idle 2, jump 4 | 64×32 |
| assets/sprites/effects/spear_slash.png | 32×32 | slash 4 | 128×32 |
| assets/sprites/effects/sling_stone.png | 8×8 | fly 2 | 16×8 |
| assets/ui/maya_numerals/dot.png | 4×4 | 1 | 4×4 |
| assets/ui/maya_numerals/bar.png | 16×4 | 1 | 16×4 |
| assets/ui/maya_numerals/shell.png | 16×8 | 1 | 16×8 |
| assets/illustrations/intro_01.png | 480×270 | 1 | 480×270 |
| assets/illustrations/intro_02.png | 480×270 | 1 | 480×270 |
| assets/illustrations/intro_03.png | 480×270 | 1 | 480×270 |
| assets/illustrations/world_map.png | 480×270 | 1 | 480×270 |
| assets/illustrations/region_map.png | 480×270 | 1 | 480×270 |

### Íconos (assets/ui/icons/, todos 16×16, 1 cuadro)
Lista propuesta; se ajusta cuando el GDD defina los ítems.

| Recursos | Herramientas |
|---|---|
| maize.png, beans.png, squash.png | spear.png (lanza) |
| maize_seed.png, beans_seed.png, squash_seed.png | coa.png (para sembrar) |
| water.png, cacao.png, saka.png, copal.png | water_jar.png (para regar) |
| | sling.png (honda) |
