1. "Nom des lieux qui finissent par 'um'" :

	SELECT 
	nom_lieu 
	FROM lieu 
	WHERE nom_lieu 
	LIKE '%um'

2. "Nombre de personnages par lieu (trié par nombre de personnages décroissant)" :

    SELECT nom_lieu, COUNT(personnage.id_lieu) as nbPersonnages
	FROM lieu
	INNER JOIN personnage ON personnage.id_lieu = lieu.id_lieu
	GROUP BY lieu.id_lieu
	ORDER BY nbPersonnages DESC

3. "Nom des personnages + spécialité + adresse et lieu d 'habitation, triés par lieu puis par nom de personnage ":

	SELECT p.nom_personnage , p.adresse_personnage, l.nom_lieu, s.nom_specialite
	FROM personnage p
	INNER JOIN lieu l ON p.id_lieu = l.id_lieu
	INNER JOIN specialite s ON p.id_specialite = s.id_specialite
	ORDER BY l.nom_lieu,  p.nom_personnage

4. "Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant)" :

    SELECT s.nom_specialite, COUNT(p.nom_personnage) as NbPersonnages
	FROM specialite s
	INNER JOIN personnage p ON s.id_specialite = p.id_specialite
	GROUP BY s.id_specialite 
	ORDER BY NbPersonnages DESC
	
5. "Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa) ":

	SELECT b.nom_bataille, DATE_FORMAT(b.date_bataille, "%d/%m/%Y") as Date_DESC, l.nom_lieu 
	FROM bataille b
	INNER JOIN lieu l ON b.id_lieu = l.id_lieu
	ORDER BY b.date_bataille
	
6. "Nom des potions + coût de réalisation de la potion (trié par coût décroissant)" :

	SELECT p.nom_potion, SUM(c.qte * i.cout_ingredient) as cout_total
	FROM composer c
	INNER JOIN potion p ON c.id_potion = p.id_potion
	INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
	GROUP BY p.id_potion
	ORDER BY cout_total DESC

7. "Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'." :

    SELECT i.nom_ingredient, c.qte , i.cout_ingredient
	FROM potion p
	INNER JOIN composer c ON c.id_potion = p.id_potion
	INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
	Where p.id_potion = 3
	
8.  "Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'." :
   
	SELECT p.nom_personnage, SUM(pc.qte) as NbCasques
	FROM personnage p
	INNER JOIN prendre_casque pc ON p.id_personnage = pc.id_personnage
	INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
	WHERE b.id_bataille = 1 /* uniquement la "Bataille du village gaulois"*/
	GROUP BY p.id_personnage /*Regroupe résultats par perso, agrégation (ici,somme) des casques pris par chaque perso*/
	/*filtre pour ne garder que les persos dont le total de casques pris est au moins = au total le plus élevé de tous les persos, seuls les persos avec le plus nombre de casques sont selec (HAVING = WHERE + function agregation)
	SUM et pas MAX car il peut y avoir des casques de type diff pris par un perso*/
	HAVING SUM(pc.qte) >= ALL (
		SELECT SUM(pc.qte)
		FROM prendre_casque pc
		INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
		WHERE b.id_bataille = 1
		GROUP BY pc.id_personnage)

9.  "Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit)." :
    
    SELECT p.nom_personnage, SUM(b.dose_boire) as NBpotionBue
	FROM personnage p
	INNER JOIN boire b ON p.id_personnage = b.id_personnage
	GROUP BY p.id_personnage
	ORDER BY NBpotionBue DESC
	
10. "Nom de la bataille où le nombre de casques pris a été le plus important." :
    
	SELECT b.nom_bataille, SUM(pc.qte) AS nbCasques
	FROM bataille b
	INNER JOIN prendre_casque pc ON b.id_bataille = pc.id_bataille
	GROUP BY b.id_bataille
	/*idem à l'exo 8 avec condition sur la bataille en moins*/
	HAVING SUM(pc.qte) >= ALL (
		SELECT SUM(pc.qte)
		FROM prendre_casque pc
		GROUP BY pc.id_bataille
	)

11. "Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)" :

    SELECT tc.nom_type_casque, COUNT(c.nom_casque) as nb_type_casques, SUM(c.cout_casque) as coup_casques
	FROM casque c
	INNER JOIN type_casque tc ON c.id_type_casque = tc.id_type_casque
	GROUP BY tc.id_type_casque
	ORDER BY nb_type_casques DESC

12. "Nom des potions dont un des ingrédients est le poisson frais" :

    SELECT p.nom_potion
	FROM potion p
	INNER JOIN composer c ON p.id_potion = c.id_potion
	INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
	WHERE i.id_ingredient = 24	

13. "Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois." :

	SELECT l.nom_lieu, COUNT(p.id_personnage) as NbHabitants
	FROM lieu l
	INNER JOIN personnage p ON l.id_lieu = p.id_lieu
	WHERE l.id_lieu != 1
	GROUP BY l.id_lieu
	/*idem à l'exo 10 avec COUNT: count compte les lignes tandis que sum additionne les valeurs des colonnes (int)*/
	HAVING COUNT(p.id_personnage) >= ALL (
		SELECT COUNT(p.id_personnage)
		FROM personnage p
		INNER JOIN lieu l ON p.id_lieu = l.id_lieu
		WHERE l.id_lieu != 1
		GROUP BY l.id_lieu
    )
	
14. "Nom des personnages qui n'ont jamais bu aucune potion." :

	SELECT p.nom_personnage 
	FROM personnage p
	LEFT JOIN boire b ON p.id_personnage = b.id_personnage
	WHERE b.id_personnage IS NULL
	
15. "Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'." : 

	SELECT nom_personnage 
	FROM personnage 
	WHERE id_personnage NOT IN (
	 SELECT id_personnage 
	 FROM autoriser_boire
	 WHERE id_potion = 1
	 )


A."Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus." :

	INSERT INTO personnage VALUES (45,'Champdeblix','Ferme Hantassion','indisponible.jpg', 6, 12);
	
B."Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine..." :

	INSERT INTO autoriser_boire VALUES (1, 12);
	
C. "Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille." :

	DELETE 
	FROM casque
	WHERE (casque.id_type_casque = 2) AND (casque.id_casque NOT IN 
	(SELECT prendre_casque.id_casque FROM prendre_casque))

D. "Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate."

	UPDATE personnage
	SET adresse_personnage = "Prison", id_lieu = 9
	WHERE personnage.id_personnage = 23
	

E. "La potion 'Soupe' ne doit plus contenir de persil." :

    DELETE 
	FROM composer 
	WHERE (id_ingredient = 19 AND id_potion = 9)

F. " Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, 
     qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur ! " :

	UPDATE prendre_casque
	SET prendre_casque.id_casque = 10 , prendre_casque.qte = 42
	WHERE prendre_casque.id_personnage = 5 AND prendre_casque.id_bataille = 9
