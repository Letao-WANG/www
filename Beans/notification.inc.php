<?php

include_once "DB.inc.php";

class Notification {

    private $id_notif;
    private $titre;
    private $texte;
    private $id_Exp;
    private $id_Dest;
    private static $db;

    public function __construct($id_notif = '', $titre = '', $texte = '', $id_Exp = '', $id_Dest = '') {
        $this->id_notif = $id_notif;
        $this->titre    = $titre;
        $this->texte    = $texte;
        $this->id_Exp   = $id_Exp;
        $this->id_Dest  = $id_Dest;

        if (is_null(Notification::$db)) {
            Notification::$db = DB::getInstance();
        }
    }

    public function getId     () { return $this->id_notif; }
    public function getTitre  () { return $this->titre;    }
    public function getTexte  () { return $this->texte;    }
    public function getId_Exp () { return $this->id_Exp;   }
    public function getId_Dest() { return $this->id_Dest;  }
}
?>
