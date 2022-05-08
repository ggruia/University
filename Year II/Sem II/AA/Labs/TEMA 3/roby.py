# Roby

class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point ({self.x}, {self.y})"
    
    def __sub__(self, other):
        x = self.x - other.x
        y = self.y - other.y
        return Point(x, y)

    def cross(self, a, b):
        m = b - a
        n = self - a
        return m.x * n.y - m.y * n.x


def orientation(a, b, p):
    val = p.cross(a, b)
    if val > 0:
        return 0
    elif val < 0:
        return 1
    else:
        return 2


n = int(input())
p1 = input().strip().split()
p2 = input().strip().split()
referenceLine = [Point(int(p1[0]), int(p1[1])), Point(int(p2[0]), int(p2[1]))]
turns = [0, 0, 0] # LEFT, RIGHT, TOUCH


for _ in range(n - 2):
    x = input().strip().split()
    p = Point(int(x[0]), int(x[1]))
    a, b = referenceLine
    turns[orientation(a, b, p)] += 1
    referenceLine = [b, p]
p = Point(int(p1[0]), int(p1[1]))
a, b = referenceLine
turns[orientation(a, b, p)] += 1

l, r, c = turns
print(f"{l} {r} {c}")