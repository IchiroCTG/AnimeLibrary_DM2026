 # POC.md — Architecture Decision Record
## Rama: feature/poc_firebase_baas

### Contexto — Riesgo Evaluado
Library Anime necesita persistir listas personales de usuario 
(Guardados, Completados, Viendo) y un catálogo de animes accesible 
offline. El riesgo principal es la asincronía de Firestore bajo 
condiciones de conectividad inestable en dispositivos móviles. 
Sin validar este riesgo antes de la implementación completa, 
se incurre en deuda técnica grave.

### Decisión — Librería y Estrategia Adoptada
Se adoptó Firebase + FlutterFire como stack BaaS principal:
- cloud_firestore ^5.4.4 — persistencia y sincronización en tiempo real
- firebase_auth ^5.3.1 — autenticación de usuarios
- firebase_storage ^12.3.2 — almacenamiento de imágenes

La PoC validó la lectura de la colección animes desde Firestore 
con manejo de errores y estados de carga. Conexión confirmada 
sin errores en emulador Android.

### Consecuencias — Resultados y Plan de Integración
✓ Viabilidad técnica confirmada.

Plan de integración a develop:
1. Crear interfaz AnimeRepository en lib/domain/
2. Implementar FirestoreAnimeRepository en lib/data/
3. Inyectar dependencia via constructor en HomeScreen
4. Migrar anime_data.dart estático a colección Firestore
5. Configurar reglas de seguridad Firestore antes de producción

Limitación: requiere google-services.json configurado 
correctamente antes del merge a develop.