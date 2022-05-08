# Testul de orientare

def orientation(px, py, qx, qy, rx, ry):
    val = (qx - px) * (ry - py) - (qy - py) * (rx - px)

    if val > 0:
        return "LEFT"
    elif val < 0:
        return "RIGHT"
    else:
        return "TOUCH"

n = int(input())
for _ in range(n):
    pts = [int(p) for p in input().strip().split()]
    print(orientation(*pts))