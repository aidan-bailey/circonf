# Circonf

Circonf is a ASP-based logical circuit designer. You specify the states and circonf designs a logical circuit using the minimum number of gates (not, or, and, xor).

Circonf is currently set up to produce an adder where x1, x2, and x3 are in the input bits and y1, y2 is the 2-bit output.

## Usage

Construct and activate a virtual environment

`python3 -m venv venv`

`source ./venv/bin/activate`

Install the package

`pip3 install .`

Run the module from the *logic* directory

`cd logic`
`python3 -m circonf`

