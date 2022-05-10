class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point (x: {self.x}, y: {self.y})"



f = open("t2.txt", "r")

points = []
n = int(f.readline())

for _ in range(n):
    line = f.readline().strip().split()
    points.append(Point(int(line[0]), int(line[1])))



