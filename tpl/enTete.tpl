<!DOCTYPE html>
<html lang="fr">
<head>

	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">

	<title>{{titre}}</title>

	<!-- CSS utilisé à travers le site -->
	<link rel="stylesheet" href="styles/site.css">

	<!-- CSS utilisé pour la page -->
{% for style in css %}
	<link rel="stylesheet" href="styles/{{style}}.css">
{% endfor %}

</head>
<body>

{% set test = titre != "Connexion" and titre != "Changement de mot de passe" and titre != ""%}

	<header class="cadre" id="header" >
		{%if test %}
		<span style="font-size:30px;cursor:pointer" onclick="openNav()">&#9776;</span>
		{%else%}
		<a href="https://di.iut.univ-lehavre.fr/pedago/index.xml"><img src="images/logo.gif" alt="Département Informatique" class="logo" /></a>
		{%endif%}
		<h1>
			{{ titre }}

			{%if test %}
			<div class="notification" onclick="this.disabled=true;openNotif();">
				&#x2709;
				{%if notifications|length > 0 %}
				<div class="badge">!</div>
				{% endif %}
			</div>
			{%endif%}
		</h1>


	</header>

	{% if test %}
	<div id="notifnav" class="notifnav cadre">
		<h1 class="item">Notifications</h1>
		<a href="javascript:void(0)" class="closebtn changementCouleur" onclick="closeNotif()">&times;</a>
		{% if notifications|length == 0 %}
		<div class="centrer">Vous n'avez pas de notification pour le moment.</div>
		{% else %}
		{% for notif in notifications %}
		<div style="text-align:center">{{notif.getTexte()}}</div>
		{% endfor %}
		{% endif %}
	</div>
	{% endif %}

	<script>
	// fonctions nav
	function openNav()
	{
		openGlobal();

		var menu   = document.getElementById("mySidenav");

		menu.style.width = "20%";
		menu.style.margin = "10% 0 0 40%";

		document.getElementById("overlay").setAttribute('onclick','closeNav()');$
	}

	function openNotif()
	{
		openGlobal();

		var menu   = document.getElementById("notifnav");

		menu.style.width = "20%";
		menu.style.margin = "10% 40% 0 0";

		document.getElementById("overlay").setAttribute('onclick','closeNotif()');
	}

	function openGlobal()
	{	
		var main   = document.getElementById("main"  );
		var header = document.getElementById("header");
		var body   = document.body;

		main  .style.opacity       = "0.5";
		header.style.opacity       = "0.5";
		main  .style.pointerEvents = "none";
		header.style.pointerEvents = "none";
		main  .style.userSelect    = "none";
		header.style.userSelect    = "none";

		body.style.height = "100%";
		body.style.overflow = "hidden";
	}

	function closeNav()
	{
		var menu   = document.getElementById("mySidenav");

		menu.style.width = "0";
		menu.style.margin = "10% 0 0 -5px";

		closeGlobal();
	}

	function closeNotif()
	{
		var menu   = document.getElementById("notifnav");

		menu.style.width = "0";
		menu.style.margin = "10% -5px 0 0";
		closeGlobal();
	}

	function closeGlobal()
	{
		var main   = document.getElementById("main"     );
		var header = document.getElementById("header"   );
		var body   = document.body;

		main  .style.opacity       = "1";
		header.style.opacity       = "1";
		main  .style.pointerEvents = "auto";
		header.style.pointerEvents = "auto";
		main  .style.userSelect    = "auto";
		header.style.userSelect    = "auto";

		body.style.height   = "auto";
		body.style.overflow = "visible";

		document.getElementById("overlay").removeAttribute('onclick');
	}

	</script>

