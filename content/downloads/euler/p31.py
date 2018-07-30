# -*- coding: utf-8 -*-

#!/usr/bin/env python


def count(row, col, coin, matrix):
    target = row + 1

    if col == 0:
        pass

    # if coin > target
    elif coin > target:
        matrix[row][col] = matrix[row][col - 1]

    # if coin <= target, lookup
    else:
        matrix[row][col] = matrix[row - coin][col] + matrix[row][col - 1]

    return matrix


def main():
    # the 8 coins correspond to 8 columns
    coins = [1, 2, 5, 10, 20, 50, 100, 200]

    TARGET = 200

    # initialize matrix with 1s
    matrix = [[1] * len(coins) for x in range(1, TARGET + 1)]

    # iterate from 1 up to TARGET
    for t in range(0, TARGET):
        # iterate all coins
        for col, coin in enumerate(coins):
            matrix = count(t, col, coin, matrix)
        print t + 1, matrix[t]

if __name__ == '__main__':
    main()
