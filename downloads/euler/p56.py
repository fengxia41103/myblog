# -*- coding: utf-8 -*-


def main():
    print max([sum(int(x) for x in str(a ** b))
               for a in range(1, 101) for b in range(1, 101)])


if __name__ == '__main__':
    main()
