from game import Game


class State:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
    """

    def __init__(self, board, plrSymbol, depth, score=None, parent=None):
        self.board = board
        self.player = plrSymbol
        self.depth = depth
        self.score = score
        self.successors = []
        self.bestMove = None

    def __repr__(self):
        rep = "State:\n"
        rep += f"{self.board}\n"
        rep += f"(turn: {self.player})\n"

    def moves(self):
        moves = self.board.moves(self.player)
        successors = [State(move, Game.enemy(self.player), self.depth - 1, parent=self) for move in moves]
        return successors

    def isFinal(self):
        final = self.board.final()
        if final:
            if final == "remiza":
                print("Remiza!")
            else:
                print(f"A castigat {final}!")
            return True
        return False