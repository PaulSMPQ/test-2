<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>Relance - Ajouter/Modifier un vendeur</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <div class="edit-vendeur-page">
    <h2 id="form-title">Ajouter un vendeur</h2>
    <form id="vendeurForm">
      <label>Nom :
        <input type="text" name="nom" required>
      </label>
      <label>Référence du bien :
        <input type="text" name="ref_bien" required>
      </label>
      <label>Numéros de téléphone (séparés par une virgule) :
        <input type="text" name="telephones" placeholder="06 01 02 03 04, 07 05 06 07 08" required>
      </label>
      <label>Commentaire :
        <textarea name="commentaire" placeholder="Notes ou particularités (optionnel)"></textarea>
      </label>
      <div class="edit-btns">
        <button type="submit">Sauvegarder</button>
        <button type="button" id="cancelBtn">Annuler</button>
      </div>
    </form>
  </div>
  <script>
    // Mode modification ?
    const params = new URLSearchParams(window.location.search);
    const id = params.get('id');
    if (id) {
      document.getElementById('form-title').textContent = "Modifier un vendeur";
      // Charger les infos vendeur
      fetch(`/api/vendeur/${id}`)
        .then(res => res.json())
        .then(vendeur => {
          document.querySelector('[name="nom"]').value = vendeur.nom;
          document.querySelector('[name="ref_bien"]').value = vendeur.ref_bien;
          document.querySelector('[name="telephones"]').value = (vendeur.telephones || []).join(", ");
          document.querySelector('[name="commentaire"]').value = vendeur.commentaire || '';
        });
    }

    // Gestion soumission formulaire
    document.getElementById('vendeurForm').onsubmit = async function(e) {
      e.preventDefault();
      const data = {
        nom: this.nom.value,
        ref_bien: this.ref_bien.value,
        telephones: this.telephones.value.split(",").map(t => t.trim()).filter(Boolean),
        commentaire: this.commentaire.value
      };
      if (id) {
        // Edition
        await fetch(`/api/vendeur/${id}`, {
          method: "PUT",
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify(data)
        });
      } else {
        // Création
        await fetch("/api/vendeur", {
          method: "POST",
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify(data)
        });
      }
      window.location.href = "index.html";
    };

    document.getElementById('cancelBtn').onclick = function() {
      window.location.href = "index.html";
    };
  </script>
</body>
</html>
