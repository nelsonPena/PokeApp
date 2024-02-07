

## Presentación del proyecto entregado

Este proyecto está desarrollado sobre arquitectura limpia **(Clean Architecture)** .
  
 - **Capa de Presentación (UI):** Esta capa maneja la interfaz de usuario y la interacción con el usuario. 

-   **Capa de Dominio (Domain):** Esta capa contiene la lógica de negocio central de la aplicación. 

-   **Capa de Datos (Data):** La capa de datos se encarga del acceso y almacenamiento de datos. Incluye componentes como repositorios, proveedores de datos y cualquier lógica relacionada con la persistencia o la recuperación de información.

En la capa de presentación se está utilizando el patrón de diseño modelo vista vista modelo **(MVVM)**.

Otros patrones de diseño utilizados es **Factory** para construir todas las instancias que requiere cada vista.

Para generar el mapeo y convertir los datos de una capa a otra se están utilizando funciones de tipo **Mapper** para convertir listas o estructuras a datos específicos usados en cada capa.
 
Se implementó un buscador basado en las herramientas que nos brinda **SwiftUI** utilizando variables reactivas tipo **@State** para refrescar el objeto que alimenta la tabla principal.

También se implementó uso de almacenamiento permanente **CoreData** para implementar un cacheo de todas las respuestas las cuales sólo se reciben una vez desde el servidor, ya que en el segundo ingreso a la aplicación se obtienen directamente de la base de datos local.

Se implementó manejo de errores los cuales se mapean entre las diferentes capas hasta llegar a la capa de presentación, donde se hace un mapeo de un mensaje de tipo string dejando esta responsabilidad netamente al objeto que construye dichos errores.

Tanto para las pruebas unitarias y la comunicación entre capas se aplica el principio Solid **Principio de Sustitución de Liskov (LSP - Liskov Substitution Principle)** el cual nos indica que las instancias de una clase base deben poder ser reemplazadas por instancias de sus clases derivadas sin afectar la corrección del programa. En otras palabras, las subclases deben ser sustituibles por sus clases base sin cambiar el comportamiento del programa.

Por lo tanto en la clase de pruebas se sustituyó el **httpClient** por un mock para poder simular una respuesta JSON de un servicio y tener seguridad que la decodificación se hace correctamente, el cual respeta el contrato que espera dicha clase haciendo enfásis sobre el uso de este el principio **Sustitución de Liskov (LSP - Liskov Substitution Principle)**

#### Ejemplo:

    let useCase = PokemonListFactory(httpClient: mockHTTPClient).createUseCase()

Al implementar arquitectura limpia tenemos casos de uso los cuales se ciñen al **Principio de Responsabilidad Única (SRP - Single Responsibility Principle)**  

En la arquitectura limpia, el **Principio de Inversión de Dependencia (Dependency Inversion Principle - DIP)** implica que las capas de nivel superior no deben depender directamente de las capas de nivel inferior, sino de abstracciones. Un ejemplo podría ser una aplicación que tiene una capa de presentación, una capa de dominio y una capa de datos.

Entre otros puntos donde en esta solución se hace uso constante de los principios **SOLID**

#### Video demo: 

https://youtu.be/bXQx9XmzN68?si=SDvRKppBo-6N-3dX


