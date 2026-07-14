# BanBan Usuarios - Documento de Requerimientos del Proyecto

## 1. Resumen del proyecto

BanBan Usuarios es una aplicación multiplataforma orientada al cliente final de la empresa BanBan, dedicada a la renta de artículos para fiestas en Uruapan, Michoacán. La aplicación estará enfocada en consulta de productos, validación de disponibilidad, registro de pedidos, simulación de pago y seguimiento de rentas desde una interfaz exclusiva para usuarios.[1]

El sistema será desarrollado en Flutter y utilizará Firebase como plataforma principal para autenticación con Google, base de datos y almacenamiento de información. A diferencia del planteamiento inicial, esta aplicación no compartirá funciones administrativas, ya que la operación interna será atendida desde una segunda aplicación separada para administradores.[1]

## 2. Planteamiento del problema

Actualmente, la renta de productos para fiestas se realiza principalmente mediante llamada telefónica o por WhatsApp. Este modelo obliga al cliente a preguntar manualmente por disponibilidad, horarios, fechas, precios y condiciones de entrega, lo que vuelve el proceso más lento, menos claro y más dependiente de atención directa.[1]

Además, cuando la consulta depende de medios manuales, el cliente no tiene una forma inmediata de explorar el catálogo o revisar el estado de su pedido por cuenta propia. Por ello, se propone una aplicación centrada en el usuario que permita consultar y gestionar su proceso de renta con mayor autonomía.

## 3. Objetivo general

Diseñar y documentar una aplicación para clientes que permita consultar productos, validar disponibilidad por fecha y zona, configurar pedidos, simular pagos y revisar el estado de sus rentas dentro de una plataforma clara, accesible y separada de la operación administrativa.

## 4. Objetivos específicos

- Centralizar el catálogo de productos disponibles para renta en una sola aplicación de usuario.
- Permitir navegación como invitado para consulta inicial del servicio.
- Exigir autenticación para concretar una renta.
- Implementar inicio de sesión con Google mediante Firebase Authentication.
- Permitir al cliente seleccionar fecha, horario, cantidades y datos necesarios para el pedido.
- Simular anticipo o liquidación total sin procesar pagos reales.
- Permitir al usuario consultar el estado de sus pedidos y recibir notificaciones relacionadas.
- Mantener una separación clara entre funciones de cliente y funciones administrativas.

## 5. Alcance del proyecto

La aplicación de usuarios permitirá explorar productos, consultar detalle individual, visualizar información del negocio, registrarse o iniciar sesión, configurar pedidos, registrar dirección y referencias, validar disponibilidad, simular un pago y revisar pedidos realizados. También permitirá mostrar estados del pedido y notificaciones internas asociadas a la cuenta del cliente.

La aplicación no incluirá edición de stock global, modificación de precios, alta o baja de productos, consulta de agenda completa ni cambios operativos sobre la entrega o recolección. Esas responsabilidades pertenecerán exclusivamente a la aplicación de administradores.[1]

## 6. Restricciones del proyecto académico

El proyecto será desarrollado con fines universitarios y no operará como plataforma comercial real. Por ello, no realizará cobros reales, no emitirá CFDI válidos, no se conectará a pasarelas de pago productivas y no generará comprobantes fiscales oficiales.[1]

Los pagos se representarán mediante simulaciones internas, incluyendo anticipo, liquidación, confirmación y estados de resultado. El objetivo es demostrar el flujo funcional del sistema sin involucrar dinero real ni obligaciones fiscales.

## 7. Contexto del negocio

La operación del negocio está enfocada en Uruapan, Michoacán, y el servicio deberá limitarse a la zona de cobertura definida por BanBan. Esto permitirá que la aplicación muestre únicamente pedidos viables dentro del alcance operativo del negocio.

El horario habitual de entrega será de 7:00 a.m. a 2:00 p.m. o 3:00 p.m., con posibilidad de extensión según la carga de trabajo del día. La recolección normalmente se realizará entre las 7:00 p.m. y las 9:00 p.m. o 10:00 p.m., según la logística disponible.[1]

## 8. Tecnologías principales

| Componente | Tecnología |
|---|---|
| Desarrollo multiplataforma | Flutter  |
| Autenticación | Firebase Authentication  |
| Inicio de sesión | Google Sign-In  |
| Base de datos | Cloud Firestore  |
| Almacenamiento de imágenes | Firebase Storage  |
| Notificaciones futuras | Firebase Cloud Messaging  |

## 9. Tipo de usuario

### 9.1 Invitado

El usuario podrá entrar como invitado para consultar el catálogo y explorar la aplicación sin autenticarse. Esta modalidad solo servirá para navegación y consulta general, no para concretar pedidos.

### 9.2 Cliente registrado

El cliente registrado podrá iniciar sesión con Google, crear pedidos, registrar datos de contacto, dirección y referencias, simular pagos, consultar el estado de sus pedidos y recibir notificaciones relacionadas con su actividad dentro de la aplicación.

## 10. Productos contemplados

La aplicación manejará inicialmente los siguientes productos:

- Brincolines.
- Sillas.
- Mesas.
- Losa.
- Manteles.

Los brincolines estarán clasificados en cuatro tipos:

- Grandes.
- Chicos.
- Redondos.
- Acuáticos.

La losa incluirá artículos como:

- Vasos.
- Platos.
- Botaneros.
- Trinches.
- Cucharas.
- Cuchillos.

Como referencia inicial del negocio, se contempla un inventario base de 300 sillas, 30 mesas y más de 100 manteles. Estos valores servirán como base para validaciones de disponibilidad e inventario dentro del sistema.[1]

## 11. Flujo general del usuario

1. El usuario entra a la aplicación como invitado o inicia sesión con Google.
2. Explora el catálogo de productos disponibles.
3. Selecciona un producto y revisa su detalle.
4. Configura cantidad, fecha, horario y datos necesarios para la renta.
5. Si no ha iniciado sesión, el sistema solicita autenticación para continuar.
6. El sistema valida disponibilidad con base en fecha, horario, zona y stock.
7. El usuario registra dirección, referencias y datos de contacto.
8. El usuario simula el anticipo o la liquidación del pedido.
9. El pedido queda registrado y puede consultarse desde la sección de pedidos agendados.
10. El usuario recibe seguimiento del estado del pedido mediante la aplicación.

## 12. Módulos principales del sistema

### 12.1 Inicio

La pantalla principal deberá mostrar el logo y nombre de BanBan junto con una vista general del catálogo. La interfaz deberá adaptarse a distintos tamaños de pantalla, manteniendo una sola columna en móviles y una distribución de varias columnas en pantallas más amplias.[1]

### 12.2 Catálogo

El catálogo mostrará los productos disponibles para renta con una presentación clara, visual y fácil de recorrer. Cada elemento deberá permitir al usuario abrir una vista más detallada.

### 12.3 Vista de producto individual

Cada producto tendrá una pantalla de detalle con imagen, nombre, descripción, disponibilidad general y opciones de configuración. Desde esta pantalla el usuario podrá elegir cantidad, fecha y horario.[1]

### 12.4 Carrito o configuración del pedido

El sistema deberá mostrar un resumen del pedido antes de pasar al pago simulado. Esta vista incluirá productos seleccionados, cantidad, fecha, horario, costo estimado y datos básicos del pedido.

### 12.5 Pedidos agendados

Esta sección permitirá consultar los pedidos asociados a la cuenta del usuario. Si no existen pedidos, el sistema deberá mostrar un estado vacío claro y entendible.[1]

### 12.6 Perfil

El perfil mostrará información básica del usuario autenticado y permitirá consultar su actividad principal, incluyendo historial de pedidos y cierre de sesión.

### 12.7 Notificaciones

La aplicación mostrará notificaciones internas sobre cambios importantes del pedido, como confirmación, avance de estado o avisos relacionados con la renta.

## 13. Requerimientos funcionales

### 13.1 Acceso y autenticación

- El sistema deberá permitir navegación como invitado.
- El sistema deberá exigir autenticación para completar una renta.
- El sistema deberá permitir inicio de sesión con Google mediante Firebase Authentication.

### 13.2 Catálogo y productos

- El sistema deberá mostrar el catálogo de productos disponibles.
- El sistema deberá presentar cada producto en formato responsivo.
- El sistema deberá permitir abrir una vista individual de cada producto.

### 13.3 Configuración de renta

- El usuario deberá poder seleccionar fecha de renta.
- El usuario deberá poder seleccionar horario.
- El usuario deberá poder elegir cantidades según el producto.
- El sistema deberá validar disponibilidad según fecha, zona y stock.

### 13.4 Pedido

- El sistema deberá registrar nombre, teléfono, dirección y referencias del cliente.
- El sistema deberá asociar cada pedido a la cuenta autenticada del usuario.
- El sistema deberá calcular un costo estimado con base en tipo de producto y cantidad.

### 13.5 Pago simulado

- El sistema deberá permitir anticipo o liquidación total simulada.
- El anticipo base será del 20 por ciento del total estimado.
- El sistema no deberá conectarse a servicios financieros reales.

### 13.6 Seguimiento del pedido

- El sistema deberá mostrar el estado actual de cada pedido del usuario.
- El sistema deberá mostrar notificaciones relacionadas con cambios de estado.
- El usuario solo deberá poder ver pedidos asociados a su propia cuenta.

## 14. Requerimientos no funcionales

- La aplicación deberá funcionar en Android, iPhone, Linux, Windows, macOS y navegador web.
- La interfaz deberá ser responsiva y fácil de usar.
- La arquitectura del proyecto deberá permitir mantenimiento y crecimiento futuro.
- La autenticación deberá estar protegida por Firebase Authentication.
- La base de datos deberá organizar claramente información de usuarios, productos y pedidos.
- La app de usuarios no deberá mezclar lógica administrativa con la lógica del cliente.

## 15. Reglas de negocio

- El servicio se limitará a la zona operativa de Uruapan, Michoacán.
- El usuario puede navegar como invitado, pero no puede rentar sin autenticarse.
- La disponibilidad dependerá de fecha, horario, zona y stock.
- El anticipo estándar será del 20 por ciento del total estimado.
- Si la cancelación ocurre demasiado cerca de la fecha del evento, el anticipo no se devolverá de forma completa.
- El precio dependerá del tipo de producto y de la cantidad seleccionada.
- El sistema no deberá permitir pedidos que excedan el stock disponible.

## 16. Estados del pedido visibles para el usuario

Los estados que podrá consultar el cliente serán:

- Reservado.
- En transcurso de entrega.
- Entregado.
- Pendiente de recolección.
- Finalizado.

## 17. Estructura de carpetas propuesta

La siguiente estructura está pensada para que el proyecto sea legible, organizado y sencillo de mantener dentro de Flutter. La intención es separar presentación, lógica del negocio, acceso a datos y configuración general del proyecto.[1]

```text
banban_usuarios/
├── Proyecto.md
├── pubspec.yaml
├── analysis_options.yaml
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── test/
└── lib/
    ├── main.dart
    ├── app/
    │   ├── app.dart
    │   ├── router.dart
    │   └── theme.dart
    ├── core/
    │   ├── constants/
    │   │   ├── app_constants.dart
    │   │   ├── route_names.dart
    │   │   └── firestore_keys.dart
    │   ├── utils/
    │   │   ├── validators.dart
    │   │   ├── formatters.dart
    │   │   └── app_date_utils.dart
    │   ├── services/
    │   │   ├── auth_service.dart
    │   │   ├── firestore_service.dart
    │   │   ├── notification_service.dart
    │   │   └── storage_service.dart
    │   └── errors/
    │       ├── app_exceptions.dart
    │       └── failure_messages.dart
    ├── data/
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   ├── product_model.dart
    │   │   ├── order_model.dart
    │   │   ├── order_item_model.dart
    │   │   ├── notification_model.dart
    │   │   └── business_settings_model.dart
    │   ├── datasources/
    │   │   ├── auth_remote_datasource.dart
    │   │   ├── product_remote_datasource.dart
    │   │   ├── order_remote_datasource.dart
    │   │   └── notification_remote_datasource.dart
    │   └── repositories/
    │       ├── auth_repository_impl.dart
    │       ├── product_repository_impl.dart
    │       ├── order_repository_impl.dart
    │       └── notification_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   ├── user.dart
    │   │   ├── product.dart
    │   │   ├── order.dart
    │   │   ├── order_item.dart
    │   │   └── app_notification.dart
    │   ├── repositories/
    │   │   ├── auth_repository.dart
    │   │   ├── product_repository.dart
    │   │   ├── order_repository.dart
    │   │   └── notification_repository.dart
    │   └── usecases/
    │       ├── sign_in_with_google.dart
    │       ├── sign_out.dart
    │       ├── get_products.dart
    │       ├── get_product_detail.dart
    │       ├── create_order.dart
    │       ├── get_user_orders.dart
    │       ├── get_order_detail.dart
    │       └── get_notifications.dart
    ├── presentation/
    │   ├── controllers/
    │   │   ├── auth_controller.dart
    │   │   ├── catalog_controller.dart
    │   │   ├── cart_controller.dart
    │   │   ├── orders_controller.dart
    │   │   └── profile_controller.dart
    │   ├── screens/
    │   │   ├── splash/
    │   │   │   └── splash_screen.dart
    │   │   ├── auth/
    │   │   │   ├── guest_access_screen.dart
    │   │   │   └── login_screen.dart
    │   │   ├── home/
    │   │   │   └── home_screen.dart
    │   │   ├── catalog/
    │   │   │   ├── catalog_screen.dart
    │   │   │   └── product_detail_screen.dart
    │   │   ├── cart/
    │   │   │   ├── cart_screen.dart
    │   │   │   └── checkout_screen.dart
    │   │   ├── orders/
    │   │   │   ├── orders_screen.dart
    │   │   │   └── order_detail_screen.dart
    │   │   ├── profile/
    │   │   │   └── profile_screen.dart
    │   │   └── notifications/
    │   │       └── notifications_screen.dart
    │   └── widgets/
    │       ├── app_bottom_navbar.dart
    │       ├── empty_state.dart
    │       ├── loading_view.dart
    │       ├── order_status_chip.dart
    │       ├── primary_button.dart
    │       └── product_card.dart
    └── firebase/
        ├── firebase_options.dart
        └── firestore_paths.dart
```

## 18. Explicación de la estructura

### `lib/app/`

Esta carpeta contendrá la configuración global de la aplicación, incluyendo inicialización visual, rutas y tema general. Su objetivo es centralizar la base estructural de la app.

### `lib/core/`

Aquí se colocarán constantes, utilidades, servicios compartidos y manejo de errores. Esta capa agrupa todo lo reutilizable que no pertenece exclusivamente a un módulo visual.

### `lib/data/`

Esta capa gestionará el acceso a Firebase. Aquí se ubicarán modelos, datasources y repositorios concretos que trabajen con Firestore, Authentication y otros servicios externos.

### `lib/domain/`

La carpeta de dominio contendrá entidades, contratos de repositorio y casos de uso. Esta separación ayuda a mantener la lógica del negocio desacoplada de la implementación técnica.

### `lib/presentation/`

Aquí se organizarán pantallas, controladores y widgets que forman la interfaz visible para el usuario. Es la capa encargada de representar el flujo de navegación y la interacción del cliente con la app.

### `lib/firebase/`

Esta carpeta servirá para centralizar configuración específica de Firebase y rutas reutilizables de Firestore, mejorando orden y mantenimiento del proyecto.

## 19. Estructura conceptual en Firestore

```text
users/{uid}
products/{productId}
orders/{orderId}
orders/{orderId}/items/{itemId}
notifications/{notificationId}
settings/business
```

### `users`

Guardará información del cliente autenticado, como nombre, correo, teléfono, rol, dirección base y datos necesarios del perfil.

### `products`

Contendrá el catálogo visible de productos, incluyendo nombre, categoría, precio base, stock de referencia, estado activo e imagen si existe.

### `orders`

Almacenará cada pedido realizado por un cliente, con datos como uid del usuario, fecha del evento, horario, dirección, total estimado, anticipo y estado actual.

### `orders/{orderId}/items`

Guardará el detalle de los productos asociados a cada pedido, incluyendo cantidad, precio estimado y notas necesarias.

### `notifications`

Permitirá almacenar avisos dirigidos al usuario, como confirmaciones, actualizaciones o recordatorios de su pedido.

### `settings/business`

Contendrá información general visible para la aplicación, como horarios, porcentaje de anticipo y reglas del servicio.

## 20. Seguridad y validaciones

La aplicación deberá utilizar Firebase Authentication y reglas de Firestore para limitar el acceso a información según el usuario autenticado. Cada cliente solo deberá poder consultar y modificar los pedidos asociados a su propia cuenta.

La app no deberá permitir modificación de precios, stock o configuración global del negocio desde el lado del usuario. Estas restricciones deberán reforzarse tanto a nivel de interfaz como a nivel de reglas de seguridad en Firebase.

## 21. Notificaciones y comunicación

La aplicación mostrará notificaciones internas relacionadas con el estado del pedido, confirmaciones y recordatorios relevantes. Según el dispositivo, estas notificaciones podrán verse dentro de la aplicación o mediante el navegador cuando exista permiso del usuario.

Estas notificaciones formarán parte del entorno académico simulado del proyecto y no sustituirán canales comerciales reales o integraciones productivas externas.

## 22. Posibles mejoras futuras

Como mejoras posteriores, el proyecto podría incluir filtros avanzados de productos, paquetes de renta, favoritos, historial ampliado de pedidos, notificaciones push más completas y recomendaciones de productos relacionados. Estas mejoras servirían para enriquecer la experiencia del usuario en versiones futuras.