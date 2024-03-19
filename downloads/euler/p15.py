# -*- coding: utf-8 -*-

"""Starting in the top left corner of a 2×2 grid, and only being able
to move to the right and down, there are exactly 6 routes to the
bottom right corner.

How many such routes are there through a 20×20 grid?
"""


def main():
    n = 21  # number of nodes, not legs, per side
    grid = [0] * n * n

    for i in range(1, n):
        grid[i * n] = 1
        grid[i] = 1

    for x in range(n):
        for y in range(n):
            if not grid[x * n + y]:
                grid[x * n + y] = grid[(x - 1) * n + y] + grid[x * n + y - 1]

    print grid, max(grid)

if __name__ == '__main__':
    main()
