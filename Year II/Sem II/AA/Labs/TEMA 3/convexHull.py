# Acoperirea convexa a unui poligon stelat

from queue import LifoQueue
from math import atan2


class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point ({self.x}, {self.y})"

    def __lt__(self, other):
        if self.y < other.y:
            return True
        elif self.y == other.y and self.x < other.x:
            return True
        return False

    def __sub__(self, other):
        x = self.x - other.x
        y = self.y - other.y
        return Point(x, y)



class ConvexHull:
    def __init__(self, points):
        self.points = points
        self.origin = sorted(self.points)[0]
        self.hull = self.convexHull()

    def angleFromCenter(self, point):
        translation = point - self.origin
        return atan2(translation.y, translation.x)

    def orientation(self, a, b, p):
        i = b - a
        j = p - a
        val = i.x * j.y - i.y * j.x
        if val > 0:
            return 1
        else:
            return 0

    def convexHull(self):
        hull = LifoQueue()
        hull.put(self.origin)

        sortedPoints = sorted(self.points, key=lambda point: (self.angleFromCenter(point), -point.y, -point.x))
        sortedPoints.remove(self.origin)

        for p in sortedPoints:
            while hull.qsize() > 1 and not self.orientation(hull.queue[-2], hull.queue[-1], p):
                hull.get()
            hull.put(p)
        return hull.queue





n = int(input())
points = [Point(int(p[0]), int(p[1])) for p in (input().strip().split() for _ in range(n))]
hull = ConvexHull(points)

print(len(hull.hull))
for p in hull.hull:
    print(p.x, p.y)