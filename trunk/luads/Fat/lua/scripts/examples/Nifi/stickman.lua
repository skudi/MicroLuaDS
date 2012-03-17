-- Fichier: stickman.lua
-- Auteur : Thomh@ck
-- Description : Script de démonstration d'utilisation Nifi:
--				 Ce script permet de d'affichez un stickman sur l'écran inférieur, controllez par le fichier ' direction.lua '

	
	
Nifi.init(10)  -- Initialisation du nifi sur le canal 10 ( le même canal que le fichier direction.lua )

perso = Image.load("man.png", VRAM)  -- Chargement du stickman en VRAM

x = 140  -- Position X par default du stickman
y = 90   -- Position Y par default du stickman

while not Keys.newPress.Start do
	Controls.read()
	
		if Nifi.checkMessage() then  -- Fonction renvoyant ' true ' si un message est envoyé.
		  
		  dir = Nifi.readMessage() -- Fonction renvoyant dans la variable ' dir ' la valeur du message envoyer 

				if dir == "up" then  -- Comparaison du message reçu avec un chaine de caractère ( ici " up " )
					y = y - 2		 -- Si la condition est vérifié c'est que le bouton haut a été préssé sur l'autre nintendo DS.
				end
				
				if dir == "down" then
					y = y + 2
				end
				
				if dir == "right" then
					x = x + 2
				end
				
				if dir == "left" then
					x = x - 2
				end
		end	
		
		screen.blit(SCREEN_DOWN,x,y,perso)
	
	render()
end 

Nifi.stop()  -- Fonction terminant la connexion Nifi
Image.destroy(perso)   -- Déstruction du stickman
perso = nil		-- Déstruction des variables pour libéré la mémoire.
x = nil
y = nil
