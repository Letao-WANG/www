{# BitsBee modifications :
	- affichage des semaines :
		Avant      : Semaine 50
		Maintenant : 07 Dec - 13 Dec
	- Les s�ances �taient modifiables par tous les professeurs. Ils ne sont maintenant modifiables que par le cr�ateur de la s�ance.
	- Déplacement de la navigation dans un menu défillant à gauche
#}


{% include "enTete.tpl" %}
{# {% include "mois.tpl" %} #}

<div id="mySidenav" class="sidenav cadre">
	<h1 class="item">Menu</h1>

	<div class="centrer">{{user.getPrenom()}} {{user.getNom()}} : {{user.getRoleComplet()}}</div>
	<a href="javascript:void(0)" class="closebtn changementCouleur" onclick="closeNav()">&times;</a>
	<a href="etatSeances.php" class="item changementCouleur">Vers l'état des séances</a>
	{% if 'A' in user.getRole() %}
	<a href="menuAdmin.php" class="item changementCouleur">Mode administrateur</a>
	{% endif %}
	<div class="item btnDeco"><a href="logout.php">Déconnexion</a></div>
</div>

<div id="overlay">
<div id="main">
	{% include "navGaucheJournalDeBord.tpl" %}

	<main>
		<script src="javascript/jquery.js"></script>
		<script src="javascript/journalDeBord.js"></script>
		<div class="centre">
			<article>
{% for seance in seances %}
{% if user.aAccesGroupe(seance.getGroupe()) and user.getRole()=='T' or user.getRole()!='T' %}
				<section class="cadreSimple semaine">
					{{seance.getSemaine()}}
				</section>
				<form action="journalDeBord.php" method="get">
					<table class="cadre seance">
						<tr style="background-color:#{{seance.coulModule()}}">
							<td colspan="2"><h2>{{seance.getNomModule()}}</h2></td>
							<td colspan="5"></td>
						</tr>
						<tr class="panel-inactif">
							<td>Module : {{seance.getValeurModule()}}</td>
							<td id="{{seance.getIdUser()}}">Propriétaire : {{seance.getUser()}}</td>
							<td id="{{seance.getDateSeance()}}">A la date du : {{seance.getDateSeance('d/m/Y')}}</td>
							<td>Type : {{seance.getTypeSeance()}}</td>
							<td>Groupe : {{seance.getGroupe()}}</td>
							<td>
{% if user.getId() == seance.getIdUser() %}
								<img src="./images/crayon.png" alt="Modifier" id="modif" class="imgAffiche">
								<img src="./images/poubelle.png" alt="Supprimer" class="imgAffiche">
{% endif %}
							</td>
						</tr>
{% set tmp = 0 %}
{% for evenement in seance.getEvents() %}
{# #}{% set tmp = tmp+1%}
{% endfor %}
{% if tmp>0 %}
						<tr class="evenement-hidden">
							<th>Numéro de l'activité</th>
							<th>Type de travail</th>
							<th>Descriptif</th>
							<th>Date rendu</th>
							<th>Durée</th>
							<th>Pièces jointes</th>
							<th></th>
						</tr>
{% endif %}

{% set nb = 1 %}
{% for evenement in seance.getEvents() %}
						<tr class="evenement-hidden">
							<td id_event="{{evenement.getIdEvent()}}">{{nb}}</td>
{% set nb = nb+1 %}
							<td>{{evenement.getTypeEvent()}}</td>
							<td style="word-wrap: break-word;max-width:20vh;">{{evenement.getLibEvent()}}</td>
{% if evenement.getDateRendu is null %}
							<td></td>
{% else %}
							<td>{{evenement.getDateRendu('d/m/Y')}}</td>
{% endif %}
							<td>{{evenement.getDuree()}}</td>
{% set pjs = evenement.getPiecesJointes() %}
							<td style="word-wrap: break-word;max-width:10vh;">
{% for pj in pjs %}
								<a href="pj/documents_{{pj.getDate()}}/{{pj.getNomFichier()}}" download="{{pj.getPj()}}">{{pj.getPj()}}</a>
								<br />
{% endfor %}
							</td>
							<td></td>
						</tr>
{% endfor %}
					</table>
				</form>
{% endif %}

{% endfor %}
			</article>
		</div>
	</main>

</div>
</div>
	<script>
		var accI = document.getElementsByClassName("panel-inactif");
		var i;

		for (i = 0; i < accI.length; i++) {
			accI[i].addEventListener("click", function() {
				this.classList.toggle("panel-actif");
				var ligne = this.nextElementSibling;
				do {
					toggleVisibility(ligne);
					ligne = ligne.nextElementSibling;
					if (ligne === null)
						break;
				} while (ligne.className.startsWith("evenement"));
			});
		}

		function toggleVisibility(ligne) {
			if (ligne.className == "evenement") {
				ligne.className = "evenement-hidden";
			} else {
				ligne.className = "evenement";
			}
		}
	</script>

{% include "pied.tpl" %}
