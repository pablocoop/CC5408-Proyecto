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



# Assets

Los assets utilizados en el proyecto son los siguientes:

- https://pixel-poem.itch.io/dungeon-assetpuck

- https://sscary.itch.io/the-adventurer-male

- https://pop-shop-packs.itch.io/cats-pixel-asset-pack

- https://opengameart.org/content/bouncing-ball-guy

