class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point (x: {self.x}, y: {self.y})"



f = open("t1.txt", "r")

n = int(f.readline())
points = []

for _ in range(n):
    line = f.readline().strip().split()
    points.append(Point(int(line[0]), int(line[1])))



left = min(points, key=lambda p: p.x)
top = max(points, key=lambda p: p.y)


arrLeft = points[:points.index(left)] + points[points.index(left) + 1:]
arrTop = points[:points.index(top)] + points[points.index(top) + 1:]



