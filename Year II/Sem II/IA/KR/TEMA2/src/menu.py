import sys
import pygame
from button import Button, ButtonGroup


def menu(screen):
	algChoice = ButtonGroup(
		top=20,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="minimax", value="mM"), 
			Button(display=screen, width=70, height=30, text="alphabeta", value="ab")],
		selection=0)

	plrChoice = ButtonGroup(
		top=80,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="NEGRU", value="B"), 
			Button(display=screen, width=70, height=30, text="ALB", value="W")],
		selection=0)

	diffChoice = ButtonGroup(
		top=140,
		left=30,
		buttons=[
			Button(display=screen, width=70, height=30, text="incepator", value="bgn"), 
			Button(display=screen, width=70, height=30, text="mediu", value="int"),
			Button(display=screen, width=70, height=30, text="avansat", value="adv")],
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