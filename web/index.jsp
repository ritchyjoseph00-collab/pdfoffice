<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>PDF Office Converter</title>

  <style>
    :root{
      --bg:#0b1020;
      --panel:#0f1730;
      --panel2:#0c1328;
      --text:#e8ecff;
      --muted:#a8b0d6;
      --line:rgba(255,255,255,.10);
      --accent:#6d5cff;
      --accent2:#22c55e;
      --warn:#f59e0b;
      --shadow:0 22px 60px rgba(0,0,0,.45);
      --radius:18px;
    }

    *{box-sizing:border-box;}
    body{
      margin:0;
      font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial;
      color:var(--text);
      background:
        radial-gradient(1100px 680px at 15% -10%, rgba(109,92,255,.42), transparent 60%),
        radial-gradient(900px 620px at 90% 10%, rgba(34,197,94,.22), transparent 55%),
        radial-gradient(900px 520px at 40% 110%, rgba(245,158,11,.16), transparent 55%),
        linear-gradient(180deg, #070a15, #0b1020 45%, #070a15);
      min-height:100vh;
    }

    a{color:inherit; text-decoration:none;}
    .wrap{max-width:1100px; margin:0 auto; padding:22px 18px 60px;}

    /* Topbar */
    .topbar{
      display:flex; align-items:center; justify-content:space-between;
      padding:10px 0 18px;
      gap:12px;
    }
    .brand{
      display:flex; align-items:center; gap:10px;
      font-weight:900;
      letter-spacing:.2px;
    }
    .logo{
      width:40px; height:40px; border-radius:14px;
      background: linear-gradient(135deg, rgba(109,92,255,1), rgba(34,197,94,1));
      box-shadow: 0 12px 30px rgba(109,92,255,.25);
    }
    .brand small{
      display:block;
      color:var(--muted);
      font-weight:700;
      margin-top:2px;
      font-size:12px;
    }
    .nav{
      display:flex; gap:10px; flex-wrap:wrap;
      color:var(--muted);
      font-weight:700;
      font-size:13px;
    }
    .nav a{
      padding:10px 12px;
      border-radius:12px;
      border:1px solid transparent;
    }
    .nav a:hover{
      background:rgba(255,255,255,.06);
      border-color:rgba(255,255,255,.10);
      color:var(--text);
    }

    /* Hero */
    .hero{
      display:grid;
      grid-template-columns: 1.1fr .9fr;
      gap:16px;
      align-items:stretch;
      margin-top:8px;
    }
    @media (max-width: 920px){
      .hero{grid-template-columns:1fr;}
    }

    .heroLeft{padding:18px 6px;}
    .kicker{
      display:inline-flex; align-items:center; gap:10px;
      padding:8px 12px;
      border:1px solid var(--line);
      background: rgba(255,255,255,.03);
      border-radius:999px;
      color:var(--muted);
      font-weight:800;
      font-size:13px;
    }
    .dot{
      width:8px; height:8px; border-radius:999px; background:var(--accent2);
      box-shadow:0 0 0 6px rgba(34,197,94,.14);
    }

    h1{
      margin:14px 0 10px;
      font-size: clamp(30px, 4.2vw, 48px);
      line-height:1.07;
      letter-spacing:-.6px;
    }
    .sub{
      color:var(--muted);
      font-size:16px;
      line-height:1.6;
      max-width:62ch;
      margin:0;
    }

    .chips{display:flex; flex-wrap:wrap; gap:10px; margin-top:16px;}
    .chip{
      padding:9px 12px;
      border:1px solid var(--line);
      background: rgba(255,255,255,.03);
      border-radius:999px;
      font-weight:800;
      font-size:13px;
      color:#d7dcff;
    }

    /* Card upload */
    .card{
      background: linear-gradient(180deg, rgba(255,255,255,.06), rgba(255,255,255,.03));
      border:1px solid var(--line);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow:hidden;
    }
    .cardHead{
      padding:18px 18px 14px;
      background: linear-gradient(180deg, rgba(109,92,255,.16), transparent 65%);
      border-bottom:1px solid var(--line);
    }
    .cardTitle{
      margin:0;
      font-weight:900;
      font-size:16px;
      letter-spacing:.2px;
    }
    .cardDesc{
      margin:6px 0 0;
      color:var(--muted);
      font-size:13px;
      line-height:1.5;
    }
    .cardBody{padding:16px 18px 18px;}

    .drop{
      border:1px dashed rgba(255,255,255,.20);
      background: rgba(15,23,48,.45);
      border-radius:16px;
      padding:16px;
      display:flex;
      flex-direction:column;
      gap:12px;
    }

    label{
      font-weight:900;
      font-size:13px;
      color:#dfe4ff;
      margin-bottom:6px;
      display:block;
    }

    input[type=file], select{
      width:100%;
      padding:12px;
      border-radius:14px;
      border:1px solid rgba(255,255,255,.10);
      background: rgba(255,255,255,.04);
      color:var(--text);
      font-weight:800;
      outline:none;
    }
    input[type=file]{
      color:var(--muted);
      font-weight:700;
    }

    .row2{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap:10px;
    }
    @media (max-width: 520px){
      .row2{grid-template-columns:1fr;}
    }

    .btn{
      width:100%;
      padding:13px 14px;
      border-radius:14px;
      border:0;
      cursor:pointer;
      font-weight:900;
      letter-spacing:.2px;
      background: linear-gradient(135deg, var(--accent), #3b82f6);
      color:#fff;
      box-shadow: 0 14px 30px rgba(109,92,255,.22);
      transition: transform .12s ease, filter .12s ease;
    }
    .btn:hover{filter:brightness(1.06);}
    .btn:active{transform: translateY(1px);}

    .mini{
      display:flex; gap:10px; flex-wrap:wrap;
      margin-top:10px;
      color:var(--muted);
      font-size:12.5px;
      line-height:1.4;
    }
    .badge{
      display:inline-flex; gap:8px; align-items:center;
      padding:8px 10px;
      border-radius:999px;
      border:1px solid var(--line);
      background: rgba(255,255,255,.03);
    }
    .badge span{
      width:8px; height:8px; border-radius:999px;
      background: var(--warn);
      box-shadow:0 0 0 6px rgba(245,158,11,.13);
    }

    /* Features */
    .features{
      margin-top:26px;
      display:grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap:12px;
    }
    @media (max-width: 920px){ .features{grid-template-columns:1fr;} }

    .feat{
      background: rgba(255,255,255,.03);
      border:1px solid var(--line);
      border-radius: var(--radius);
      padding:16px;
    }
    .feat h3{margin:0 0 8px; font-size:15px;}
    .feat p{margin:0; color:var(--muted); line-height:1.6; font-size:13.5px;}

    /* Steps + FAQ */
    .twoCol{
      margin-top:18px;
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap:12px;
    }
    @media (max-width: 920px){ .twoCol{grid-template-columns:1fr;} }

    .box{
      background: rgba(255,255,255,.03);
      border:1px solid var(--line);
      border-radius: var(--radius);
      padding:16px;
    }
    .box h3{margin:0 0 10px;}
    .step{
      display:flex; gap:12px; padding:10px 0; border-top:1px solid var(--line);
    }
    .step:first-of-type{border-top:0;}
    .num{
      width:30px; height:30px; border-radius:10px;
      background: rgba(109,92,255,.18);
      border:1px solid rgba(109,92,255,.25);
      display:flex; align-items:center; justify-content:center;
      font-weight:900; color:#cfd4ff;
      flex:0 0 30px;
    }
    .step b{display:block; margin-bottom:3px;}
    .step small{color:var(--muted); line-height:1.5;}

    /* Footer */
    .footer{
      margin-top:22px;
      padding-top:18px;
      border-top:1px solid var(--line);
      display:flex; flex-wrap:wrap; gap:10px;
      align-items:center; justify-content:space-between;
      color:var(--muted);
      font-size:13px;
    }
    .links{display:flex; gap:10px; flex-wrap:wrap;}
    .links a{
      padding:8px 10px; border-radius:12px;
      border:1px solid transparent;
    }
    .links a:hover{
      background:rgba(255,255,255,.06);
      border-color:rgba(255,255,255,.10);
      color:var(--text);
    }
  </style>
</head>

<body>
  <div class="wrap">

    <header class="topbar">
      <div class="brand">
        <div class="logo" aria-hidden="true"></div>
        <div>
          PDF Office Converter
          <small>Rapide • Simple • Propre</small>
        </div>
      </div>

      <nav class="nav">
        <a href="#tools">Outils</a>
        <a href="#how">Comment ça marche</a>
        <a href="#faq">FAQ</a>
      </nav>
    </header>

    <main class="hero">
      <section class="heroLeft">
        <div class="kicker"><span class="dot"></span> Convertis tes fichiers en 3 clics</div>

        <h1>Convertisseur PDF ↔ Word<br>PDF → Excel • Word → PDF</h1>
        <p class="sub">
          Uploade ton fichier, choisis la conversion, puis récupère le résultat.
          Aperçu PDF intégré, téléchargement et partage WhatsApp/Telegram.
        </p>

        <div class="chips" id="tools">
          <div class="chip">📄 PDF → Word (.docx)</div>
          <div class="chip">📊 PDF → Excel (.xlsx)</div>
          <div class="chip">🧾 Word → PDF</div>
          <div class="chip">👁️ Aperçu PDF</div>
        </div>
      </section>

      <aside class="card" aria-label="Zone upload">
        <div class="cardHead">
          <p class="cardTitle">Uploader & Convertir</p>
          <p class="cardDesc">Choisis un fichier (PDF/DOCX) puis lance la conversion.</p>
        </div>

        <!-- ✅ Endpoint conservé: upload -->
        <form class="cardBody" method="post" action="upload" enctype="multipart/form-data">
          <div class="drop">

            <div>
              <label>Choisir un fichier</label>
              <input type="file" name="file" required>
            </div>

            <div class="row2">
              <div>
                <label>Type de conversion</label>
                <select name="mode" required>
                  <option value="PDF_TO_WORD">PDF → Word (.docx)</option>
                  <option value="PDF_TO_EXCEL">PDF → Excel (.xlsx)</option>
                  <option value="WORD_TO_PDF">Word → PDF</option>
                </select>
              </div>

              <div style="display:flex; align-items:end;">
                <button class="btn" type="submit">🚀 Convertir</button>
              </div>
            </div>

            <div class="mini">
              <div class="badge"><span></span> Taille max: 20MB (modifiable)</div>
              <div class="badge"><span style="background:var(--accent2); box-shadow:0 0 0 6px rgba(34,197,94,.13)"></span> Lien prêt pour WhatsApp/Telegram</div>
            </div>
          </div>
        </form>
      </aside>
    </main>

    <section class="features" aria-label="Avantages">
      <div class="feat">
        <h3>⚡ Rapide</h3>
        <p>Conversion optimisée et téléchargement immédiat.</p>
      </div>
      <div class="feat">
        <h3>🧠 Simple</h3>
        <p>Un fichier → une conversion → un résultat. Interface claire.</p>
      </div>
      <div class="feat">
        <h3>🔗 Partage</h3>
        <p>Génère un lien à partager sur WhatsApp/Telegram (surtout mobile).</p>
      </div>
    </section>

    <section class="twoCol" id="how" aria-label="Comment ça marche">
      <div class="box">
        <h3>Comment ça marche</h3>
        <div class="step">
          <div class="num">1</div>
          <div><b>Uploader</b><small>Choisis ton fichier PDF ou DOCX.</small></div>
        </div>
        <div class="step">
          <div class="num">2</div>
          <div><b>Convertir</b><small>Sélectionne le mode de conversion.</small></div>
        </div>
        <div class="step">
          <div class="num">3</div>
          <div><b>Aperçu & Télécharger</b><small>Visualise l’aperçu PDF puis télécharge.</small></div>
        </div>
      </div>

      <div class="box" id="faq">
        <h3>FAQ</h3>
        <div class="step">
          <div class="num">?</div>
          <div><b>Pourquoi l’aperçu est en PDF ?</b><small>DOCX/XLSX ne s’affichent pas bien dans tous les navigateurs. Le PDF est universel.</small></div>
        </div>
        <div class="step">
          <div class="num">?</div>
          <div><b>La mise en page est conservée ?</b><small>Word → PDF (LibreOffice) conserve bien. PDF → Word/Excel extrait surtout le texte.</small></div>
        </div>
        <div class="step">
          <div class="num">?</div>
          <div><b>Le partage fonctionne comment ?</b><small>WhatsApp/Telegram partagent un lien de téléchargement.</small></div>
        </div>
      </div>
    </section>

    <footer class="footer">
      <div>© <span id="y"></span> PDF Office Converter</div>
      <div class="links">
        <a href="#tools">Outils</a>
        <a href="#how">Guide</a>
        <a href="#faq">FAQ</a>
      </div>
    </footer>
  </div>

  <script>
    document.getElementById("y").textContent = new Date().getFullYear();
  </script>
</body>
</html>
