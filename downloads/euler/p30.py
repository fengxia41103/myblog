# -*- coding: utf-8 -*-
"""
"""


def main():
    result = 0
    for i in range(2, 199999):
        tmp = sum(int(x) ** 5 for x in str(i))
        if tmp == i:
            result += i
    print result

if __name__ == '__main__':
    main()
