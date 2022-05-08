import time
import pygame
import sys
from state import State
from game import Game
from button import Button, ButtonGroup
from algorithms import minimax, alphabeta


MAX_DEPTH = 4



def menu(screen):
	algChoice = ButtonGroup(
		top=20,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="minimax", value="minimax"), 
			Button(display=screen, width=70, height=30, text="alphabeta", value="alphabeta")],
		selection=0)

	plrChoice = ButtonGroup(
		top=80,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="NEGRU", value="x"), 
			Button(display=screen, width=70, height=30, text="ALB", value="0")],
		selection=0)

	diffChoice = ButtonGroup(
		top=140,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="incepator", value="incepator"), 
			Button(display=screen, width=70, height=30, text="mediu", value="mediu"),
			Button(display=screen, width=70, height=30, text="avansat", value="avansat")],
		selection=0)
	
	boardChoice = ButtonGroup(
		top=200,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="7 x 7", value="7"), 
			Button(display=screen, width=70, height=30, text="9 x 9", value="9"),
			Button(display=screen, width=70, height=30, text="10 x 10", value="10")],
		selection=0)

	ok = Button(display=screen, top=260, left=30, width=70, height=30, text="ok", bgColor=(155,0,55))

	algChoice.drawButtons()
	plrChoice.drawButtons()
	diffChoice.drawButtons()
	boardChoice.drawButtons()
	ok.draw()

	while True:
		for event in pygame.event.get(): 
			if event.type== pygame.QUIT:
				pygame.quit()
				sys.exit()
			elif event.type == pygame.MOUSEBUTTONDOWN: 
				pos = pygame.mouse.get_pos()
				if not algChoice.selectBtnByCoords(pos):
					if not plrChoice.selectBtnByCoords(pos):
						if not diffChoice.selectBtnByCoords(pos):
							if not boardChoice.selectBtnByCoords(pos):
								if ok.selectByCoords(pos):
									screen.fill((0, 0, 0))
									return (algChoice.getValue(), plrChoice.getValue(), diffChoice.getValue(), boardChoice.getValue())
		pygame.display.update()



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
	
	print(Game.JMIN, algorithm)

	Game.JMAX= '0' if Game.JMIN == 'x' else 'x'


	print("Tabla initiala")
	print(str(board))

	#creare stare initiala
	stare_curenta = State(board, 'x', MAX_DEPTH)

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