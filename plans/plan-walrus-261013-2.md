# Plan: Collatz graph generator for Walrus

Date: 2026-10-13

## Prompt that precipitated this plan

> create a directed graph by generating the first 100 paths based on the collatz conjecture series

## Findings that shape the design

- Walrus input is a LibSea `.graph` file. It requires a root (`$root` bool attribute) and a set of
  spanning-tree links (`$tree_link` bool attribute). Every other link is a non-tree link.
- Walrus reads tree links as parent (source) to child (destination) (`H3GraphLoader.java:227`).
- In the Collatz series, each number n has exactly one successor (n/2 if even, 3n+1 if odd).
  Following the real direction n -> successor, all trajectories merge and flow toward 1.
  That is an in-tree rooted at 1, with arrows pointing toward the root.
- Walrus tree links must point away from the root. Therefore the real Collatz direction
  cannot be used as the tree. The tree links would have to be written as successor -> n
  (root 1 down to the starting numbers), which reverses the Collatz direction.
- LibSea also has a `@paths` section (a path is a sequence of links). Walrus's use of paths is
  unverified; "first 100 paths" may map onto it.
- Trajectories stop at 1 (otherwise they enter the 1 -> 4 -> 2 -> 1 loop).
- Starting values 1 to 100 reach a peak of 9232 (from 27). The merged graph has a few hundred nodes.

## Existing Solutions

1. `contrib/asGraphGenerator.py` (in this repo): writes LibSea files for AS relationships. It is
   Python 2 style (integer division with `/`), specific to AS data, and recursive. Reusable idea:
   its attribute-writing helpers. Not reusable directly; I would not modify a tracked file.
2. LibSea Java library (`lib\libsea.jar`, source in `libsea/`): can write `.graph` files from Java
   (`GraphFileWriter`-style classes). Heavier than needed for a few hundred nodes, and requires
   compiling Java against it.
3. networkx (Python): builds the graph easily but has no LibSea writer; I would still write the
   format by hand. Adds a dependency for no gain.
4. Command-line tools: none exist for Collatz-to-LibSea.
5. Recommendation: a small standalone Python 3 script (`contrib` is tracked, so put it at
   `E:\testing\walrus\collatz_graph.py`) that writes the LibSea text directly. Python 3.13 is installed.

## Assumptions (please confirm or correct)

- "first 100 paths" means the trajectories starting at 1, 2, ..., 100.
- Each trajectory runs until it first reaches 1.
- Nodes are the integers appearing in any trajectory, merged (one node per distinct integer).
  Node IDs are assigned in order of first appearance; the number itself is stored as a string
  attribute `$label` (if Walrus displays labels; unverified).
- Duplicate edges are written once.

## Open decisions

1. Link direction (see "Findings"):
   - A: tree links written root to leaves (1 -> 2 -> 4 -> ...), reversing the Collatz step.
     Valid Walrus input; display is the standard tree view.
   - B: links written in true Collatz direction (n -> next), `$root` = 1, and `$tree_link` marked
     on the same edges. Faithful to the series, but Walrus will treat the structure oddly
     (tree traversal follows source to destination from the root, and 1 has no outgoing
     edges), so the picture will probably be wrong or empty. I expect this to fail.
   - C: A, plus the true-direction information kept as a link attribute (`$step` = "n -> next").
2. Whether to also emit the 100 trajectories in the `@paths` section (does not affect the display
   if Walrus ignores paths).

## Proposed steps

1. Write `collatz_graph.py`: generates trajectories for 1..N (N default 100), merges nodes,
   writes `samples/collatz.graph` in the same layout as `samples/simple.graph`
   (metadata, links, optional paths, `$root`, `$tree_link`, `$label` attributes).
2. Write `readme-collatz.md` explaining the script and how it maps onto the format (per your rule).
3. Per your testing rule, I do not run it; you run it and open the result in Walrus and report problems.
4. New files are untracked; no commits.
