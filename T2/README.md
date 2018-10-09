# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo; y,
2. Sombrear su superficie a partir de los colores de sus vértices.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Opcionales:

1. Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas; y,
2. Sombrear su superficie mediante su [mapa de profundidad](https://en.wikipedia.org/wiki/Depth_map).

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/frames/releases).

## Integrantes

Dos, o máximo tres si van a realizar al menos un opcional.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| David Andres Hoyos R           |   wolfstain          |
| Cristian Camilo Cristancho C          |    cccristanchoc         |

## Discusión: 

Para el taller se crearon 2 funciones edgeValida() y edge, las cuales reciben los valores de los vértices del triangulo y el punto a evaluar (centro del píxel), y en ellas se realizar el calculo por coordenadas baricéntricas si el punto esta dentro del triangulo formado por sus vértices, ademas de calcular un valor de color en RGB según la distancia del punto con respecto a sus vértices.
Se aplico el [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) usado en la pagina guia, aplicandose a las aristas del triangulo y generando un sombreado mas suave a los puntos de las subdivisiones cercanas a la linea.
Se sombreo la superficie del triangulo por su mapa de profundidad, esto se realizo usando la función interna en frames scene.eye().location('vértice del triangulo').z() en cual muestra su posición en dicho eje (z) con respecto a la pantalla, esto se computa con los valores 'lambda', obtenidos, por las coordenadas baricéntricas de los puntos que están dentro del triangulo, y este valor se multiplica al correspondiente valor RGB de dicho punto. Se puede habilitar o deshabilitar la profundidad con la tecla 'z'.


## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes.
* Plazo: 30/9/18 a las 24h.
