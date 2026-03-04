package com.Ritchy.pdfoffice.Config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Files;
import java.nio.file.Path;

@Configuration
public class StorageConfig {

    // On lit la valeur app.storage-dir depuis application.properties
    @Value("${app.storage-dir}")
    private String storageDir;

    // Au démarrage de l'application, on crée le dossier si absent
    @PostConstruct
    public void init() throws Exception {
        Files.createDirectories(Path.of(storageDir));
        System.out.println("✅ Storage directory ready: " + storageDir);
    }
}
