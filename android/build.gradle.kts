allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Set build directory for subprojects
    layout.buildDirectory.set(newBuildDir.dir(name))

    // Ensure `:app` is evaluated before others
    evaluationDependsOn(":app")
}

// Define `clean` task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
