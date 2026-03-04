package com.Ritchy.pdfoffice.config;

import com.cloudconvert.client.CloudConvertClient;
import java.io.IOException;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CloudConvertConfig {
    @Bean
    public CloudConvertClient cloudConvertClient() throws IOException {
        return new CloudConvertClient();
    }
}
