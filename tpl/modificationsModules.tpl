{% include "enTete.tpl" %}

<script src="javascript/jquery.js"></script>

<div id="mySidenav" class="sidenav cadre">
	<h1 class="item">Menu</h1>
	<a href="javascript:void(0)" class="closebtn changementCouleur" onclick="closeNav()">&times;</a>
	{% if 'E' in user.getRole() %}
		<a href="journalDeBord.php" class="item changementCouleur">Journal de bord (Enseignant)</a>
		<a href="etatSeances.php" class="item changementCouleur">Etat des séances (Enseignant)</a>
	{% endif %}
	<a href="menuAdmin.php" class="item changementCouleur">Retour au menu Admin</a>
	<a href="logout.php" class="item btnDeco">Déconnexion</a>
</div>

<div id="overlay">
<div id="main">
<main>
{% set droits = ['E', 'T'] %}
	<input type="button" value="Ajouter" class="option ajoutModule" onclick="masquer_div('a_masquer');"/>
	<div id="a_masquer" style="display:none">
	<form method="post" action="modificationsModules.php">
		<table class="cadreSimple">
			<tr>
				<td>Valeur :</td>
				<td><input type="text" name="valeur" id="valeurAjout"/></td>
			</tr>
			<tr>
				<td>Libellé :</td>
				<td><input type="text" name="lib" id="libelleAjout"/></td>
			</tr>
			<tr>
				<td>Couleur :</td>
				<td><input type="color" name="col2" id="couleurAjout" style="width:25%"/></td>
			</tr>
			<tr>
				<td>Droit :</td>
				<td>
					<select name="droit" id="droitAjout">
{% for droit in droits %}
						<option value="{{droit}}">{{droit}}</option>
{% endfor %}
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" class="option" style="width: 50%;" value="Valider" onclick="ajouterModule()">
					<input type="reset"  class="option" style="width: 50%;" value="Annuler">
				</td>
			</tr>
		</table>
	</form>
	</div>

	<section class="lsModule">
{% if tuplesModules|length-1 >= 0 %}
{% for i in range(0, tuplesModules|length-1)%}
		<table class="cadreSimple">
			<tr>
				<th>Valeur</th>
				<th>Libellé</th>
				<th>Couleur</th>
				<th>Droit</th>
				<th>Enseignants affectés</th>
				<th style="display:none" class="ModuleAffect{{i}}">Enseignants non-affectés</th>
				<th>Action</th>
			</tr>
			<tr>
				<td><input type="text" value="{{tuplesModules[i].getValeurModule()}}" class="readModule{{i}} Module{{i}}"  style="text-align: center;" readonly/></td>
				<td><input type="text" value="{{tuplesModules[i].getLibModule()}}" class="readModule{{i}} Module{{i}}" style="text-align: center;" readonly/></td>
				<td><input type="color" name="col1" value="#{{tuplesModules[i].getCouleur()}}" class="actionModule{{i}} Module{{i}}" disabled></td>
				<td>
					<select name="" class="actionModule{{i}} Module{{i}}" disabled>
					{% for droit in droits %}
						{% if droit == tuplesModules[i].getDroit()%}
							<option selected value="{{droit}}" class="module{{i}}">{{droit}}</option>
						{% else %}
							<option value="{{droit}}">{{droit}}</option>
						{% endif %}
					{% endfor %}
					</select>
				</td>
				<td>

					{% set ensAff = [] %}

					{% for enseignant in enseignants  %}
						{% if  tuplesModules[i].possedeAffectation(enseignant) %}
							{% set ensAff = ensAff|merge([ enseignant.getId() ]) %}
						{% endif %}
					{% endfor %}

					{% if ensAff is not empty %}
						<select name="temp" class="desaffect{{i}}">
							{% for ens in ensAff %}
									<option value=""> {{ens}} </option>
							{% endfor %}
						</select>
					{% else %}
							<input type="text" value="Aucune Affectation"  id="info" style="text-align: center;" readonly>
							<select name="temp" class="desaffect{{i}}" id="temp" style="display:none"></select>
					{% endif %}


					<input type="button" value="Désaffecter"  class="ModuleDesaffect{{i}} option" style="display:none" onclick="affect({{i}}, false)">
				</td>
				<td class="ModuleAffect{{i}}" style="display:none">
					<select name="temp" class="affect{{i}}">
						{% for enseignant in enseignants %}
							{% if not tuplesModules[i].possedeAffectation(enseignant) and enseignant.compareDroitRole(tuplesModules[i].getDroit()) %}
								<option value="">{{enseignant.getId()}}</option>
							{% endif %}
						{% endfor %}
					</select>
					<input type="button" value="Affecter"  class="ModuleAffect{{i}} option" style="display:none" onclick="affect({{i}}, true)">
				</td>
				<td>
					<input type="button" value="Modifier"  class="option" id="Module{{i}}" onclick="changerAttribut('Module{{i}}')">
					<input type="button" value="Annuler"   class="option ModuleAffect{{i}}" id="Module{{i}}" onclick="document.location.reload();" style="display:none"> <br/>
					<input type="button" value="Supprimer" class="option" id="Module{{i}}" onclick="supprimerModule('{{tuplesModules[i].getValeurModule()}}')">
				</td>
			</tr>
		</table>
{% endfor %}
{% endif %}
	</section>


</main>
</div>
</div>

	<script type="text/javascript">

	function ajouterModule() {
		var valeur   = document.getElementById("valeurAjout").value;
		var libel    = document.getElementById("libelleAjout").value;
		var col      = document.getElementById("couleurAjout").value;
		var color    = col.substring(1,col.length);
		var list     = document.getElementById("droitAjout");
		var aAjouter = list.options[list.selectedIndex].text;
		
		$.ajax({
			url : 'ajaxQuery.php',
			type : 'POST',
			data :{
				myFunction : "ajouterModule",
				param : {
					valeur : JSON.stringify(valeur),
					libel : JSON.stringify(libel),
					color : JSON.stringify(color),
					aAjouter : JSON.stringify(aAjouter)
				}
			},
			success: function(data){
				// console.log(data);
				document.location.reload();
			}
		});
	}

	function masquer_div(id) {
		if (document.getElementById(id).style.display == 'none') {
			document.getElementById(id).style.display = null;
		}
		else
			document.getElementById(id).style.display = 'none';
	}

	function changerAffect(id) {
		var tabDisplay =  document.getElementsByClassName(id);
		for (var i=0; i<tabDisplay.length; i++) {
			if (tabDisplay[i].style.display == 'none') {
				tabDisplay[i].style.display = null;
			}
			else
				tabDisplay[i].style.display = 'none';
		}
	}

	function affect(num, enAffectation) {
		if(enAffectation){
			var tab = ['affect','desaffect'];
		}
		else
			var tab = ['desaffect','affect'];

		var list = document.getElementsByClassName(tab[0]+num)[0];
		var aAffecter = list.options[list.selectedIndex].text;
		list.removeChild(list.options[list.selectedIndex]);

		var autreList = document.getElementsByClassName(tab[1]+num)[0];
		var opt = document.createElement('option');
		opt.appendChild( document.createTextNode(aAffecter) );
		autreList.appendChild(opt);
	}

	function changerAttribut(module) {

		var ligneReadModule = document.getElementsByClassName("read"+module);


		for (var i=0; i<ligneReadModule.length; i++) {

			if(ligneReadModule[i].readOnly) {
				ligneReadModule[i].removeAttribute('readonly');
				document.getElementById(module).value = "Terminer";
				document.getElementById(module).setAttribute( "onClick", "javascript: enregistrerModif('"+module+"');" )
			}
			else {
				ligneReadModule[i].setAttribute('readOnly','');
				document.getElementById(module).value = "Modifier";
				document.getElementById(module).setAttribute( "onClick", "javascript: changerAttribut('"+module+"');" )
			}
		}

		document.getElementById('info').style.display = 'none';
		document.getElementById('temp').style.display = null;

		var ligneActionModule = document.getElementsByClassName("action"+module);
		for (var i = 0; i < ligneActionModule.length; i++) {
			if(ligneActionModule[i].disabled)
				ligneActionModule[i].removeAttribute('disabled');
			else
				ligneActionModule[i].setAttribute('disabled','');
		}
		changerAffect("ModuleDesaffect".concat(module.substring(6)));
		changerAffect("ModuleAffect".concat(module.substring(6)));

	}

	function supprimerModule(module) {
		if(confirm('Êtes-vous sûr de vouloir supprimer ce module ?')) {
			$.ajax({
				url : 'ajaxQuery.php',
				type : 'POST',
				data :{
					myFunction : "supprModule",
					param : {
						module : JSON.stringify(module)
					}
				},
				success: function(data){
					document.location.reload();
				}
			})
		}
	}

	function enregistrerModif(module){
		var tabModule = document.getElementsByClassName(module);
		var listeModif = [tabModule[0].value,tabModule[1].value,tabModule[2].value,tabModule[3].value,module.substring(6)];

		$.ajax({
			url : 'ajaxQuery.php',
			type : 'POST',
			data :{
				myFunction : "modifModules",
				param : {
					listeModif : JSON.stringify(listeModif)
				}
			},
			success: function(data){
				// console.log(data);
			}
		});

		var listeModif = [];
		var list = document.getElementsByClassName("desaffect"+module.substring(6));
		for (i = 0; i < list[0].length; i++)
			listeModif[i] = list[0].options[i].text;
		listeModif.push(module.substring(6));
		$.ajax({
			url : 'ajaxQuery.php',
			type : 'POST',
			data :{
				myFunction : "modifAffectModules",
				param : {
					listeModif : JSON.stringify(listeModif)
				}
			},
			success: function(data){
				document.location.reload();
			}
		});
	}

</script>
{% include "pied.tpl" %}
