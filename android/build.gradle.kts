import com.android.build.gradle.BaseExtension
import com.android.build.gradle.AppPlugin
import com.android.build.gradle.LibraryPlugin
import org.gradle.kotlin.dsl.*
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    //project.evaluationDependsOn(":app")
    afterEvaluate {
        // Use withType to check if any Android plugin is applied
        project.plugins.withType<com.android.build.gradle.BasePlugin> {
            // Get the extension as a generic BaseExtension (works for both app and library)
            project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                // Inside this configure block, 'this' refers to the BaseExtension object.
                // We use the properties directly on the extension instance.
                compileSdkVersion(36)
                defaultConfig.targetSdk = 36
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
plugins {
  // ...

  // Add the dependency for the Google services Gradle plugin
  id("com.google.gms.google-services") version "4.4.4" apply false

}
