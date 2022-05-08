# Deciding if a point is inside a convex polygon in O(logn) time:

# Take any vertex of the polygon and use it as an "anchor" in a binary search.
# First attach the vertex to one roughly n/2 vertices away. Decide if your query point is to the left or right of this segment.
# This eliminates half of the polygon. You are still left with a convex polygon.
# Repeat, by attaching the anchor to a vertex at distance n/4, etc.
# In the end, you are left with a cone, formed by the anchor and two successive vertices, u and v.
# Now you can just check in O(1) time if the query point is inside the triangle (anchor, u, v) i.e. inside the polygon.


class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point ({self.x}, {self.y})"

    def __lt__(self, other):
        if self.x < other.x:
            return True
        elif self.x == other.x and self.y > other.y:
            return True
        return False

    def __sub__(self, other):
        x = self.x - other.x
        y = self.y - other.y
        return Point(x, y)

    def cross(self, a, b):
        u = a - self
        v = b - self
        return u.x * v.y - u.y * v.x



class ConvexPolygon:
    def __init__(self, points):
        self.origin = sorted(points)[0]
        self.points = points

    def checkBesidePoints(self, a, b):
        return abs(self.points.index(a) - self.points.index(b)) == 1

    def pointPosition(self, point):
        anchors = self.points[self.points.index(self.origin) + 1:] + self.points[:self.points.index(self.origin)]
        l = 0
        r = len(anchors) - 1
        while r - l > 1:
            mid = (l + r) // 2
            midPoint = anchors[mid]
            if point.cross(self.origin, midPoint) < 0:
                r = mid
            else:
                l = mid
        mid = l
        return self.inTriangle(point, self.origin, anchors[mid], anchors[mid + 1])

    def inTriangle(self, p, a, b, c):
        s1 = abs(a.cross(b, c))
        pab, pbc, pca = abs(p.cross(a, b)), abs(p.cross(b, c)), abs(p.cross(c, a))
        s2 = pab + pbc + pca

        if s1 == s2:
            if pab == 0 and self.checkBesidePoints(a, b):
                return "BOUNDARY"
            elif pbc == 0 and self.checkBesidePoints(b, c):
                return "BOUNDARY"
            elif pca == 0 and self.checkBesidePoints(c, a):
                return "BOUNDARY"
            else:
                return "INSIDE"
        return "OUTSIDE"



n = int(input())
polygon = ConvexPolygon([Point(*map(int, input().strip().split())) for _ in range(n)])
m = int(input())

for _ in range(m):
    point = Point(*map(int, input().strip().split()))
    print(polygon.pointPosition(point))