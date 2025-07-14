REQUISITOS:

  JDK 24.0.1:
  https://www.oracle.com/co/java/technologies/downloads/#jdk24-windows
  Abrir cmd y poner java --version y javac --version, debe decir la versión correcta para ambos casos.
  
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

CORRER Y COMPILAR EL PROYECTO EN VSCODE:
1. Abrir el proyecto en vscode.
2. Asegurarse de que está el archivo pom.xml
3. Presionar Ctrl + Ñ
4. Escribir "mvn clean compile"
5. Escribir "mvn clean javafx:run"
