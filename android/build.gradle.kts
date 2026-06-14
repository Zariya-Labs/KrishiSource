allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Force all Java compilation tasks across all subprojects/plugins to use Java 17
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    // Modern compilerOptions DSL to force JVM Target 17 on all Kotlin tasks across all plugins
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

// Standard Flutter build directory configuration
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get().asFile
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = rootProject.layout.buildDirectory.dir(project.name).get().asFile
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}