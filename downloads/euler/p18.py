# -*- coding: utf-8 -*-
"""
By starting at the top of the triangle below and moving to adjacent
numbers on the row below, the maximum total from top to bottom is 23.

3
7 4
2 4 6
8 5 9 3

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom of the triangle below:

75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23

NOTE: As there are only 16384 routes, it is possible to solve this
problem by trying every route. However, Problem 67, is the same
challenge with a triangle containing one-hundred rows; it cannot be
solved by brute force, and requires a clever method! ;o)
"""


def main():
    """
    The catch of this problem is you can only select the adjacent
    number of the next row.
    """
    data = '''
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
    '''

    # build matrix
    data = [x.strip().split(' ') for x in data.strip().split('\n')]
    data = [[int(y) for y in x] for x in data]

    col_idx = row_idx = 0
    pick = []

    while row_idx < len(data):
        pick.append(data[row_idx][col_idx])

        max_combo = (0, 0)
        next_col_idx = 0

        # next row, 2 options
        if row_idx < len(data) - 1:
            for i in [0, 1]:
                x = data[row_idx + 1][col_idx + i]

                # next row + 1, another 2 options
                for j in [0, 1]:
                    if row_idx < len(data) - 2:
                        y = data[row_idx + 2][col_idx + i + j]
                    else:
                        y = 0

                    # whoever yields the max sum wins
                    if sum((x, y)) > sum(max_combo):
                        max_combo = (x, y)
                        next_col_idx = col_idx + i

        # keep track of which col we are current on
        col_idx = next_col_idx

        # move on to the next row
        row_idx += 1

    print pick
    print sum([int(x) for x in pick])

if __name__ == '__main__':
    main()
