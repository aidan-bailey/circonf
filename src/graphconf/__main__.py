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

    boundryWidth = 2
    boundryHeight = 2

    ctx = Context(5, 5, ["a", "b", "c", "d"], [("a", "b")])
    ctl = clingo.Control()
    with open("/Users/aidanbailey/Source/School/graphconf/choosegates.lp", "r") as f:
        code = f.read()
    ctl.add("base", [], code)

    graphs = []

    def on_model(model):
        symbols = model.symbols(atoms=True)

        gate_types = {}
        edges = []

        for symbol in symbols:
            if symbol.name == "gate_type":
                try:
                    g1 = symbol.arguments[0].name
                except:
                    g1 = str(symbol.arguments[0].number)
                gate_type = symbol.arguments[1].name
                gate_types[g1] = gate_type
            if symbol.name == "con":
                try:
                    g1 = symbol.arguments[0].name
                except:
                    g1 = str(symbol.arguments[0].number)
                try:
                    g2 = symbol.arguments[1].name
                except:
                    g2 = str(symbol.arguments[1].number)
                edges.append((g1, g2))

        G = nx.DiGraph()

        labels = {}

        for gate, (gate_type) in gate_types.items():

            if gate_type == "or_g":
                gs = "∨"
            elif gate_type == "and_g":
                gs = "∧"
            elif gate_type == "xor_g":
                gs = "⊕"
            elif gate_type == "not_g":
                gs = "¬"
            else:
                gs = gate

            labels[gate] = gs
            G.add_node(gate)

        for (g1, g2) in edges:
            G.add_edge(g1, g2)

        graphs.append(lambda: nx.draw(G, labels=labels, with_labels=True, node_size=300, font_size=15))
        nx.draw(G, labels=labels, with_labels=True, node_size=300, font_size=15)

        plt.show()


    ctl.ground([("base", [])], context=ctx)
    sol = ctl.solve(on_model=on_model)

if __name__ == "__main__":
    main()
