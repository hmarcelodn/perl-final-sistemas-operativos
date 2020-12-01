## Problema de Escritores/Lectores


El problema consiste en tener una base de datos como recurso crítico, procesos lectores y procesos escritores que deberán ser sincronizados para realizar operaciones sobre la misma. Los escenarios son los siguientes:

-   Solamente puede haber un escritor al mismo tiempo, si un escritor o un lector quiere utilizar la base de datos y hay un escritor utilizándose, entonces debe esperar.
    
-   Pueden haber varios lectores utilizando la base de datos al mismo tiempo, pero si un escritor quiere usar la base de datos mientras los lectores la usan, deberá esperar.
    
-   El último lector en usar la base de datos debe habilitarla para que pueda ingresar el siguiente escritor que estaba esperando la base de datos o en todo caso al siguiente proceso que requiera usarla.

## Análisis del problema de lectores/escritores

Antes de comenzar con la solución del simulador intentamos resolver el problema de los lectores/escritores utilizando una solución mediante semáforos como prueba de concepto para sincronizar distintas instancias de procesos lectores y escritores. La solución sincronizada que resultó efectiva es la siguiente.

[IMAGEN 1]

Teniendo el ejemplo sincronizado era posible deducir el funcionamiento de las diferentes colas de ejecución, listos, nuevos (correspondiente al planificador) y las colas correspondientes a los semáforos, según la estructura de datos citada en el libro de William Stallings.

[IMAGEN 2]

Entendiendo como se encolan los procesos en la estructura de datos de los semáforos da una idea de cómo se podrían simular los movimientos y bloqueos de todo el problema entero.

## Diagrama de clases

A continuación se expone el diagrama de clases con las abstracciones que fueron necesarias para construir el simulador y el detalle de cada operación de cada una de las abstracciones.

[IMAGEN 3]

## Ejecución

**TODO**: Agregar mas requisitos.

Requisitos:

 - [x] Tener PERL instalado
 - [x] Contar una terminal para ejecutar PERL

    perl simulador.pl

## Iniciar la simulación

Para iniciar la simulación utilizamos el comando siguiente dentro del directorio src

[IMAGEN 4]

Tras la ejecución del simulador, se presenta un menú con tres operaciones al usuario:

  

1.  **AGREGAR UN NUEVO PROCESO**: Permite al usuario agregar un nuevo proceso a la cola de procesos nuevos para que el planificador lo considere en los tiempos configurados.
    

2.  **MONITOREAR COLAS DE PLANIFICACIÓN**: Es el modo de monitor activo que permite visualizar las colas en tiempo real.
    

3.  **TERMINAR**: Finalizar simulación

### AGREGAR UN NUEVO PROCESO

Esta opción permite agregar en tiempo real un nuevo proceso a la cola de procesos nuevos y luego el planificador eventualmente colocara estos procesos nuevos en la cola de procesos listos para su ejecución.

### MONITOREAR COLAS DE PLANIFICACIÓN

  

Esta opción permite ver el uso de las diferentes colas por las cuales se mueven los procesos e información adicional:

1.  **CPU CICLO**: Muestra el ciclo actual de CPU (siempre ciclando)
    

2.  **PROCESOS NUEVOS**: Muestra cuántos procesos están en la cola de nuevos procesos.
    

3.  **PROCESOS LISTOS**: Muestra cuántos procesos están en la cola de listos procesos.
    

4.  **ESTADO DEL PROCESADOR**: Muestra el estado del procesador en el ciclo actual.
    

5.  **ÚLTIMO PROCESO EN EJECUCIÓN**: Muestra el último proceso que tuvo asignado el CPU.
    

6.  **CANTIDAD DE ESCRITORES ESPERANDO**: Muestra la cantidad de procesos escritores bloqueados por algún otro proceso lector o escritor.
    

7.  **CANTIDAD DE LECTORES ESPERANDO**: Muestra la cantidad de procesos lectores bloqueados esperando por la finalización de procesos escritores.

### TERMINAR

Finalizar la simulación  

### PLANIFICADOR

El planificador utiliza un algoritmo Round-Robin de **Quantum = 2**.  

### LOG EJECUCIÓN

El proceso guarda la traza de ejecución de la carpeta de logs en caso de querer visualizar el proceso completo.

### SIMULACIÓN

Dejamos una grabación en video del simulador en ejecución:

[simulacion.mov](https://drive.google.com/file/d/12LB4TKYDqdxVWp8QZhGKtk8E0tPdSWsD/view?usp=sharing)