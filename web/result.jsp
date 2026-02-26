<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String resultId   = (String) session.getAttribute("resultId");
  String previewId  = (String) session.getAttribute("previewId");
  String resultName = (String) session.getAttribute("resultName");
  String waLink     = (String) session.getAttribute("waLink");
  String tgLink     = (String) session.getAttribute("tgLink");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Résultat • PDF Office Converter</title>

  <style>
    :root{
      --bg:#0b1020;
      --panel:#0f1730;
      --panel2:#0c1328;
      --text:#e8ecff;
      --muted:#a8b0d6;
      --line:rgba(255,255,255,.10);

      --accent:#6d5cff;
      --blue:#3b82f6;
      --green:#22c55e;
      --wa:#25D366;
      --tg:#229ED9;

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
        radial-gradient(900px 520px at 40% 110%, rgba(59,130,246,.16), transparent 55%),
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

    /* Card */
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
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap:12px;
      flex-wrap:wrap;
    }
    .titleBlock h2{
      margin:0;
      font-size:18px;
      letter-spacing:.2px;
    }
    .titleBlock p{
      margin:6px 0 0;
      color:var(--muted);
      font-size:13px;
      line-height:1.45;
    }

    .status{
      display:inline-flex;
      align-items:center;
      gap:10px;
      padding:10px 12px;
      border-radius:999px;
      border:1px solid rgba(34,197,94,.25);
      background: rgba(34,197,94,.12);
      font-weight:900;
      font-size:13px;
      color:#d7ffe5;
      white-space:nowrap;
    }
    .status .dot{
      width:8px; height:8px; border-radius:999px;
      background: var(--green);
      box-shadow: 0 0 0 6px rgba(34,197,94,.14);
    }

    .cardBody{padding:16px 18px 18px;}

    .fileRow{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:10px;
      flex-wrap:wrap;
      padding:12px 14px;
      border:1px solid var(--line);
      background: rgba(15,23,48,.45);
      border-radius: 16px;
    }
    .fileRow b{font-size:13px; color:#dfe4ff;}
    .fileName{
      color:var(--text);
      font-weight:900;
      max-width: 100%;
      word-break: break-word;
    }

    .actions{
      margin-top:12px;
      display:flex;
      flex-wrap:wrap;
      gap:10px;
    }
    .btn{
      display:inline-flex;
      align-items:center;
      gap:10px;
      padding:12px 14px;
      border-radius:14px;
      border:1px solid rgba(255,255,255,.10);
      background: rgba(255,255,255,.04);
      color:var(--text);
      font-weight:900;
      cursor:pointer;
      transition: transform .12s ease, filter .12s ease, background .12s ease;
      user-select:none;
    }
    .btn:hover{background: rgba(255,255,255,.06);}
    .btn:active{transform: translateY(1px);}

    .btnPrimary{
      border:0;
      background: linear-gradient(135deg, var(--accent), var(--blue));
      box-shadow: 0 14px 30px rgba(109,92,255,.22);
    }
    .btnGreen{
      border:0;
      background: linear-gradient(135deg, rgba(34,197,94,1), rgba(16,185,129,1));
      box-shadow: 0 14px 30px rgba(34,197,94,.18);
    }
    .btnWA{
      border:0;
      background: linear-gradient(135deg, rgba(37,211,102,1), rgba(16,185,129,1));
      box-shadow: 0 14px 30px rgba(37,211,102,.18);
    }
    .btnTG{
      border:0;
      background: linear-gradient(135deg, rgba(34,158,217,1), rgba(59,130,246,1));
      box-shadow: 0 14px 30px rgba(34,158,217,.18);
    }

    .hint{
      margin:14px 0 0;
      color:var(--muted);
      font-size:13px;
      line-height:1.55;
    }

    .preview{
      margin-top:16px;
      border:1px solid var(--line);
      background: rgba(15,23,48,.45);
      border-radius: 16px;
      overflow:hidden;
    }
    .previewHead{
      padding:12px 14px;
      border-bottom:1px solid var(--line);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:10px;
      flex-wrap:wrap;
    }
    .previewHead b{font-size:13px;}
    .previewHead small{color:var(--muted); font-weight:700;}
    iframe{
      width:100%;
      height:680px;
      border:0;
      display:block;
      background:#fff;
    }

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
          <small>Résultat de conversion</small>
        </div>
      </div>

      <nav class="nav">
        <a href="index.jsp">Nouvelle conversion</a>
        <a href="<%= request.getContextPath() %>/download?id=<%= resultId %>">Télécharger</a>
      </nav>
    </header>

    <section class="card">
      <div class="cardHead">
        <div class="titleBlock">
          <h2>Conversion terminée</h2>
          <p>Ton fichier est prêt. Tu peux le télécharger, le partager, ou le visualiser ci-dessous.</p>
        </div>

        <div class="status">
          <span class="dot"></span> OK
        </div>
      </div>

      <div class="cardBody">
        <div class="fileRow">
          <div>
            <b>Fichier :</b>
            <div class="fileName"><%= resultName %></div>
          </div>
        </div>

        <div class="actions">
          <a class="btn btnGreen" href="<%= request.getContextPath() %>/download?id=<%= resultId %>">📥 Télécharger</a>
          <a class="btn btnWA" href="<%= waLink %>" target="_blank">🟢 WhatsApp</a>
          <a class="btn btnTG" href="<%= tgLink %>" target="_blank">🔵 Telegram</a>
          <a class="btn btnPrimary" href="index.jsp">↩️ Nouvelle conversion</a>
        </div>

        <p class="hint">
          <b>Partage WhatsApp/Telegram :</b> l’app partage un <b>lien de téléchargement</b>.
          Pour l’aperçu, on affiche la version PDF générée.
        </p>

        <div class="preview">
          <div class="previewHead">
            <b>👁️ Aperçu (PDF)</b>
            <small>Si l’aperçu ne charge pas, utilise “Télécharger”.</small>
          </div>
          <iframe src="<%= request.getContextPath() %>/view?id=<%= previewId %>"></iframe>
        </div>
      </div>
    </section>

    <footer class="footer">
      <div>© <span id="y"></span> PDF Office Converter</div>
      <div class="links">
        <a href="index.jsp">Accueil</a>
        <a href="<%= request.getContextPath() %>/download?id=<%= resultId %>">Télécharger</a>
      </div>
    </footer>
  </div>

  <script>
    document.getElementById("y").textContent = new Date().getFullYear();
  </script>
</body>
</html>
