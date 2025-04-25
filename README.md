# CC5408-Proyecto
Repositorio con proyecto del curso CC5408 - Taller de Diseño  de Videojuegos.
Integrantes:
 - Aldo Luna
 - Valentina Ramírez
 - Pablo Osorio

# Development

## Entities

### Player

### Ball

La pelota es un objeto que se mueve en el mapa y puede ser atacada por el jugador. Cuando es atacada por el jugador, esta se redireccionará en la dirección opuesta a la que se encontraba antes de ser atacada. Cuando la pelota se encuentra fuera de movimiento, se entrará en un estado de pausa momentaneo hasta que el jugador vuelva a golpearla. Dentro de este estado, las entidades presentes dejarán de moverse y reproducirán la animación "idle".

### Enemy

Los enemigos interactúan con la pelota recibiendo daño e impulso al contacto directo, excepto cuando no poseen retroceso en los golpes. Los enemigos pueden atacar directamente al jugador, en cuyo caso se le aplicará el retroceso, y se le dará el daño correspondiente.  

* Skeleton: Existen varios tipos de Skeletons, caracterizados por no poseer retroceso en los golpes y cada uno posee sus propios sprites y las siguientes animaciones:

  - Idle
  - Movement
  - Attack
  - Take damage
  - Death

# Description

* Título del juego: 'CatPongGame'

Descripción general:

'CatPongGame' es un juego de acción tipo roguelike, en el que el jugador controla a un gato mágico aventurero que debe realizar un ritual místico con su estambre, progresando con él a través de distintos niveles a medida que el jugador la golpea. Esta pelota es el núcleo de la mecánica del juego (mecánica innovadora): solo cuando está en movimiento el mundo cobra vida. En cambio, cuando la pelota se detiene, todo entra en un estado de pausa: los enemigos se congelan y el entorno queda suspendido, esperando a que el jugador vuelva a golpearla para reactivar el juego. La única forma de progresar en el juego es derrotando a los enemigos y llevando el estambre a la mesa de invocación para derrotar el Jefe Final del nivel. A medida que el jugador progrese, enfrentará diversos enemigos y adquirirá nuevas 'habilidades'.

- Mecánica principal: la Pelota (en un futuro: estambre)
La pelota se desplaza por el mapa y puede ser golpeada por el jugador.

Al ser golpeada, cambiará de dirección en sentido opuesto al del movimiento del jugador.

Si la pelota se detiene, el juego entra en un estado de pausa momentáneo: los enemigos y entidades dejan de moverse y pasan a una animación de reposo (idle). Solo al volver a golpear la pelota se reactiva el mundo.

- Interacciones con enemigos:

Los enemigos reciben daño e impulso al entrar en contacto con la pelota en movimiento, a menos que tengan una habilidad especial que los haga inmunes al retroceso.

Los enemigos también pueden atacar directamente al jugador, causando daño y retroceso.

El jugador debe usar la pelota estratégicamente para dañar y controlar a los enemigos, ya que solo cuando está en movimiento estos representan una amenaza activa. De esta forma la habilidad de predecir el movimiento de los enemigos y la pelota será crucial.

- Progresión y estilo de juego:

A medida que el jugador avanza, se enfrenta a oleadas de enemigos cada vez más desafiantes.

El jugador puede adquirir ventajas o habilidades tras derrotar enemigos o superar niveles, lo que permite adaptar su estilo de juego y facilitar su supervivencia en futuras etapas.

# Assets

Los assets utilizados en el proyecto son los siguientes:

- https://pixel-poem.itch.io/dungeon-assetpuck

- https://sscary.itch.io/the-adventurer-male

- https://pop-shop-packs.itch.io/cats-pixel-asset-pack

- https://opengameart.org/content/bouncing-ball-guy

