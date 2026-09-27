# StudyFlash

StudyFlash es una app nativa de iOS que convierte tus apuntes en una experiencia de estudio completa: flashcards, exámenes de opción múltiple y un chat con IA, todo generado y procesado directamente en el dispositivo, sin depender de internet ni de servidores externos.

Construida 100% en Swift / SwiftUI, usando exclusivamente frameworks nativos de Apple.

## El problema que resuelve

A muchas personas les cuesta trabajo estudiar solo leyendo apuntes de forma pasiva. StudyFlash convierte cualquier texto (escrito o escaneado) en un ciclo de aprendizaje activo:
En mi caso  me cuesta mucho concentrarme al estudiar y creo que no solo soy yo el que tiene ese problema, por eso disene esta app para que sea un poco mas interactiva la manera de aprender

Escribir o escanear apuntes → Generar flashcards → Estudiar → Examinarte → Repasar lo que fallaste

Todo ocurre en el dispositivo, usando la IA integrada de Apple, así que los apuntes nunca salen del iPhone.

## Funcionalidades

- Escaneo de documentos con la cámara (VisionKit + Vision, OCR nativo)
- Flashcards generadas con IA a partir de los apuntes, en la cantidad que el usuario elija
- Tarjetas interactivas que se voltean al tocarlas, con animaciones
- Examen de opción múltiple con retroalimentación visual (verde/correcto, rojo/incorrecto) y avance automático
- Repaso de las preguntas falladas al terminar el examen
- Guardado automático de los sets de tarjetas con SwiftData
- Chat con memoria para preguntarle a la IA sobre el tema estudiado

## Tecnología usada

| Framework | Uso |
|---|---|
| SwiftUI | Interfaz de la app |
| Foundation Models | Generación de flashcards, examen y chat, con IA en el dispositivo |
| SwiftData | Persistencia local de los sets guardados |
| VisionKit | Escaneo de documentos con la cámara |
| Vision | Reconocimiento de texto (OCR) |

No se usó ninguna dependencia externa.

## Requisitos

- Xcode 26 o más reciente
- iOS 26 o más reciente
- Para la IA (flashcards, examen, chat): dispositivo o simulador compatible con Apple Intelligence (iPhone 15 Pro en adelante, o Mac con Apple Silicon)
- Para el escáner: se requiere un iPhone físico, VisionKit no funciona en el simulador

## Cómo correrlo

1. Clona este repositorio:
   ```
   git clone https://github.com/omarcinho17/study-flash.git
   ```
2. Abre `StudyFlash.xcodeproj` en Xcode.
3. Selecciona un simulador de iPhone compatible o conecta un iPhone físico.
4. Verifica que Apple Intelligence esté activado.
5. Presiona Run para compilar y correr.

## Flujo de la app

1. Escribe tus apuntes o escanéalos con la cámara.
2. Elige cuántas flashcards quieres (3 a 10) y la IA las genera.
3. Estudia volteando cada tarjeta: pregunta, respuesta y una explicación.
4. Resuelve el examen de opción múltiple.
5. Revisa tu puntaje y repasa lo que hayas fallado.
6. Consulta tus sets guardados en "Mis sets".
7. Pregúntale a la IA cualquier duda sobre tus apuntes en el chat.

## Privacidad

StudyFlash no envía ningún dato a servidores externos. Toda la generación de contenido con IA ocurre localmente en el dispositivo con Apple Foundation Models.

## Autor

Omar Martínez López — Hackathon de programación en Swift, Apple Coding Academy.
