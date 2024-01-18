class Point:
    x: int
    y: int
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
    def __repr__(self) -> str:
        return f"({self.x}, {self.y})"
    def __eq__(self, __value: object) -> bool:
        return self.x == __value.x and self.y == __value.y
    def __hash__(self) -> int:
        return (987057854941 * self.x + 466049407949 * self.y) % 147511799299

input_file = open("5.txt", "r")
text = input_file.readline()

visited_houses = {Point(0, 0)}
current_house = Point(0, 0)

for direction in text:
    match direction:
        case '<':
            current_house.x -= 1
        case '>':
            current_house.x += 1
        case '^':
            current_house.y -= 1
        case 'v':
            current_house.y += 1
    visited_houses.add(current_house)

print(f"{len(visited_houses)} houses get at least 1 present")
input_file.close()