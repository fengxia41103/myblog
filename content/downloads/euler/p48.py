# -*- coding: utf-8 -*-


def main():
    print str(sum([pow(i, i) for i in range(1, 1001)]))[-10:]

if __name__ == '__main__':
    main()
