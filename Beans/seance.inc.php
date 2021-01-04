<?php
/* BitsBee modifications :
	- la fonction getSemaine retourne d�sormais les jours du d�but et fin de la semaine et non le num�ro de la semaine.
		Avant      : Semaine 50
		Maintenant : 07 Dec - 13 Dec
*/

include_once "utilisateur.inc.php";
include_once "DB.inc.php";

class Seance {

	private static $db;
	private $valeur_module;
	private $date_seance;
	private $id_user;
	private $type_seance;
	private $groupe;

	public function __construct($valeur_module = null, $date_seance = '', $id_user = '', $type_seance = '', $groupe = '') {
		$this->valeur_module = $valeur_module;
		$this->date_seance   = $date_seance;
		$this->id_user       = $id_user;
		$this->type_seance   = $type_seance;
		$this->groupe        = $groupe;

		if (is_null(Seance::$db)) {
			Seance::$db = DB::getInstance();
		}
	}

	public function getValeurModule() { return $this->valeur_module; }
	public function getDateSeance($format = 'Y-m-d') {
		return date($format, strtotime($this->date_seance));
	}
	public function getIdUser()       { return $this->id_user; }
	public function getTypeSeance()   { return $this->type_seance; }
	public function getGroupe()       { return $this->groupe; }

	public function getSemaine(){
		if( date('D', strtotime($this->date_seance)) != 'Mon' ) // Si on est pas un lundi
			$lastMon = " last Monday"; // On indique que la semaine commence au lundi pr�c�dent
		if( date('D', strtotime($this->date_seance)) != 'Sun' ) // Si on est pas un jeudi
			$nextSun = " next Sunday"; // On indique que la semaine se termine au dimanche suivant

		$d = strtotime($this->date_seance.$lastMon); // r�cup�ration de la date du lundi
		$f = strtotime($this->date_seance.$nextSun); // r�cup�ration de la date du dimanche
		
		return date( "d M", $d )." - ".date( "d M", $f ); // retourner le rendu sous forme JJ MMM (lundi) - JJ MMM (dimanche)
	}

	public function getNomModule() {
		return Seance::$db->getNomModule($this->valeur_module)[0];
	}

	public function getUser() {
		$user = Seance::$db->getUtilisateur($this->id_user);
		return $user[0]->getPrenom().' '.$user[0]->getNom();
	}

	public function getEvents(){
		//echo Seance::$db->getEvents($this)[0]->getLibEvent();
		return Seance::$db->getEvents($this);
	}

	public function coulModule(){
		return Seance::$db->coulModule($this->valeur_module);
	}

	public function estParentDe($event) {
		return $this->valeur_module == $event->getValeurModule() &&
		       $this->date_seance == $event->getDateSeance() &&
			   $this->id_user == $event->getIdUser() &&
			   $this->type_seance == $event->getTypeSeance() &&
			   $this->groupe == $event->getGroupe();
	}

	public function estEntreDates($dateDeb, $dateFin){
		$deb = strtotime($dateDeb);
		$fin = strtotime($dateFin);
		$dateSeance = strtotime($this->date_seance);

		return (($dateSeance >= $deb) && ($dateSeance <= $fin));
	}
}
?>
