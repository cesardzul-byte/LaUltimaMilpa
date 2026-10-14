# Guion — La Última Milpa (nivel 1: Dzibilchaltún)

Textos que ve el jugador en el nivel 1. Las mecánicas vienen del GDD v0.3 (`docs/design/gdd.md`) y las grafías, de `docs/culture/glosario.md`. En español, los sitios llevan su nombre oficial del INAH (glosario §1). Todo queda pendiente de la revisión con el hablante (ISS-41). El códice está en `data/codex/` (ISS-19).

Las secciones 2 y 3 tienen como máximo 40 caracteres por línea, para que quepan en 480 px.

## 1. Intro

Una tarjeta por ilustración de `assets/illustrations/`.

| Tarjeta | Ilustración | Qué muestra | Texto |
|---|---|---|---|
| 1 | `intro_01` | La milpa de Ya'ax, verde entre milpas secas | Hacia el año 900, una larga sequía quema las milpas de Dzibilchaltún. Solo sigue verde la de Ya'ax, un joven milpero. |
| 2 | `intro_02` | Los wáay salen del monte de noche | Desde Metnal, Kisin envía cada noche a sus wáay para destruirla. Los aluxo'ob cuidan la milpa, pero Ya'ax tendrá que defenderla. |
| 3 | `intro_03` | El Templo de las Siete Muñecas bajo nubes de lluvia | Si Ya'ax resiste cinco noches y lleva la ofrenda al Templo de las Siete Muñecas, podrá pedir la lluvia con el Ch'a' Cháak. |

## 2. Avisos de fase

Cada aviso tiene dos renglones: el
título, en grande, y una línea debajo.
En las cinco fases, el título es
también el nombre de la fase en el HUD.

### Mañana

- Mañana
- Siembra, riega y cuida la milpa.

### Tarde

- Tarde
- Comercia en la plaza o ve al templo.

### Atardecer

- Atardecer
- Pon antorchas y ofrece saka' al alux.

### Noche

- Noche
- Los wáay de Kisin salen del monte.

### Amanecer

- Amanecer
- Los wáay vuelven a Metnal.

### Noche del jefe

Noche 5 (`boss_night`). Sustituye al
aviso de la Noche; el HUD sigue
diciendo «Noche».

- Última noche
- El Gran Wáay Pek' sale de Metnal.

### Otros avisos

Al morir Ya'ax:
- Ya'ax cayó. El día vuelve a empezar.

Al ofrecer saka' en el altar:
- El alux bendice esta noche.

Al amanecer, si no hubo saka':
- Sin saka', un alux hizo travesuras.

Al escapar un pavo:
- Un pavo con hambre escapó.

Al secarse o morir un cultivo:
- Un cultivo se perdió.

Tarde del día 5, ofrenda incompleta:
- Último día para la ofrenda.

## 3. Interfaz

Nombres visibles. Antes de los dos
puntos va el id del código o el lugar
donde aparece el texto.

### HUD

- Día
- Agua
- Cacao
- Vida
- Barra del jefe: Gran Wáay Pek'

### Herramientas (orden de Q)

- `spear`: Lanza
- `water_jar`: Cántaro
- `maize_seed`: Semilla de maíz
- `beans_seed`: Semilla de frijol
- `squash_seed`: Semilla de calabaza
- `copal_torch`: Antorcha de copal

### Ítems

- `maize`: Maíz
- `beans`: Frijol
- `squash`: Calabaza
- `maize_seed`: Semilla de maíz
- `beans_seed`: Semilla de frijol
- `squash_seed`: Semilla de calabaza
- `saka`: Saka'
- `copal`: Copal
- `turkey_feather`: Pluma de pavo
- Moneda: Cacao

### Defensas

- `albarrada`: Albarrada
- `copal_torch`: Antorcha de copal

### Deseables (ISS-33)

- `sling`: Honda
- `balam_statue`: Estatua de báalam
- `melipona_hive`: Colmena
- `honey`: Miel

### Acciones sobre Ya'ax

- Parcela vacía: Sembrar
- Parcela sin regar: Regar
- Parcela regada hoy: Regada
- Planta madura: Cosechar
- Corral: Alimentar
- Albarrada: Reparar
- Altar del alux: Ofrendar saka'

### Botones

Inicio y pausa:
- Jugar
- Continuar
- Códice
- Salir

Intro:
- Siguiente
- Saltar

Mapa del mundo:
- Dzibilchaltún
- Uxmal
- Chichén Itzá
- Ek' Balam
- Etiqueta: Bloqueada
- Aviso: Llegará en otra versión.

Tarde (mapa regional):
- Cenote Xlacah
- Plaza
- Templo de las Siete Muñecas

Mercado:
- Título: Mercado
- Comprar
- Vender
- Ficha: Punto (1)
- Ficha: Barra (5)
- Pagar
- Volver

Templo:
- Título: Ofrenda para Cháak
- Entregar
- Volver

Códice:
- Título: Códice
- Entrada bloqueada: Por descubrir
- Volver

Ritual:
- Título: Ch'a' Cháak
- Toca el tunk'ul al ritmo.
- Al fallar: El cielo no respondió.
- Reintentar

Fin:
- Volver a jugar
- Empezar de nuevo
- Salir

### Resumen del amanecer

El título lleva a la derecha el número
del día en numeración maya.

- Título: Amanecer del día
- `harvested`: Cosecha
- `creatures_killed`: Wáay derrotados
- `animals_lost`: Pavos perdidos
- `water_used`: Agua usada
- `cacao_earned`: Cacao ganado

### Mercado y templo

- Total
- Tu pago
- Cambio
- Descuento por pago exacto
- Ofrenda completa

### Mensajes

- No te queda agua.
- Te falta cacao.
- No tienes maíz para los pavos.
- Aquí no cabe la antorcha.
- Nueva entrada en el códice.

## 4. Tutorial

Pasos de `steps` en `data/levels/tutorial_01.tres`, en este orden. Cada paso se copia igual, sin el número.

1. Muévete con WASD o las flechas. Q cambia de herramienta y E la usa.
2. En la Mañana, elige una semilla con Q y pulsa E en una parcela vacía.
3. Riega con el cántaro cada día. Cuando la planta madure, cosecha con E.
4. Pulsa E en el corral para dar maíz a los pavos. Si comen, dan plumas.
5. Si una albarrada está dañada, pulsa E sobre ella para repararla con cacao.
6. En la Tarde, comercia en la plaza o lleva la ofrenda al templo.
7. Compra saka' en la plaza y ofrécelo en el altar del alux antes de la noche.
8. En el Atardecer, con la antorcha activa, pulsa E en suelo libre para ponerla.
9. De noche llegan los wáay de Kisin. Atácalos con la lanza: J o clic izquierdo.
10. Al amanecer se rellena el agua y lees el resumen: concha 0, punto 1, barra 5.

## 5. Mapa del mundo

| Ciudad | Estado | Texto |
|---|---|---|
| Dzibilchaltún | Nivel 1 | Cerca de la costa norte, Dzibilchaltún es la ciudad de Ya'ax y de la última milpa verde. |
| Uxmal | Bloqueada | Al sur, Uxmal levanta palacios de piedra labrada y también espera la lluvia. |
| Chichén Itzá | Bloqueada | Al sureste, Chichén Itzá crece alrededor de su gran cenote. |
| Ek' Balam | Bloqueada | Al oriente, Ek' Balam guarda su ciudad tras murallas de piedra. |

## 6. Mapa regional

| Sitio | Texto |
|---|---|
| Cenote Xlacah | El cenote Xlacah da agua dulce a Dzibilchaltún, y de él sale el agua de tu cántaro. En su fondo descansan las ofrendas de los antiguos. |
| Plaza | En la plaza se compra y se vende con cacao. Si pagas el total exacto, recibes un descuento. |
| Templo de las Siete Muñecas | Aquí se entrega la ofrenda para Cháak, en una o varias visitas. En los equinoccios, el sol sale alineado con sus puertas. |

## 7. Mercado y templo

### Mercado (comerciante de la plaza)

| # | Cuándo | Línea |
|---|---|---|
| 1 | Al abrir el mercado | Bienvenido a la plaza, Ya'ax. Aquí todo se paga con cacao. |
| 2 | Al mostrar el total | Arma el pago con puntos y barras. Si pagas justo, te hago descuento. |
| 3 | Pago exacto | ¡Pago exacto! Así da gusto comerciar. |
| 4 | Pago de más | Te pasaste; aquí está tu cambio. |
| 5 | Pago de menos | Con eso no alcanza. Cuenta otra vez. |

### Templo (guardián del templo)

| # | Cuándo | Línea |
|---|---|---|
| 1 | Al entrar | Ya'ax, sin lluvia la milpa muere. Trae la ofrenda para Cháak. |
| 2 | Al ver la lista | Cháak pide maíz, frijol, calabaza, plumas de pavo, copal y cacao. |
| 3 | Entrega parcial | Lo recibo. Todavía falta parte de la ofrenda. |
| 4 | Tarde del día 5, ofrenda incompleta | Hoy es el último día. Sin ofrenda no habrá lluvia. |
| 5 | Ofrenda completa | La ofrenda está completa. Resiste la última noche y pediremos la lluvia. |

## 8. Finales

### Con lluvia

Tras el Ch'a' Cháak con `pass_score` o más.

El tunk'ul resuena y los cuatro Cháak responden desde los rumbos del cielo. La lluvia cae sobre la milpa y los wáay vuelven a Metnal. Este año, Dzibilchaltún tendrá maíz.

### Sin lluvia

Al derrotar al Gran Wáay Pek' con la ofrenda incompleta. Después, la partida empieza otra vez en el día 1 (botón «Empezar de nuevo»).

El Gran Wáay Pek' cayó, pero la ofrenda no llegó completa al templo. El cielo sigue seco y Ya'ax vuelve a sembrar desde el primer día.

### Pantalla de fin del prototipo

Después del final con lluvia. Botones «Volver a jugar» y «Salir».

- Título: Fin del prototipo
- Texto: Gracias por jugar La Última Milpa. Uxmal, Chichén Itzá y Ek' Balam esperan su lluvia en una próxima versión.

## 9. Términos mayas usados

Todos con la grafía de `docs/culture/glosario.md`. Las palabras del español de origen indígena (milpa, cenote, cacao, copal) se usan como en el GDD y no son términos del glosario.

| Término | Secciones | Nota | Revisión |
|---|---|---|---|
| Ya'ax | 1, 2, 3, 5, 7, 8 | | revisar con hablante |
| Kisin | 1, 2, 4 | | revisar con hablante |
| Metnal | 1, 2, 8 | | revisar con hablante |
| wáay | 1, 2, 3, 4, 8 | En español, plural invariable: «los wáay». | revisar con hablante |
| Gran Wáay Pek' | 2, 3, 8 | | revisar con hablante |
| alux | 2, 3, 4 | | revisar con hablante |
| aluxo'ob | 1 | Plural en maya de alux. | revisar con hablante |
| Cháak | 3, 6, 7, 8 | | revisar con hablante |
| Ch'a' Cháak | 1, 3, 8 | | revisar con hablante |
| saka' | 2, 3, 4 | | revisar con hablante |
| tunk'ul | 3, 8 | | revisar con hablante |
| báalam | 3 | Deseable. | revisar con hablante |
| Dzibilchaltún | 1, 3, 5, 6, 8 | Nombre oficial INAH de Ts'íibil Cháaltun. | revisar con hablante |
| Xlacah | 3, 6 | Nombre oficial INAH de Xlakaj (cenote). | revisar con hablante |
| Uxmal | 3, 5, 8 | Nombre oficial INAH. | revisar con hablante |
| Chichén Itzá | 3, 5, 8 | Nombre oficial INAH de Chi'ch'e'en Itsa'. | revisar con hablante |
| Ek' Balam | 3, 5, 8 | Nombre oficial INAH de Ek' Báalam. | revisar con hablante |
