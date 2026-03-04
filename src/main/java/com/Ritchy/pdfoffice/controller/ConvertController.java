package com.Ritchy.pdfoffice.controller;

import com.Ritchy.pdfoffice.Service.ConvertService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

@RestController
public class ConvertController {

    private final ConvertService service;

    public ConvertController(ConvertService service) {
        this.service = service;
    }

    @PostMapping(value = "/convert", consumes = "multipart/form-data")
    public ResponseEntity<Void> convert(
            @RequestParam("file") MultipartFile file,
            @RequestParam("to") String toFormat
    ) throws Exception {

        String fileId = service.convertAndStore(file, toFormat);

        // URL absolue (plus fiable)
        String resultUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/result/")
                .path(fileId)
                .toUriString();

        return ResponseEntity.status(302)
                .location(URI.create(resultUrl))
                .build();
    }
}
