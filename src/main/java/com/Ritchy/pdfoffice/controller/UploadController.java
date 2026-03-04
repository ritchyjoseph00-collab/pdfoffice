package com.Ritchy.pdfoffice.Controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@Controller
public class UploadController {

    @Value("${app.storage-dir}")
    private String storageDir;

    // Page d'accueil
    @GetMapping("/")
    public String home() {
        return "index";
    }

    // Upload simple (si tu veux encore garder le test upload)
    @PostMapping("/upload")
    public String upload(@RequestParam("file") MultipartFile file, Model model) {
        try {
            if (file == null || file.isEmpty()) {
                model.addAttribute("error", "Fichier vide.");
                return "index";
            }

            Path dir = Path.of(storageDir);
            Files.createDirectories(dir);

            String original = StringUtils.cleanPath(file.getOriginalFilename());
            original = original.replaceAll("[\\\\/:*?\"<>|]", "_");

            String savedName = UUID.randomUUID() + "-" + original;
            Path dest = dir.resolve(savedName);

            file.transferTo(dest.toFile());

            model.addAttribute("savedName", savedName);

            // IMPORTANT: /download est géré par ConvertController (pas ici)
            model.addAttribute("downloadUrl", "/download/" + savedName);

            return "result";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur upload: " + e.getMessage());
            return "index";
        }
    }
}
