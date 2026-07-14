# BanBan App — Documentación del Proyecto

Aplicación Flutter multiplataforma para la renta de artículos para fiestas en Uruapan, Michoacán. Desarrollo académico con Firebase como backend.

---

## Tabla de contenido

1. [Resumen](#1-resumen)
2. [Stack tecnológico](#2-stack-tecnológico)
3. [Prerrequisitos](#3-prerrequisitos)
4. [Instalación y configuración](#4-instalación-y-configuración)
5. [Estructura del proyecto](#5-estructura-del-proyecto)
6. [Arquitectura y patrón de diseño](#6-arquitectura-y-patrón-de-diseño)
7. [Firebase](#7-firebase)
8. [Autenticación](#8-autenticación)
9. [Base de datos Firestore](#9-base-de-datos-firestore)
10. [Catálogo de productos](#10-catálogo-de-productos)
11. [Carrito de compras](#11-carrito-de-compras)
12. [Pantallas y navegación](#12-pantallas-y-navegación)
13. [Modelos de datos](#13-modelos-de-datos)
14. [Servicios](#14-servicios)
15. [Providers (estado)](#15-providers-estado)
16. [Reglas de negocio](#16-reglas-de-negocio)
17. [Progreso y roadmaps](#17-progreso-y-roadmap)
18. [Archivos excluidos del repositorio](#18-archivos-excluidos-del-repositorio)
19. [Contribuir](#19-contribuir)

---

## 1. Resumen

**BanBan** es una app donde los clientes pueden:

- Explorar un catálogo de productos disponibles para renta (brincolines, sillas, mesas, losa, manteles).
- Configurar fecha, horario y cantidad de productos.
- Agregar productos a un carrito persistente en la nube.
- Iniciar sesión con Google para gestionar pedidos.

La app **no** procesa pagos reales, no emite CFDI, y la operación administrativa será manejada por una segunda aplicación separada.

---

## 2. Stack tecnológico

| Capa | Tecnología |
|---|---|
| Framework | Flutter 3.41.2 / Dart 3.11.0 |
| Autenticación | Firebase Authentication + Google Sign-In |
| Base de datos | Cloud Firestore |
| State management | Provider (ChangeNotifier) |
| Plataformas | Android (principal), iOS, Web, Linux, macOS, Windows |

---

## 3. Prerrequisitos

- Flutter >= 3.11.0
- Cuenta de Google
- Proyecto creado en [Firebase Console](https://console.firebase.google.com)
- Habilitar en Firebase: **Authentication > Google Sign-In** y **Firestore Database**

---

## 4. Instalación y configuración

```bash
# Clonar el repositorio
git clone https://github.com/ZetaGG/bambam-app.git
cd bambam-app

# Instalar dependencias
flutter pub get

# Configurar Firebase (genera firebase_options.dart y google-services.json)
flutterfire configure --platforms=android

# Ejecutar
flutter run
```

**Después de clonar**, es necesario ejecutar `flutterfire configure` porque los archivos de configuración de Firebase están excluidos del repositorio por seguridad.

### SHA-1 para Google Sign-In

Para que Google Sign-In funcione, agregar la huella SHA-1 en Firebase Console:

```
8E:0D:DA:B0:1B:69:D1:0D:1A:D0:58:29:0F:B5:7A:94:FD:6F:8A:BB
```

Ubicación: Firebase Console > Proyecto > Configuración > Tu app Android > Huellas digitales.

---

## 5. Estructura del proyecto

```
bambam_app/
├── lib/
│   ├── main.dart                          # Punto de entrada, theme, providers, shell de navegación
│   │
│   ├── firebase_options.dart              # Configuración Firebase (generado por FlutterFire CLI)
│   │
│   ├── models/
│   │   ├── product.dart                   # Modelo Product + datos mock
│   │   └── cart_item.dart                 # Modelo CartItem (Firestore)
│   │
│   ├── services/
│   │   ├── auth_service.dart              # Wrapper de Firebase Auth + Google Sign-In
│   │   └── firestore_service.dart         # CRUD Firestore: usuarios, productos, carrito
│   │
│   ├── providers/
│   │   ├── auth_provider.dart             # Estado de autenticación (AppAuthProvider)
│   │   └── cart_provider.dart             # Estado del carrito (CartProvider)
│   │
│   ├── pages/
│   │   ├── home_page.dart                 # Pantalla de inicio con catálogo desde Firestore
│   │   ├── product_detail_page.dart       # Detalle de producto con config de renta
│   │   ├── cart_page.dart                 # Carrito con ítems, cantidad, total
│   │   ├── agenda_page.dart               # Pedidos agendados (placeholder)
│   │   └── profile_page.dart              # Perfil, login/logout, seed de productos
│   │
│   └── widgets/
│       └── product_card.dart              # Tarjeta de producto para el catálogo
│
├── android/
├── ios/
├── web/
├── linux/
├── macos/
├── windows/
├── pubspec.yaml
├── Proyecto.md                            # Documento de requerimientos completo
└── README.md                              # Este archivo
```

---

## 6. Arquitectura y patrón de diseño

### Patrón: Provider + Service

La app utiliza **Provider** con **ChangeNotifier** para manejo de estado, y **Services** para lógica de acceso a datos (Firestore, Auth).

```
┌─────────────────────────────────────┐
│           PAGES (UI)                │
│  Consumer / Consumer2 lee providers │
├─────────────────────────────────────┤
│          PROVIDERS (Estado)         │
│  AppAuthProvider, CartProvider      │
├─────────────────────────────────────┤
│          SERVICES (Datos)           │
│  AuthService, FirestoreService      │
├─────────────────────────────────────┤
│          FIREBASE SDK               │
│  Firebase Auth, Firestore           │
└─────────────────────────────────────┘
```

### Flujo de datos

1. **Pages** leen estado desde Providers con `Consumer` / `context.read`.
2. **Providers** llaman a Services y notifican cambios con `notifyListeners()`.
3. **Services** se comunican directamente con Firebase SDK.
4. **Firestore** emite streams que Providers escuchan en tiempo real.

---

## 7. Firebase

### Proyecto Firebase

- **Nombre**: Banbam
- **ID del proyecto**: `banbam-3d35d`

### Servicios habilitados

| Servicio | Estado |
|---|---|
| Authentication (Google) | Activo |
| Cloud Firestore | Activo |
| Firebase Storage | Pendiente |
| Cloud Messaging | Pendiente |

### Configuración excluida

Los siguientes archivos **no están en el repositorio** y se generan con `flutterfire configure`:

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `firebase.json`

---

## 8. Autenticación

### Cómo funciona

1. El usuario presiona "Iniciar sesión con Google" en la pestaña **Perfil**.
2. Se abre el flujo nativo de Google Sign-In.
3. Firebase Auth crea/recupera la cuenta.
4. Se guarda/actualiza el perfil del usuario en Firestore (`users/{uid}`).
5. El `AppAuthProvider` notifica el cambio de estado a toda la app.

### Archivos involucrados

| Archivo | Responsabilidad |
|---|---|
| `lib/services/auth_service.dart` | `signInWithGoogle()`, `signOut()`, `authStateChanges` stream |
| `lib/providers/auth_provider.dart` | Expone `user`, `isAuthenticated`, `isLoading` a la UI |
| `lib/pages/profile_page.dart` | UI de login/logout |

### Estados

- **No autenticado**: Se muestra botón de login.
- **Autenticado**: Se muestra perfil con foto, nombre, email, opciones de menú y botón de cerrar sesión.

---

## 9. Base de datos Firestore

### Estructura de colecciones

```
users/{uid}
  ├── name: string
  ├── email: string
  ├── photoUrl: string
  ├── rol: "cliente"
  ├── telefono: string
  ├── direccion: string
  └── fechaCreacion: timestamp

users/{uid}/cart/{cartItemId}
  ├── productId: string
  ├── productName: string
  ├── category: string
  ├── pricePerUnit: number
  ├── quantity: number
  ├── fechaEntrega: timestamp
  ├── horaEntrega: string
  └── (subtotal se calcula en cliente)

products/{productId}
  ├── nombre: string
  ├── descripcion: string
  ├── categoria: string
  ├── precio: number
  ├── stock: number
  ├── disponible: boolean
  └── imagenUrl: string
```

### Reglas de acceso (conceptuales)

| Colección | Lectura | Escritura |
|---|---|---|
| `users/{uid}` | Solo el propio usuario | Solo el propio usuario |
| `users/{uid}/cart/*` | Solo el propio usuario | Solo el propio usuario |
| `products/*` | Público | Solo administradores |

---

## 10. Catálogo de productos

### Productos iniciales (seed)

Se cargan mediante el botón "Cargar productos de ejemplo" en la pantalla de perfil (requiere autenticación).

| Producto | Categoría | Precio | Stock |
|---|---|---|---|
| Brincolín Grande | Brincolines | $650 | 3 |
| Brincolín Chico | Brincolines | $450 | 5 |
| Brincolín Redondo | Brincolines | $550 | 2 |
| Brincolín Acuático | Brincolines | $750 | 2 |
| Silla Plegable | Sillas | $15 | 300 |
| Mesa Plegable | Mesas | $50 | 30 |
| Plato Hondo | Losa | $8 | 200 |
| Vaso | Losa | $5 | 200 |
| Mantel Rectangular | Manteles | $30 | 100 |

### Carga de datos

`home_page.dart` carga productos desde Firestore usando `FirestoreService.getProducts()` con un `FutureBuilder`. Si Firestore está vacío, muestra estado vacío.

---

## 11. Carrito de compras

### Flujo

1. Usuario abre un producto → selecciona **fecha**, **horario** y **cantidad**.
2. Presiona "Agregar al carrito".
3. **Validaciones**:
   - Si no hay sesión → SnackBar de error.
   - Si falta fecha u hora → SnackBar de error.
   - Si ya hay productos con fecha/hora distinta → SnackBar con advertencia.
4. El ítem se guarda en `users/{uid}/cart/` en Firestore.
5. La pestaña **Carrito** muestra los ítems en tiempo real (stream).

### Funcionalidades del carrito

- **Agregar producto** (con validación de fecha/hora).
- **Modificar cantidad** (+ / -) con persistencia en Firestore.
- **Eliminar individual** un ítem.
- **Vaciar carrito** completo (con confirmación).
- **Total estimado** calculado en tiempo real.
- **Fecha/hora de entrega** visible en el header del carrito.
- **Persistencia**: sobrevive al cerrar la app (Firestore).

### Restricciones

- Todos los productos del carrito comparten la misma fecha y hora de entrega.
- Se requiere autenticación para usar el carrito.
- La cantidad no puede exceder el stock del producto.

### Archivos involucrados

| Archivo | Responsabilidad |
|---|---|
| `lib/models/cart_item.dart` | Modelo de datos con serialización Firestore |
| `lib/services/firestore_service.dart` | CRUD del carrito en Firestore |
| `lib/providers/cart_provider.dart` | Estado reactivo del carrito |
| `lib/pages/product_detail_page.dart` | UI de configuración y agregar al carrito |
| `lib/pages/cart_page.dart` | UI del carrito con lista, total y checkout |

---

## 12. Pantallas y navegación

### Shell de navegación

La app usa un `NavigationBar` con 4 pestanas gestionadas por `IndexedStack`:

| Índice | Pestaña | Widget | Descripción |
|---|---|---|---|
| 0 | Inicio | `HomePage` | Catálogo de productos desde Firestore |
| 1 | Carrito | `CartPage` | Carrito del usuario autenticado |
| 2 | Pedidos | `AgendaPage` | Pedidos agendados (placeholder) |
| 3 | Perfil | `ProfilePage` | Login/logout, info de usuario, seed |

### Detalle de producto

Se navega desde `HomePage` → `ProductDetailPage` con `Navigator.push`. Muestra información del producto, configuración de fecha/hora, selector de cantidad y botón "Agregar al carrito".

---

## 13. Modelos de datos

### Product

```dart
class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double pricePerUnit;
  final int stock;
  final String imageUrl;
  final bool available;
}
```

Campos Firestore → Dart:
- `nombre` → `name`
- `descripcion` → `description`
- `categoria` → `category`
- `precio` → `pricePerUnit`
- `disponible` → `available`

### CartItem

```dart
class CartItem {
  final String id;          // ID del documento Firestore
  final String productId;
  final String productName;
  final String category;
  final double pricePerUnit;
  int quantity;             // Mutable
  final DateTime fechaEntrega;
  final String horaEntrega; // Formato "HH:mm"

  double get subtotal => pricePerUnit * quantity;
}
```

---

## 14. Servicios

### AuthService

| Método | Descripción |
|---|---|
| `signInWithGoogle()` | Abre flujo Google Sign-In, retorna `User?` |
| `signOut()` | Cierra sesión en Auth y Google |
| `currentUser` | Getter del usuario actual |
| `authStateChanges` | Stream de cambios de autenticación |

### FirestoreService

| Método | Descripción |
|---|---|
| `saveUser(...)` | Crea/actualiza perfil en `users/{uid}` |
| `getProducts()` | Retorna lista de productos disponibles |
| `seedProducts()` | Carga productos de ejemplo en Firestore |
| `cartStream(uid)` | Stream del carrito del usuario |
| `addToCart(...)` | Agrega ítem o incrementa cantidad si ya existe |
| `updateCartItemQuantity(...)` | Actualiza cantidad (elimina si <= 0) |
| `removeFromCart(...)` | Elimina un ítem del carrito |
| `clearCart(uid)` | Vacía todo el carrito del usuario |

---

## 15. Providers (estado)

### AppAuthProvider

```dart
class AppAuthProvider extends ChangeNotifier {
  User? get user;
  bool get isLoading;
  bool get isAuthenticated;

  Future<bool> signInWithGoogle();
  Future<void> signOut();
}
```

Se suscribe a `authStateChanges` de Firebase. Actualiza la UI automáticamente al cambiar el estado de sesión.

### CartProvider

```dart
class CartProvider extends ChangeNotifier {
  List<CartItem> get items;
  bool get isEmpty;
  int get itemCount;
  double get total;
  DateTime? get fechaEntrega;
  String get horaEntrega;

  void subscribeToCart(String uid);    // Activa stream en tiempo real
  void unsubscribeFromCart();          // Cancela stream
  Future<void> addToCart(...);
  Future<void> updateQuantity(...);
  Future<void> removeItem(...);
  Future<void> clearCart(uid);
}
```

Se suscribe al stream de Firestore al autenticarse. Se cancela al cerrar sesión. La UI se actualiza automáticamente con `notifyListeners`.

### Suscripción del carrito

En `MainShell.initState()` se escucha `AppAuthProvider` y se llama a `_syncCartWithAuth()`, que:
- Si hay usuario → `cartProvider.subscribeToCart(uid)`
- Si no hay usuario → `cartProvider.unsubscribeFromCart()`

---

## 16. Reglas de negocio

| Regla | Implementación |
|---|---|
| Fecha/hora requerida para agregar al carrito | `product_detail_page.dart:107-115` |
| Solo usuarios autenticados pueden usar carrito | `product_detail_page.dart:99-106` |
| Todos los ítems comparten misma fecha/hora | `product_detail_page.dart:117-132` |
| Cantidad no puede exceder stock | `product_detail_page.dart` (botón + se deshabilita) |
| Si el producto ya está en carrito, se suma cantidad | `firestore_service.dart:addToCart()` |
| Si cantidad <= 0, se elimina el ítem | `firestore_service.dart:updateCartItemQuantity()` |
| Servicio limitado a Uruapan, Michoacán | Documentado en Proyecto.md |

---

## 17. Progreso y roadmap

### Completado

- [x] Proyecto Flutter base con Material 3
- [x] Theme personalizado con colores BanBan
- [x] Navegación con NavigationBar (4 pestañas)
- [x] Integración Firebase Core
- [x] Firebase Authentication con Google Sign-In
- [x] Cloud Firestore configurado
- [x] Modelo de Producto con Firestore
- [x] Catálogo de productos desde Firestore
- [x] Seed de productos iniciales
- [x] Perfil de usuario autenticado
- [x] Modelo CartItem con Firestore
- [x] Carrito persistente en Firestore
- [x] Validación de fecha/hora antes de agregar
- [x] UI de carrito con cantidad, total, eliminar
- [x] Sincronización del carrito al autenticarse
- [x] SHA-1 configurado para Google Sign-In

### Pendiente

- [ ] Pantalla de pedidos agendados (functionalidad real)
- [ ] Flujo de checkout y pedido
- [ ] Simulación de pago (anticipo 20%)
- [ ] Estados del pedido (Reservado → Entregado → Finalizado)
- [ ] Notificaciones internas
- [ ] Firebase Storage para imágenes de productos
- [ ] Filtro de productos por categoría
- [ ] Validación de disponibilidad por fecha/zona/stock
- [ ] Pantalla de dirección y datos de contacto
- [ ] Registro de teléfono y dirección del usuario
- [ ] App de administradores (separada)

### Futuro

- [ ] Filtros avanzados de productos
- [ ] Paquetes de renta
- [ ] Favoritos
- [ ] Historial ampliado de pedidos
- [ ] Notificaciones push (FCM)
- [ ] Recomendaciones de productos

---

## 18. Archivos excluidos del repositorio

Estos archivos contienen configuración sensible y **no están en Git**. Se generan con `flutterfire configure`:

| Archivo | Contenido |
|---|---|
| `android/app/google-services.json` | Config Firebase Android (project ID, API keys) |
| `lib/firebase_options.dart` | API keys de Firebase por plataforma |
| `firebase.json` | Config FlutterFire CLI |
| `devtools_options.yaml` | Config DevTools |

---

## 19. Contribuir

1. Crear una rama para la feature: `git checkout -b feature/nombre`
2. Hacer commits descriptivos.
3. Abrir Pull Request describiendo el cambio.
4. Asegurar que `flutter analyze` no retorne errores.

---

*Última actualización: Julio 2026*
