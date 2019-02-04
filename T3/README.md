# Taller de representación

## Propósitos

1. Estudiar la relación entre las [aplicaciones de mallas poligonales](https://github.com/VisualComputing/representation), su modo de [representación](https://en.wikipedia.org/wiki/Polygon_mesh) (i.e., estructuras de datos empleadas para representar la malla en RAM) y su modo de [renderizado](https://processing.org/tutorials/pshape/) (i.e., modo de transferencia de la geometría a la GPU).
2. Estudiar algunos tipos de [curvas y superficies paramétricas](https://github.com/VisualComputing/Curves) y sus propiedades.

## Tareas

Empleando el [FlockOfBoids](https://github.com/VisualComputing/frames/tree/master/examples/demos/FlockOfBoids):

1. Represente la malla del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde) al menos de dos formas distintas.
2. Renderice el _flock_ en modo inmediato y retenido, implementando la función ```render()``` del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde).
3. Implemente las curvas cúbicas de Hermite y Bezier (cúbica y de grado 7), empleando la posición del `frame` del _boid_ como punto de control.


#Referencias:

  * [Splines: Curvas y superficies](http://www.inf-cr.uclm.es/www/cglez/downloads/docencia/AC/splines.pdf)

## Opcionales

Se Implementaron las curvas cúbicas naturales.

## Integrantes

Uno, o máximo dos si van a realizar al menos un opcional.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| David Andres Hoyos R |	wolfstain |
| Cristian Camilo Cristancho C  | cccristanchoc |

## Entrega

* Subir el código al repositorio de la materia antes del 3/2/19 a las 24h.
* Presentar el trabajo en la clase del 6/2/19 o 7/2/19.

## Indicaciones de uso
Pasos:
* 1- Oprimir la tecla 'f' para FaceToVertex o 'v' para VertexToVertex
* 2- Oprimir la tecla 'r' para modo retenido o 'i' para modo inmediato
* 3 Oprimir la tecla 'b' para mostrar cubica de bezier, 'n' para cubica natural o 'h' para cubica de hermite
* oprimir la tecla '4' o '7' para cambiar los grados de la curva de bezier
