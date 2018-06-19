# Crogue

Crogue is a tiny roguelike written in Crystal, mostly as a learning experience. The player `@` advances through a series of levels, avoiding goblins `X`, finding the key `k` to open the gate `#` to the next level. 

## Installation

Using Crystal, run `crystal run src/crogue.cr` in the root of this repo. Alternatively, run the `crogue-game` binary I've checked into the `bin` folder (e.g. `./bin/crogue-game`). You must run it from the root of this repo, or some other place where the `maps` folder is available.

Since it's Crystal, it probably won't work on Windows. The binary will work on OSX.

## Editing and writing your own levels

Levels are read in from a folder of text files with the extension `.map`. The rule for constructing levels is very simple: use `.` to represent a walkable tile, and the characters `@`, `X`, `k`, `O` (impassable pillars) and `#` to represent everything else. Maps need not be rectangular: as the example levels show, empty spaces are treated as impassable space.
