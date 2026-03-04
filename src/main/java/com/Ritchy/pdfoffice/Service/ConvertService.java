package com.Ritchy.pdfoffice.Service;

import com.cloudconvert.client.CloudConvertClient;
import com.cloudconvert.dto.request.ConvertFilesTaskRequest;
import com.cloudconvert.dto.request.UploadImportRequest;
import com.cloudconvert.dto.request.UrlExportRequest;
import com.cloudconvert.dto.response.JobResponse;
import com.cloudconvert.dto.response.TaskResponse;
import com.cloudconvert.exception.CloudConvertClientException;
import com.google.common.collect.ImmutableMap;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;

@Service
public class ConvertService {

    private final CloudConvertClient client;
    private final StorageService storageService;

    public ConvertService(CloudConvertClient client, StorageService storageService) {
        this.client = client;
        this.storageService = storageService;
    }

    /**
     * Convertit via CloudConvert, télécharge le fichier converti,
     * l'enregistre dans ./converted et retourne fileId (nom + UUID).
     */
    public String convertAndStore(MultipartFile file, String toFormat) throws Exception {

        String outFormat = normalizeFormat(toFormat);
        if (outFormat == null || outFormat.isBlank()) {
            throw new IllegalArgumentException("Paramètre 'to' invalide (format de sortie).");
        }

        try {
            // ==============================
            // 1) UPLOAD CLOUDCONVERT (SAFE)
            // ==============================
            String uploadName = file.getOriginalFilename();
            if (uploadName == null || uploadName.isBlank()) {
                uploadName = "input." + outFormat; // ✅ fallback OBLIGATOIRE
            }

            TaskResponse uploadTask;
            try (InputStream in = file.getInputStream()) {
                uploadTask = client.importUsing()
                        .upload(
                                new UploadImportRequest(),
                                in,
                                uploadName
                        )
                        .getBody();
            }
            if (uploadTask == null) throw new IllegalStateException("uploadTask body is null");

            TaskResponse doneUpload = client.tasks().wait(uploadTask.getId()).getBody();
            if (doneUpload == null) throw new IllegalStateException("doneUpload body is null");

            // ==============================
            // 2) CONVERT + EXPORT
            // ==============================
            JobResponse job = client.jobs().create(ImmutableMap.of(
                    "convert-my-file", new ConvertFilesTaskRequest()
                            .setInput(doneUpload.getId())
                            .setOutputFormat(outFormat),
                    "export-my-file", new UrlExportRequest().setInput("convert-my-file")
            )).getBody();

            if (job == null) throw new IllegalStateException("job body is null");

            JobResponse doneJob = client.jobs().wait(job.getId()).getBody();
            if (doneJob == null) throw new IllegalStateException("doneJob body is null");

            TaskResponse exportTask = doneJob.getTasks().stream()
                    .filter(t -> "export-my-file".equals(t.getName()))
                    .findFirst()
                    .orElseThrow(() -> new IllegalStateException("export task not found"));

            TaskResponse doneExport = client.tasks().wait(exportTask.getId()).getBody();
            if (doneExport == null || doneExport.getResult() == null
                    || doneExport.getResult().getFiles() == null
                    || doneExport.getResult().getFiles().isEmpty()) {
                throw new IllegalStateException("export/url returned no files");
            }

            Map<String, String> file0 = doneExport.getResult().getFiles().get(0);
            String signedUrl = file0.get("url");

            if (signedUrl == null || signedUrl.isBlank()) {
                throw new IllegalStateException("Missing signed url from export/url");
            }

            // ==============================
            // 3) NOM LOCAL PROPRE (UUID)
            // ==============================
            String originalName = file.getOriginalFilename();
            String baseName = (originalName != null && !originalName.isBlank())
                    ? originalName.replaceAll("\\.[^.]+$", "")
                    : "converted";

            baseName = baseName.replaceAll("[^a-zA-Z0-9_-]", "_");

            String fileId = baseName + "_" + UUID.randomUUID() + "." + outFormat;
            Path outPath = storageService.getConvertedDir().resolve(fileId).normalize();

            // ==============================
            // 4) DOWNLOAD FICHIER FINAL
            // ==============================
            try (InputStream downloadStream = new URL(signedUrl).openStream()) {
                Files.copy(downloadStream, outPath, StandardCopyOption.REPLACE_EXISTING);
            }

            if (!Files.exists(outPath) || Files.size(outPath) == 0) {
                throw new IllegalStateException("Saved file is empty: " + outPath);
            }

            return fileId;

        } catch (CloudConvertClientException e) {
            System.out.println("CloudConvertClientException: " + e.getMessage());
            throw e;
        }
    }

    private String normalizeFormat(String to) {
        if (to == null) return "";
        String f = to.trim().toLowerCase();
        return switch (f) {
            case "word" -> "docx";
            case "excel" -> "xlsx";
            case "powerpoint", "ppt" -> "pptx";
            case "jpg" -> "jpeg";
            default -> f;
        };
    }
}
