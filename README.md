## Ejercicios Jenkins

> [!NOTE]
> En el archivo `./jenkins-resources/gradle.Dockerfile` se ha cambiado la imagen de `jenkins/jenkins:lts-jdk11` a una imagen con Java 17 `jenkins/jenkins:lts-jdk17` por advertencias de Jenkis de no dar soporte a Java 11.

> También se ha agregado nuevas instalaciones para poder usar dockerindocker

> También se ha agregado un `docker-compose.yaml` basado en el usado durante el curso para facilitar el levantamiento

```diff
+ ### PROPUESTA EJERCICIO 1: CI/CD de una Java + Gradle
```

1. Enlazar Jenkis con el repositorio de Github. se debe primero crear un 'Personal access tokens' en Github.  Con los permisos `Read access to metadata` y `Read and Write to code,commit statues, and pull request` será suficiente
2. Desde la UI de Jenkins se accede a `Manage Jenkis > Credentiasl` se pulsa en `global` y se añade una nueva credencial `+ Add Credentials`
3. Se rellena los campos teniendo en cuenta que el username debe ser el mismo que el repostiorio y la contraseña el "Personal access tokens".
4. Para crear una nueva Pipeline se accede a `+ New Item` con la opción de `Pipeline`. Para crearlo se debe dar un nombre a la pipeline.
5. Una vez en las opciones de configuracón en la parte final `Pipeline` se debe especificar que se usará un script traido desde un administrador de código fuente `Definition > Pipeline script from SCM `
6. Se debe colocar la URL del repo, EJ: `https://github.com/gutiz24/Ejercicios-Lemon.git`
7. En credencials seleccionamos las anteriores creadas
8. En este caso se cambia la rama por defecto a `main`
9. Se especifica el path donde está el archivo `Jenkinsfile`. EJ: `03-CD/Jenkins/jenkins-resources/JenkinsFile`


### 1. CI/CD de una Java + Gradle - OBLIGATORIO

En el directorio raíz de este [código fuente](./jenkins-resources), crea un `Jenkinsfile` que contenga una pipeline declarativa con los siguientes stages:

* **Checkout**. Descarga de código desde un repositorio remoto, preferentemente utiliza GitHub
* **Compile**. Compilar el código fuente utilizando `gradlew compileJava`
* **Unit Tests**. Ejecutar los test unitarios utilizando `gradlew test`

Para ejecutar Jenkins en local y tener las dependencias necesarias disponibles podemos contruir una imagen a partir de [este Dockerfile](./jenkins-resources/gradle.Dockerfile)

### 2. Modificar la pipeline para que utilice la imagen Docker de Gradle como build runner - OBLIGATORIO

* Utilizar Docker in Docker a la hora de levantar Jenkins para realizar este ejercicio
* Como plugins deben estar instalados `Docker` y `Docker Pipeline`
* Usar la imagen de Docker `gradle:6.6.1-jre14-openj9`