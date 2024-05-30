import clingo

from pprint import pprint

class Context:

    _boundryWidth: int
    _boundryHeight: int
    _vertices: int
    _edges: int

    def __init__(self, boundryWidth: int, boundryHeight: int, vertices: list[str], edges: list[tuple[str, str]]) -> None:
        self._boundryWidth = boundryWidth
        self._boundryHeight = boundryHeight
        self._vertices = vertices
        self._edges = edges

    def boundryWidth(self):
        return clingo.Number(self._boundryWidth)

    def boundryHeight(self):
        return clingo.Number(self._boundryHeight)

    def vertices(self):
        return [clingo.String(v) for v in self._vertices]

    def edges(self):
        return [clingo.Tuple_((clingo.String(v1), clingo.String(v2))) for (v1, v2) in self._edges]


def main():
    ctx = Context(10, 10, ["a", "b", "c", "d"], [("a", "b")])
    ctl = clingo.Control()
    with open("/Users/aidanbailey/Source/School/graphconf/graphconf.lp", "r") as f:
        code = f.read()
    ctl.add("base", [], code)

    def on_model(model):
        graph = [["  " for row in range(10)] for col in range(10)]
        symbols = model.symbols(atoms=True)
        for symbol in symbols:
            if symbol.name == "node":
                (x, y, n) = symbol.arguments
                graph[y.number-1][x.number-1] = '{0: <2}'.format(n.name)
            elif symbol.name == "wirestart":
                (x1, y1, x2, y2, v1, v2) = symbol.arguments
                graph[y2.number-1][x2.number-1] = "--"
            elif symbol.name == "wireend":
                (x1, y1, x2, y2, v1, v2) = symbol.arguments
                graph[y1.number-1][x1.number-1] = "++"
            elif symbol.name == "segment":
                (x1, y1, x2, y2, v1, v2) = symbol.arguments
                if graph[y1.number-1][x1.number-1] == "  ":
                    graph[y1.number-1][x1.number-1] = f"{v1.name}{v2.name}"
                if graph[y2.number-1][x2.number-1] == "  ":
                    graph[y2.number-1][x2.number-1] = f"{v1.name}{v2.name}"
            elif symbol.name == "wireLength":
                print(symbol)


        pprint(graph)


    ctl.ground([("base", [])], context=ctx)
    ctl.solve(on_model=on_model)

if __name__ == "__main__":
    main()
