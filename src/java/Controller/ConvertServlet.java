package Controller;

import Model.ConversionService;
import Model.ConversionService.Mode;
import Util.FileStore;
import Util.ShareLinkUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Exécute la conversion et prépare :
 * - le fichier final (download)
 * - un PDF d’aperçu (preview)
 */
public class ConvertServlet extends HttpServlet {

    private FileStore store;
    private ConversionService service;

    @Override
    public void init() throws ServletException {
        try {
            store = new FileStore();
            service = new ConversionService();
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String uploadPath = (String) session.getAttribute("uploadPath");
        String uploadName = (String) session.getAttribute("uploadName");
        String modeStr = (String) session.getAttribute("mode");

        if (uploadPath == null || uploadName == null || modeStr == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        Mode mode = Mode.valueOf(modeStr);

        // IDs
        String resultId = store.newId();
        String previewId = store.newId();

        try {
            Path in = Paths.get(uploadPath);
            Path outFinal;
            Path outPreview;

            String resultName;
            String resultMime;

            switch (mode) {

                case PDF_TO_WORD:
                    // ----- FICHIER FINAL -----
                    resultName = uploadName.replaceAll("\\.pdf$", "") + ".docx";
                    outFinal = store.getBaseDir().resolve(resultId + "_" + resultName);
                    service.pdfToWord(in, outFinal);
                    resultMime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

                    // ----- APERÇU PDF -----
                    outPreview = store.getBaseDir().resolve(previewId + "_preview.pdf");
                    service.wordToPdfWithLibreOffice(outFinal, outPreview);
                    break;

                case PDF_TO_EXCEL:
                    // ----- FICHIER FINAL -----
                    resultName = uploadName.replaceAll("\\.pdf$", "") + ".xlsx";
                    outFinal = store.getBaseDir().resolve(resultId + "_" + resultName);
                    service.pdfToExcel(in, outFinal);
                    resultMime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    // ----- APERÇU PDF -----
                    outPreview = store.getBaseDir().resolve(previewId + "_preview.pdf");
                    service.wordToPdfWithLibreOffice(outFinal, outPreview);
                    break;

                default: // WORD_TO_PDF
                    resultName = uploadName.replaceAll("\\.docx$", "") + ".pdf";
                    outFinal = store.getBaseDir().resolve(resultId + "_" + resultName);
                    service.wordToPdfWithLibreOffice(in, outFinal);
                    resultMime = "application/pdf";

                    // ----- APERÇU = PDF FINAL -----
                    previewId = resultId;
                    break;
            }

            // URL téléchargement
            String downloadUrl = req.getRequestURL().toString().replace("/convert", "")
                    + "/download?id=" + resultId;

            // Liens partage
            String wa = ShareLinkUtil.whatsappShareLink(downloadUrl);
            String tg = ShareLinkUtil.telegramShareLink(downloadUrl);

            // Session
            session.setAttribute("resultId", resultId);
            session.setAttribute("previewId", previewId);
            session.setAttribute("resultName", resultName);
            session.setAttribute("resultMime", resultMime);
            session.setAttribute("waLink", wa);
            session.setAttribute("tgLink", tg);

            resp.sendRedirect(req.getContextPath() + "/result.jsp");

        } catch (Exception e) {
            throw new ServletException("Conversion échouée : " + e.getMessage(), e);
        }
    }
}
