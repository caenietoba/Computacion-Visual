# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Implementar un modelo de iluminación que combine luz ambiental con varias fuentes puntuales de luz especular y difusa. Tener presente _factores de atenuación_ para las fuentes de iluminación puntuales.
3. (grupos de dos o más) Implementar el [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping).

## Integrantes

Complete la tabla:

|  Integrante  | github nick |
|--------------|-------------|
| Camilo Nieto | caenietoba  |

## Informe

(elabore en este sección un informe del ejercicio realizado)

## Entrega

Fecha límite ~~Lunes 1/7/19~~ Domingo 7/7/19 a las 24h. Sustentaciones: 10/7/19 y 11/7/19.

-------------------------------------------------------------------------------------------------------------

# Solución

Los 3 puntos estan desarrollados en el mismo codígo 'shaders.pde'.

Se han implementado como plus algunas opciones de interacción para poder manejar el programa con el teclado y el mouse.

  |   Interacción   |                                       Acción                                        |
  |-----------------|-------------------------------------------------------------------------------------|
  | Mover mouse     | Mueve la lata                                                                       |
  | Arrastrar mouse | Mueve la fuente de luz                                                              |
  | Tecla b         | Quita o pone la textura de la lata                                                  |
  | Tecla v         | Intercambia entre el video y la imagen copmo textura                                |
  | Tecla r         | Rota la lata sobre el eje y                                                         |
  | Tecla k         | Activa las máscaras de convolución en el shader                                     |
  | Tecla l         | Activa el modleo de iluminación en el shader                                        |
  | Tecla ñ         | Desactiva los shaders                                                               |
  | Tecla l y 1     | Si las iluminación esta activa entonces le agregara luz ambiental                   |
  | Tecla l y 2     | Si las iluminación esta activa entonces le agregara luz difusa                      |
  | Tecla l y 3     | Si las iluminación esta activa entonces le agregara luz especular                   |
  | Tecla k y 1     | Si las máscaras estan activas entonces cambiara la máscara a detección de bordes    |
  | Tecla k y 2     | Si las máscaras estan activas entonces cambiara la máscara a sharpen                |
  | Tecla k y 3     | Si las máscaras estan activas entonces cambiara la máscara a emboss                 |
  | Tecla k y 4     | Si las máscaras estan activas entonces cambiara la máscara a simple blur            |
  | Tecla k y 5     | Si las máscaras estan activas entonces cambiara la máscara a gaussian 3x3           |
  | Tecla k y 6     | Si las máscaras estan activas entonces cambiara la máscara a random                 |
  | Tecla k y 7     | Si las máscaras estan activas entonces cambiara la máscara a laplaciana             |
  | Tecla k y 8     | Si las máscaras estan activas entonces cambiara la máscara a motion blur            |
  | Tecla k y 9     | Si las máscaras estan activas entonces cambiara la máscara a media de interpolación |
  | Rueda del mouse | Aleja o acerca la camara                                                            |


## 1. Máscaras de convolución

Esta funcionalidad se implemento con un solo shader 'convolutionfrag.glsl' el cual recibe un arreglo de tipo float que representara la máscara de convolución, ese arreglo tendrá que ser pasado en la variable 'mask' del shader. De esta forma solo se necesita un shader independientemente de los valores de la máscara o del tamaño de esta.

Benchmark:

  |       máscara      | Software | Shader |
  |--------------------|----------|--------|
  | Edges detection    |    12    |   58   |
  | Sharpen            |    12    |   58   |
  | Emboss             |    12    |   60   |
  | Simple blur        |    12    |   59   |
  | Gaussian 3x3       |    12    |   57   |
  | Random             |    12    |   58   |
  | Laplaciana         |     6    |   58   |
  | Motion blur        |     6    |   60   |
  | Interpolation mean |     6    |   60   |

## 2. Iluminación phong

El modelo de iluminación Phong es un modelo usado en programación visual para simular como se comporta la luz al iluminar la superficie de un objeto. 

Este modelo usa 3 componentes básicos loc cuales son: 

    *Ambiente: La luz que llega rebotada de las paredes, los muebles, etc., se refleja en todas las direcciones simultáneamente.
    *Difusa: La luz que llega directamente desde la fuente de luz pero rebota en todas direcciones, combinada con la luz ambiental definen el color del objeto.
    *Especular: La luz que llega directamente de la fuente de luz y rebota en una dirección, según la normal de la superficie. Es la que afecta al "brillo" de la superficie.

Fue implementado con un shader compuesto por 'lightfrag' y 'vertfrag' que contiene los 3 tipos de luz básicos, en esta implementación solo se permite una fuente de luz. 

La luz ambiental se implemento tomando el color de la fuente de luz y y multiplicandolo por un factor por defecto de 0.1 pero que puede ser pasado como parametro al shader.

La luz difusa y especular fueron implementadas tanto en el vertex como en el fragment de forma que en el vertex se calculo la dirección de la luz y de la camara que esta viendo el objeto(especular), y esas direcciones son tomadas por el fragment para calcular la luz que cada una genera y donde debe ser mostrada. La luz difusa va a usar la normal para dicho procedimiento mientras que la especular usara la reflejada o en otras palabras la que se genera entre el ojo y la normal. 

Al final se suman los 3 tipos de luces para obtener la iluminación Phong.

## 3. Bump mapping.



