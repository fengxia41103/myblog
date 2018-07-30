# -*- coding: utf-8 -*-


def main():
    # 2x, 3x, 4x, 5x, 6x
    multipliers = [2, 3, 4, 5, 6]

    # starting point, at least 6-digit number
    n = 10 ** 5

    # search
    while True:
        # compute 2x...
        tmp = [set(str(n * m)) for m in multipliers]

        # test: having same digits?
        if reduce(set.union, tmp) == tmp[0]:
            print n
            return  # done

        # next one, most significant digit must be 1
        if int(str(n)[0]) > 1:
            n = 10 ** (len(str(n)) + 1)
        else:
            n += 1


if __name__ == '__main__':
    main()
