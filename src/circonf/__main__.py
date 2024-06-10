import os

import clingo
import matplotlib.pyplot as plt
import networkx as nx


class Context:
    def __init__(
        self,
    ) -> None:
        pass


def main():
    ctx = Context()
    ctl = clingo.Control()
    with open(os.path.join(os.curdir, "logic/circonf.lp"), "r") as f:
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

        for g1, g2 in edges:
            G.add_edge(g1, g2)

        graphs.append((G, labels))


    ctl.ground([("base", [])], context=ctx)
    sol = ctl.solve(on_model=on_model)
    (graph, labels) = graphs[-1]
    nx.draw(graph, labels=labels, with_labels=True, node_size=300, font_size=15)
    plt.show()


if __name__ == "__main__":
    main()
