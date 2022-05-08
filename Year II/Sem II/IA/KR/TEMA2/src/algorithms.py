from state import State
from game import Game

def minimax(state:State):
    if state.depth == 0 or state.board.final():
        state.score = state.board.estimateScore(state.depth)
        return state
    state.successors = state.moves()
    moveScores = [minimax(s) for s in state.successors]

    if state.board == Game.JMAX :
        state.bestMove = max(moveScores, key=lambda move: move.score)   # JMAX
    else:
        state.bestMove = min(moveScores, key=lambda move: move.score)   # JMIN
    state.score = state.bestMove.score
    return state


def alphabeta(alpha, beta, state:State):
    if state.depth == 0 or state.board.final() :
        state.score = state.board.estimateScore(state.depth)
        return state

    if alpha > beta:
        return state

    state.successors = state.moves()

    match state.board:
        case Game.JMAX:
            currentScore = float('-inf')

            for s in state.successors:
                newState = alphabeta(alpha, beta, s)
                
                if currentScore < newState.score:
                    state.bestMove = newState
                    currentScore = newState.score

                if alpha < newState.score:
                    alpha = newState.score
                    if alpha >= beta:
                        break
        case Game.JMIN:
            currentScore = float('inf')

            for s in state.successors:
                newState = alphabeta(alpha, beta, s)
                
                if currentScore > newState.score:
                    state.bestMove = newState
                    currentScore = newState.score

                if beta > newState.score:
                    beta = newState.score
                    if alpha >= beta:
                        break
        case _:
            ValueError("ceva nu e bine...")

    state.score = state.bestMove.score
    return state