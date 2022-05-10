import pygame
import numpy as np
import itertools
import sys
import networkx as nx
from pygame import gfxdraw

from line import Line


# Game constants
# BOARD_COLOR = (199, 105, 42)
BOARD_COLOR = (130, 130, 130)
BOARD_SIZE = 800
BOARD_BORDER = 100
STONE_RADIUS = 20
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
TURN_POS = (BOARD_BORDER, 20)
SCORE_POS = (BOARD_BORDER, BOARD_SIZE - BOARD_BORDER + 30)
FONT = ("arial", 30)


def getGridLines(size):
    """
    Creates two lists of (start, end) pairs, defining gridlines
    :args:
        size (int): size of grid
    :return:
        tuple[list[Line]]: start and end points for gridlines
    """
    # vertical start points (constant y)
    vxs = np.linspace(BOARD_BORDER, BOARD_SIZE - BOARD_BORDER, size)
    vys = np.full((size), BOARD_BORDER)

    # vertical end points (constant y)
    vxe = np.linspace(BOARD_BORDER, BOARD_SIZE - BOARD_BORDER, size)
    vye = np.full((size), BOARD_SIZE - BOARD_BORDER)

    # horizontal start points (constant x)
    hxs = np.full((size), BOARD_BORDER)
    hys = np.linspace(BOARD_BORDER, BOARD_SIZE - BOARD_BORDER, size)

    # horizontal end points (constant x)
    hxe = np.full((size), BOARD_SIZE - BOARD_BORDER)
    hye = np.linspace(BOARD_BORDER, BOARD_SIZE - BOARD_BORDER, size)


    vertical = [Line(*l) for l in zip(zip(vxs, vys), zip(vxe, vye))]
    horizontal = [Line(*l) for l in zip(zip(hxs, hys), zip(hxe, hye))]

    return (vertical, horizontal)


def coordsToIndices(position, size):
    """
    Converts (x, y) coordinates to (col, row) indices
    :args
        position (tuple[int, int]): x, y positions
        size (int): size of grid
    :return
        tuple[int, int]: (col, row) indices of lines intersection
    """
    x, y = position
    cellSize = (BOARD_SIZE - 2 * BOARD_BORDER) / (size - 1)
    x_dist = x - BOARD_BORDER
    y_dist = y - BOARD_BORDER
    col = int(round(x_dist / cellSize))
    row = int(round(y_dist / cellSize))
    return col, row


def indicesToCoords(index, size):
    """
    Converts (col, row) indices to (x, y) coordinates
    :args:
        index (tuple[int, int]): col, row indices
        size (int): size of grid
    :return:
        tuple[int, int]: (x, y) coordinates of lines intersection
    """
    col, row = index
    cellSize = (BOARD_SIZE - 2 * BOARD_BORDER) / (size - 1)
    x = int(BOARD_BORDER + col * cellSize)
    y = int(BOARD_BORDER + row * cellSize)
    return x, y


def hasLiberties(board, group):
    """
    Checks if a stone group has liberties on a board.
    :args:
        board (object): game board (size * size matrix)
        group (list[tuple[int, int]]): list of indices defining a stone group
    :return:
        boolean: True if group has liberties, False otherwise
    """
    size = board.shape[0]
    for x, y in group:
        if x > 0 and board[x - 1][y] == ".":
            return True
        if y > 0 and board[x][y - 1] == ".":
            return True
        if x < size - 1 and board[x + 1][y] == ".":
            return True
        if y < size - 1 and board[x][y + 1] == ".":
            return True
    return False


def get_stone_groups(board, color):
    """
    Get stone groups of a given color on a board
    :args:
        board (object): game board (size * size matrix)
        color (str): name of color to get groups for
    :return:
        List[List[Tuple[int, int]]]: list of list of (col, row) pairs, each defining a group
    """
    size = board.shape[0]
    code = "B" if color == "black" else "W"
    xs, ys = np.where(board == code)
    graph = nx.grid_graph(dim=[size, size])
    stones = set(zip(xs, ys))
    all_spaces = set(itertools.product(range(size), range(size)))
    stones_to_remove = all_spaces - stones
    graph.remove_nodes_from(stones_to_remove)
    return nx.connected_components(graph)


def isValidMove(index, board):
    """
    Checks if placing a stone at index on board is valid
    :args:
        index (tuple[int, int]): col, row indices 
        board (object): board grid (size * size matrix)
    :return:
        boolean: True if move is valid, False otherewise
    """
    col, row = index
    size = board.shape[0]
    if col < 0 or col >= size:
        return False
    if row < 0 or row >= size:
        return False
    return board[col][row] == "."


class Game:
    verticalGridlines = None
    horizontalGridLines = None
    font = None

    def __init__(self, size):
        self.size = size
        self.board = np.full((size, size), ".")
        self.isBlacksTurn = True
        self.prisoners = {"black": 0, "white": 0}

    def initPygame(self):
        pygame.init()
        self.__class__.font = pygame.font.SysFont(*FONT)
        screen = pygame.display.set_mode((BOARD_SIZE, BOARD_SIZE))
        self.screen = screen
        self.__class__.verticalGridlines, self.__class__.horizontalGridLines = getGridLines(self.size)
        self.clearScreen()
        self.draw()

    def clearScreen(self):
        self.screen.fill(BOARD_COLOR)
        for line in self.__class__.verticalGridlines:
            pygame.draw.line(self.screen, Line.color, line.start, line.end)
        for line in self.__class__.horizontalGridLines:
            pygame.draw.line(self.screen, Line.color, line.start, line.end)
        pygame.display.update()

    def passTurn(self):
        self.isBlacksTurn = not self.isBlacksTurn
        self.draw()

    def handleClick(self):
        pos = pygame.mouse.get_pos()
        index = coordsToIndices(pos, self.size)
        if not isValidMove(index, self.board):
            return

        # update board array
        col, row = index
        self.board[col, row] = "B" if self.isBlacksTurn else "W"

        # get stone groups for black and white
        selfColor = "black" if self.isBlacksTurn else "white"
        otherColor = "white" if self.isBlacksTurn else "black"

        # handle captures
        capture_happened = False
        for group in list(get_stone_groups(self.board, otherColor)):
            if not hasLiberties(self.board, group):
                capture_happened = True
                for i, j in group:
                    self.board[i, j] = "."
                self.prisoners[selfColor] += len(group)

        # handle special case of invalid stone placement
        # this must be done separately because we need to know if capture resulted
        if not capture_happened:
            group = None
            for group in get_stone_groups(self.board, selfColor):
                if (col, row) in group:
                    break
            if not hasLiberties(self.board, group):
                self.board[col, row] = "."
                return

        # change turns and draw screen
        self.isBlacksTurn = not self.isBlacksTurn
        self.draw()

    def draw(self):
        self.clearScreen()

        for index in zip(*np.where(self.board == "B")):
            x, y = indicesToCoords(index, self.size)
            gfxdraw.aacircle(self.screen, x, y, STONE_RADIUS, BLACK)
            gfxdraw.filled_circle(self.screen, x, y, STONE_RADIUS, BLACK)
            
        for index in zip(*np.where(self.board == "W")):
            x, y = indicesToCoords(index, self.size)
            gfxdraw.aacircle(self.screen, x, y, STONE_RADIUS, WHITE)
            gfxdraw.filled_circle(self.screen, x, y, STONE_RADIUS, WHITE)

        score_msg = (
            f"BLACK's prisoners: {self.prisoners['black']}     " +
            f"     WHITE's prisoners: {self.prisoners['white']}")
        txt = self.__class__.font.render(score_msg, True, BLACK)
        self.screen.blit(txt, SCORE_POS)

        turn_msg = (
            f"{'BLACK' if self.isBlacksTurn else 'WHITE'}'s turn!   " +
            "   Click to place stone, press 'P' to pass.")
        txt = self.__class__.font.render(turn_msg, True, BLACK)
        self.screen.blit(txt, TURN_POS)

        pygame.display.update()


    def update(self):
        events = pygame.event.get()
        for event in events:
            if event.type == pygame.MOUSEBUTTONDOWN:
                self.handleClick()
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_p:
                    self.passTurn()
            elif event.type == pygame.QUIT:
                sys.exit()





if __name__ == "__main__":
    g = Game(size=7)
    g.initPygame()

    while True:
        g.update()
        pygame.time.wait(200)