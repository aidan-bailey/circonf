import clingo
import networkx as nx
import matplotlib.pyplot as plt

from pprint import pprint

class Context:

    _boundryWidth: int
    _boundryHeight: int
    _vertices: list[str]
    _edges: list[tuple[str, str]]

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

    boundryWidth = 5
    boundryHeight = 5

    ctx = Context(5, 5, ["a", "b", "c", "d"], [("a", "b")])
    ctl = clingo.Control()
    with open("/Users/aidanbailey/Source/School/graphconf/graphp/graphp.lp", "r") as f:
        code = f.read()
    ctl.add("base", [], code)

    graphs = []

    def on_model(model):
        #graph = [["  " for row in range(5)] for col in range(5)]
        nodepositions = {}
        segments = []
        symbols = model.symbols(atoms=True)
        for symbol in symbols:
            if symbol.name == "place":
                (c, n) = symbol.arguments
                (x, y) = c.arguments
                nodepositions[n.name] = (x.number - 1, y.number - 1)
            #elif symbol.name == "wirestart":
            #    (x1, y1, x2, y2, v1, v2) = symbol.arguments
            #    segments.append((x1.number - 1, y1.number - 1, x2.number - 1, y2.number - 1, v1, v2))
           # elif symbol.name == "wireend":
           #     (x1, y1, x2, y2, v1, v2) = symbol.arguments
           #     segments.append((x1.number - 1, y1.number - 1, x2.number - 1, y2.number - 1, v1, v2))
            elif symbol.name == "segment":
                (e, c1, c2) = symbol.arguments
                (v1, v2) = e.arguments
                (x1, y1) = c1.arguments
                (x2, y2) = c2.arguments
                segments.append((x1.number - 1, y1.number - 1, x2.number - 1, y2.number - 1, v1, v2))

        G = nx.Graph()

        pos = {}
        color = []
        edges = []
        labels = {

        }

        for node, (x, y) in nodepositions.items():
            G.add_node(node)
            pos[node] = (x, y)
            labels[node] = node
            color.append((165/255, 114/255, 169/255, 1))

        for (x1, y1, x2, y2, v1, v2) in segments:
            pos[f"{v1}{v2},{x1},{y1},{x2},{y2},start"] = (x1, y1)
            labels[f"{v1}{v2},{x1},{y1},{x2},{y2},start"] = ""
            pos[f"{v1}{v2},{x1},{y1},{x2},{y2},end"] = (x2, y2)
            labels[f"{v1}{v2},{x1},{y1},{x2},{y2},end"] = ""
            color.append((0, 0, 0, 0))
            color.append((0, 0, 0, 0))
            G.add_edge(f"{v1}{v2},{x1},{y1},{x2},{y2},start", f"{v1}{v2},{x1},{y1},{x2},{y2},end")

        G.add_edges_from(edges)

        graphs.append(lambda : nx.draw(G, pos=pos, node_color = color, labels=labels, with_labels=True, node_size=300, font_size=15))

    def on_finish(sol):
        graphs[-1]()
        plt.show()

    ctl.ground([("base", [])], context=ctx)
    ctl.solve(on_model=on_model, on_finish=on_finish)

if __name__ == "__main__":
    main()
