import time
import pygame
import sys
from menu import menu
from state import State
from game import Game
from algorithms import minimax, alphabeta


MAX_DEPTH = 4



def main():
	pygame.init()
	pygame.display.set_caption("Gabriel Gruia 231 - GO!")
	logo = pygame.image.load("images/logo.png")
	pygame.display.set_icon(logo)

	#dimensiunea ferestrei in pixeli
	screen = pygame.display.set_mode(size=(500, 300))
	algorithm, Game.JMIN, difficulty, boardSize = menu(screen)
	boardSize = int(boardSize)
	cellSize = 50
	screen = pygame.display.set_mode((boardSize * cellSize, boardSize * cellSize))

	Game.prepare(screen, boardSize, cellSize)
	board = Game(boardSize)
	board.drawGrid()

	Game.JMAX= 'W' if Game.JMIN == 'B' else 'B'


	print("\nInitial state:")
	print(str(board))

	#creare stare initiala
	stare_curenta = State(board, 'B', MAX_DEPTH)

	board.drawGrid()


	while True :
		if stare_curenta.player == Game.JMIN:
			for event in pygame.event.get():
				if event.type == pygame.QUIT:
					pygame.quit()
					sys.exit()
				if event.type == pygame.MOUSEMOTION:
					
					pos = pygame.mouse.get_pos()#coordonatele cursorului
					for np in range(len(Game.celuleGrid)):						
						if Game.celuleGrid[np].collidepoint(pos):
								stare_curenta.board.drawGrid(coloana_marcaj = np % Game.SIZE)
								break

				elif event.type == pygame.MOUSEBUTTONDOWN:
					pos = pygame.mouse.get_pos()#coordonatele cursorului la momentul clickului
					for np in range(len(Game.celuleGrid)):
						if Game.celuleGrid[np].collidepoint(pos):
							coloana = np % Game.SIZE
							###############################
							
							if stare_curenta.board.config[0][coloana] == Game.GOL:	
								niv = 0
								while True:
									if niv == Game.SIZE or stare_curenta.board.config[niv][coloana] != Game.GOL:
										stare_curenta.board.config[niv - 1][coloana] = Game.JMIN
										stare_curenta.board.lastMove = (niv-1, coloana)
										break
									niv += 1
								
								#afisarea starii jocului in urma mutarii utilizatorului
								print("\nTabla dupa mutarea jucatorului")
								print(str(stare_curenta))
								
								stare_curenta.board.drawGrid(coloana_marcaj=coloana)
								#testez daca jocul a ajuns intr-o stare finala
								#si afisez un mesaj corespunzator in caz ca da
								if stare_curenta.isFinal():
									break
									
									
								#S-a realizat o mutare. Schimb jucatorul cu cel opus
								stare_curenta.player = Game.enemy(stare_curenta.player)


	
		#--------------------------------
		else: #jucatorul e JMAX (calculatorul)
			#Mutare calculator

			startTime = int(round(time.time() * 1000))

			if algorithm == "minimax":
				stare_actualizata= minimax(stare_curenta)
			elif algorithm == "alphabeta":
				stare_actualizata = alphabeta(-500, 500, stare_curenta)
			stare_curenta.board = stare_actualizata.bestMove.board

			print(f"Tabla dupa mutarea calculatorului\n{str(stare_curenta)}")

			#preiau timpul in milisecunde de dupa mutare
			endTime = int(round(time.time() * 1000))
			print(f"Calculatorul a 'gandit' timp de {endTime - startTime} milisecunde.")
			
			stare_curenta.board.drawGrid()
			if stare_curenta.isFinal():
				break
				
			#S-a realizat o mutare. Schimb jucatorul cu cel opus
			stare_curenta.player = Game.enemy(stare_curenta.player)





if __name__ == "__main__" :
	main()
	while True :
		for event in pygame.event.get():
			if event.type == pygame.QUIT:
				pygame.quit()
				sys.exit()