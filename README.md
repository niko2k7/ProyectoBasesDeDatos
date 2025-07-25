# Proyecto de Bases de Datos
<br>
<img src="https://www.pngkey.com/png/detail/268-2688228_universidad-nacional-colombia-logo.png" width="230" alt="Logo Universidad Nacional de Colombia">
<br>
UNIVERSIDAD NACIONAL DE COLOMBIA 
<br>
Bases de Datos
<br>
2016353
<br>
Grupo 1
<br><br>
Autores: 

- Nicolás Aguirre Velásquez (niaguirrev@unal.edu.co) 
- Ever Nicolás Muñoz Cortés (evmunoz@unal.edu.co)
- Omar Alejandro Blanco Pineda (oblancop@unal.edu.co) 

Docente: Elizabeth León Guzmán 

<br><br>
---

## Contenido
- [Requisitos](#requisitos)
- [Ejecución Local en VSCode](#ejecución-local-en-VSCode)
- [Enlaces Proyecto](#enlaces-proyecto)
<br><br>

---

## Requisitos

  MYSQL:
  1. Tener instalado MYSQL... etc...
  2. Haber corrido todos los scripts necesarios.
  
  JDK 24.0.1:
  https://www.oracle.com/co/java/technologies/downloads/#jdk24-windows
  1. Abrir cmd y poner java --version y javac --version, debe decir la versión correcta para ambos casos.
  
  MAVEN 3.9.10:
  https://maven.apache.org/download.cgi
  1. Seleccionar la opción binary zip archive
  2. Ir a la ruta C:\Program Files\Apache\Maven (crear las carpetas Apache y Maven si no están creadas)
  3. Descomprimir el archivo aquí, debe quedar algo así: C:\Program Files\Apache\Maven\apache-maven-3.9.10
  4. Presionar WIN + S y escribir "Editar las variables de entorno del sistema"
  5. Seleccionar variables de entorno en la parte baja
  6. Seleccionar Path y darle a editar
  7. Darle nuevo, y agregar la ruta: C:\Program Files\Apache\Maven\apache-maven-3.9.10\bin
  8. Devolverse dándole aceptar a todo.
  9. Abrir cmd y poner mvm -v, si todo salió bien debe decir la versión.
  
  VSCODE:
  - Extensión "JAVA"
  - Extensión "JavaFx Support"
  - Extensión "Extension Pack For Java"
<br><br>

---


## Ejecución Local en VSCode

1. Abrir el proyecto en vscode.
2. Asegurarse de que está el archivo pom.xml
3. Presionar Ctrl + Ñ
4. Escribir "mvn clean compile"
5. Escribir "mvn clean javafx:run"
<br><br>

---

## Enlaces Proyecto

- Diagrama E/R: https://drive.google.com/file/d/19II5D9yWAxw-oznzSZEqxWfiEuNnxBIC/view?usp=drivesdk
- Diseños en Figma: [https://www.figma.com/design/QDuVCQTQv1b96pptmbenAm/Interfaz-proyecto-bases?node-id=0-1&t=zmUyUyV1Ts8RLNPs-1](https://www.figma.com/design/AwCyEXSNSG0Zb3FHgCwlaY/Sin-t%C3%ADtulo?node-id=1-2&t=EEid6bXSIDZ4JV1z-1)
- Video explicativo: https://drive.google.com/file/d/1KMv_0GHxHoyV7ITeG7rZxQtDtQ3yfWVk/view?usp=sharing
