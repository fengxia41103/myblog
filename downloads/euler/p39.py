# -*- coding: utf-8 -*-

"""If p is the perimeter of a right angle triangle with integral
length sides, {a,b,c}, there are exactly three solutions for p = 120.

{20,48,52}, {24,45,51}, {30,40,50}

For which value of p ≤ 1000, is the number of solutions maximised?
"""


def main():
    p = 1000

    triangle_test = lambda x, y, z: x + y > z and x + z > y and y + z > x
    right_angle_test = lambda x, y, z: (x * x + y * y) == z * z

    result = [0] * p
    for n in range(120, p + 1):
        count = 0
        for c in range(1, n / 2 + 1):  # c must be < n/2
            for a in range(1, (n - c) / 2 + 1):  # b must be (n-c)/2
                b = n - c - a

                if triangle_test(a, b, c) and right_angle_test(a, b, c):
                    count += 1

        # save result
        result[n - 1] = count
        print n, '->', count

    print result.index(max(result)) + 1

if __name__ == '__main__':
    main()
