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
   
    SELECT p.nom_personnage , SUM(pc.qte) as NbCasques
	FROM personnage p
	INNER JOIN prendre_casque pc ON p.id_personnage = pc.id_personnage
	INNER JOIN bataille b ON b.id_bataille = pc.id_bataille
	WHERE b.nom_bataille = "Bataille du village gaulois"
	GROUP BY p.id_personnage
	ORDER BY NbCasques DESC

9.  "Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit)." :
    
    SELECT p.nom_personnage, SUM(b.dose_boire) as NBpotionBue
	FROM personnage p
	INNER JOIN boire b ON p.id_personnage = b.id_personnage
	GROUP BY p.id_personnage
	ORDER BY NBpotionBue DESC
	
10. "Nom de la bataille où le nombre de casques pris a été le plus important." :
    
    SELECT b.nom_bataille, SUM(pc.qte) as nbCasques
	FROM bataille b
	INNER JOIN prendre_casque pc ON b.id_bataille = pc.id_bataille
	GROUP BY b.id_bataille
	ORDER BY nbCasques DESC

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

	SELECT l.nom_lieu, COUNT(p.id_lieu) as NbHabitants
	FROM lieu l
	INNER JOIN personnage p ON l.id_lieu = p.id_lieu
	WHERE l.nom_lieu != "Village gaulois"
	GROUP BY p.id_lieu
	ORDER BY NbHabitants DESC
	
14. "Nom des personnages qui n'ont jamais bu aucune potion." :

	SELECT p.nom_personnage 
	FROM personnage p
	LEFT JOIN boire b ON p.id_personnage = b.id_personnage
	WHERE b.id_personnage IS NULL
	
15. "Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'." : 

	SELECT p.nom_personnage 
	FROM personnage p 
	WHERE p.nom_personnage NOT IN (
		SELECT p.nom_personnage
		FROM personnage p
		INNER JOIN autoriser_boire ab ON p.id_personnage = ab.id_personnage
		INNER JOIN potion po ON ab.id_potion = po.id_potion
		WHERE po.nom_potion = 'Magique'
	)
	
	"On sélectionne d'abord ceux qui ont le droit de boire la potion (id=1) et ensuite
	 on garde ceux qui ne font pas partie de cet ensemble". 