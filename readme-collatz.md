# collatz_graph.py

Writes a Walrus input file (LibSea `.graph` format) from Collatz trajectories.

## Usage

    python collatz_graph.py                 # starting values 1..100 -> samples/collatz.graph
    python collatz_graph.py -n 500 -o x.graph

Then open the file in Walrus with File > Open.

## What it generates

- For each starting value 1..N, the Collatz series (n/2 if even, 3n+1 if odd) is followed until it first reaches 1.
- All trajectories are merged: one node per distinct integer, one link per distinct step.
- Every integer except 1 has exactly one successor, so the result is a tree rooted at 1. Node 1 carries the `$root` attribute.
- Walrus requires tree links to run from parent to child, away from the root. Links are therefore written
  `successor -> n`, the reverse of the Collatz step. The true direction is kept in the link attribute `$step`
  (for example `"6 -> 3"`).
- Node attribute `$label` holds the integer each node represents.
- All links are marked as spanning-tree links (`$tree_link` is listed as true for every link ID; Walrus ignores the attribute's default value), so there are no non-tree links.
- The `@paths` section is empty.

## Notes

- Not yet tried in Walrus. Whether Walrus displays `$label` or `$step` is unverified.
