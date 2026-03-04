package com.Ritchy.pdfoffice.Service;

import com.Ritchy.pdfoffice.model.StoredFile;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class StorageService {

    // dossier de sortie: ./converted
    private final Path convertedDir = Paths.get("converted");

    public StorageService() {
        try {
            Files.createDirectories(convertedDir);
        } catch (Exception e) {
            throw new RuntimeException("Impossible de créer le dossier converted/", e);
        }
    }

    public Path getConvertedDir() {
        return convertedDir;
    }

    public StoredFile getMetadata(String fileId) {
        Path file = convertedDir.resolve(fileId).normalize();

        if (!Files.exists(file)) {
            throw new RuntimeException("Fichier introuvable: " + fileId);
        }

        String originalName = file.getFileName().toString();

        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot > -1 && dot < originalName.length() - 1) {
            ext = originalName.substring(dot + 1);
        }

        String contentType;
        try {
            contentType = Files.probeContentType(file);
        } catch (Exception e) {
            contentType = "application/octet-stream";
        }

        return new StoredFile(fileId, originalName, ext, contentType);
    }

    public Resource loadAsResource(String fileId) {
        try {
            Path file = convertedDir.resolve(fileId).normalize();

            if (!Files.exists(file)) {
                throw new RuntimeException("Fichier introuvable: " + fileId);
            }

            Resource resource = new UrlResource(file.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                throw new RuntimeException("Fichier non lisible: " + fileId);
            }

            return resource;
        } catch (Exception e) {
            throw new RuntimeException("Erreur loadAsResource: " + fileId, e);
        }
    }
}
