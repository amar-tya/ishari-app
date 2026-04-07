allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Kotlin 2.x dropped support for languageVersion < 1.8.
// Some Flutter plugins still declare 1.6 — override them all to 1.9.
subprojects {
    afterEvaluate {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                languageVersion.set(
                    org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9,
                )
            }
        }
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = JavaVersion.VERSION_11.toString()
            targetCompatibility = JavaVersion.VERSION_11.toString()
            options.compilerArgs.addAll(listOf("-Xlint:-options", "-Xlint:-deprecation"))
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
