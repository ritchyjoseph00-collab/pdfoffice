package com.Ritchy.pdfoffice.model;

public class StoredFile {

    private final String id;
    private final String originalName;
    private final String extension;
    private final String contentType;

    public StoredFile(String id, String originalName, String extension, String contentType) {
        this.id = id;
        this.originalName = originalName;
        this.extension = extension;
        this.contentType = contentType;
    }

    public String getId() { return id; }
    public String getOriginalName() { return originalName; }
    public String getExtension() { return extension; }
    public String getContentType() { return contentType; }
}
