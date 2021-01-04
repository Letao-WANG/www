{% include "enTete.tpl" %}

<div id="mySidenav" class="sidenav cadre">
	<h1 class="item centrer">Menu</h1>
	<a href="javascript:void(0)" class="closebtn changementCouleur" onclick="closeNav()">&times;</a>
	{% if 'E' in user.getRole() %}
	<a href="journalDeBord.php" class="item changementCouleur">Journal de bord (Enseignant)</a>
	<a href="etatSeances.php" class="item changementCouleur">Etat des séances (Enseignant)</a>
	{% endif %}
	<a href="logout.php" class="item btnDeco">Déconnexion</a>
</div>

<div id="overlay">
<div id="main">
	<main class="cadre">
		<section>
			<article>
				<a href="menuAdmin.php?choix=utilisateur">
					<input class="btnMenu option" type="submit" value="Modifier les paramètres des utilisateurs">
				</a>
			</article>
			<article>
				<a href="menuAdmin.php?choix=module">
					<input class="btnMenu option" type="submit" value="Modifier les paramètres des modules">
				</a>
			</article>
			<article>
				<a href="menuAdmin.php?choix=seance">
					<input class="btnMenu option" type="submit" value="Modifier les paramètres des séances et évènements">
				</a>
			</article>
			<article>
				<a href="menuAdmin.php?choix=groupe">
					<input class="btnMenu option" type="submit" value="Modifier les paramètres des groupes">
				</a>
			</article>
		</section>
	</main>
</div>
</div>

{% include "pied.tpl" %}
