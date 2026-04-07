allprojects {
    repositories {
        google()
        mavenCentral()
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

    // Исправление для работы со старыми библиотеками (Isar и др.) на новых AGP
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension

            // 1. Устанавливаем namespace, если он отсутствует
            if (android?.namespace == null) {
                android?.namespace = "com.generated.${project.name.replace("-", "_")}"
            }

            // 2. Исправляем конфликт с атрибутом package в AndroidManifest.xml
            android?.sourceSets?.all {
                if (manifest.srcFile.exists()) {
                    val manifestFile = manifest.srcFile
                    val content = manifestFile.readText()
                    if (content.contains("package=")) {
                        // Удаляем атрибут package из манифеста перед сборкой
                        val updatedContent = content.replace(Regex("""package="[^"]*""""), "")

                        // Создаем временную копию манифеста без package
                        val tempDir = File(project.buildDir, "intermediates/fixed_manifests/${this.name}")
                        tempDir.mkdirs()
                        val tempManifest = File(tempDir, "AndroidManifest.xml")
                        tempManifest.writeText(updatedContent)

                        // Указываем Gradle использовать исправленный файл
                        manifest.srcFile(tempManifest)
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}