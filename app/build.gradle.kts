import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.8.10"
}

group = "wingsmc"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.antlr:antlr4:4.12.0")
    implementation("com.google.guava:guava:31.1-jre")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(18))
    }
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "1.8"
}
