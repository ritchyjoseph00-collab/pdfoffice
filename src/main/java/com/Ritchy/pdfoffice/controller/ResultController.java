package com.Ritchy.pdfoffice.controller;

import com.Ritchy.pdfoffice.Service.StorageService;
import com.Ritchy.pdfoffice.model.StoredFile;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
public class ResultController {

    private final StorageService storageService;

    public ResultController(StorageService storageService) {
        this.storageService = storageService;
    }

    @GetMapping("/result/{fileId}")
    public String result(@PathVariable String fileId, Model model) {

        StoredFile f = storageService.getMetadata(fileId);

        String cleanName = cleanDisplayName(f.getOriginalName());

        String downloadUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/download/")
                .path(fileId)
                .toUriString();

        String previewUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/preview/")
                .path(fileId)
                .toUriString();

        String shareText = "Voici ton fichier converti: " + downloadUrl;

        model.addAttribute("fileName", cleanName);
        model.addAttribute("downloadUrl", downloadUrl);
        model.addAttribute("previewUrl", previewUrl);
        model.addAttribute("waLink", "https://wa.me/?text=" + urlEnc(shareText));
        model.addAttribute("tgLink", "https://t.me/share/url?url=" + urlEnc(downloadUrl));
        model.addAttribute("isPdfPreview", "pdf".equalsIgnoreCase(f.getExtension()));

        return "result";
    }

    @GetMapping("/download/{fileId}")
    public ResponseEntity<Resource> download(@PathVariable String fileId) {

        StoredFile f = storageService.getMetadata(fileId);
        Resource resource = storageService.loadAsResource(fileId);

        String cleanName = cleanDisplayName(f.getOriginalName());

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(f.getContentType()))
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + safeFilename(cleanName) + "\""
                )
                .body(resource);
    }

    @GetMapping("/preview/{fileId}")
    public ResponseEntity<Resource> preview(@PathVariable String fileId) {

        StoredFile f = storageService.getMetadata(fileId);
        Resource resource = storageService.loadAsResource(fileId);

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(f.getContentType()))
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + safeFilename(f.getOriginalName()) + "\""
                )
                .body(resource);
    }

    // ==============================
    // 🔧 MÉTHODES UTILES (SIMPLES)
    // ==============================

    // Enlève le _UUID avant l’extension
    private String cleanDisplayName(String name) {
        if (name == null) return "converted";
        return name.replaceFirst("_[0-9a-fA-F\\-]{36}(?=\\.)", "");
    }

    private static String urlEnc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    private static String safeFilename(String name) {
        return name == null ? "file" : name.replaceAll("[\\r\\n\"]", "_");
    }
}
