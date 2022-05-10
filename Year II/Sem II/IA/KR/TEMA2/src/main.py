import pygame
import sys


BOARD_COLOR = (199, 105, 42)
BOARD_WIDTH = 800
BOARD_BORDER = 75
STONE_RADIUS = 22
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
TURN_POS = (BOARD_BORDER, 20)
SCORE_POS = (BOARD_BORDER, BOARD_WIDTH - BOARD_BORDER + 30)

boardColor = (255, 255, 255)
lineColor = (160, 160, 160)

icon = pygame.image.load("images/logo.png")
pygame.display.set_icon(icon)
pygame.display.set_caption("Gruia Gabriel - GO!")

screen = pygame.display.set_mode(size=(800, 600))



def drawCircle(color, coords, radius=12):
    match color:
        case "WHITE":
            pygame.draw.circle(screen, (255, 255, 255), coords, radius, 2)
        case "BLACK":
            pygame.draw.circle(screen, (0, 0, 0), coords, radius, 0)
        case "GREEN":
            pygame.draw.circle(screen, (170, 230, 170), coords, radius, 0)
        case _:
            pass
    pygame.display.update()


running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False




class Game:
    def __init__(self, size):
        self.size = size
        self.board = 
        self.black_turn = True
        self.prisoners = collections.defaultdict(int)
        self.start_points, self.end_points = make_grid(self.size)

    def __repr__():
        rep = ""
        for

    def init_pygame(self):
        pygame.init()
        screen = pygame.display.set_mode((BOARD_WIDTH, BOARD_WIDTH))
        self.screen = screen
        self.font = pygame.font.SysFont("arial", 30)







def main():
    pygame.init()










if __name__ == "__main__":
    main()
    while True :
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

    # game = Game(size=19)
    # game.init_pygame()
    # game.clear_screen()
    # game.draw()

    # while True:
    #     game.update()
    #     pygame.time.wait(100)