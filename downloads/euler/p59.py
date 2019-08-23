# -*- coding: utf-8 -*-


def method_1():
    # construct 3 sets
    with open('p059_cipher.txt', 'r') as f:
        msg = f.read()
    msg = map(int, msg.split(','))
    s1 = msg[0::3]
    s2 = msg[1::3]
    s3 = msg[2::3]

    pp = []
    for i in range(32, 127):
        tmp = [x ^ i for x in s1 if x ^ i not in range(32, 127)]
        if not tmp:
            pp.append(i)

    for p in pp:
        tmp = map(lambda x: chr(x ^ p), s1)
        print chr(p), p, tmp
        raw_input()

    for a in ['g', 'x']:
        for b in ['a', 'b', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'z']:
            for c in ['d', 'e', 'f', 'g', 'j', '{']:
                t1 = map(lambda x: chr(x ^ ord(a)), s1)
                t2 = map(lambda x: chr(x ^ ord(b)), s2)
                t3 = map(lambda x: chr(x ^ ord(c)), s3)
                msg = ''.join([''.join(x) for x in zip(t1, t2, t3)])
                print a, b, c
                print msg + '.'
                print sum(ord(x) for x in (msg + '.'))
                raw_input()


def method_2():
    # construct 3 sets
    with open('p059_cipher.txt', 'r') as f:
        msg = f.read()
    msg = map(int, msg.split(','))

    # find possibles
    possibles = []
    for i in range(3):
        s = msg[i::3]

        pp = []
        for i in range(32, 127):
            tmp = [x ^ i for x in s if x ^ i not in range(32, 127)]
            if not tmp:
                pp.append(i)
        possibles.append(pp)

    # iterate
    for a in possibles[0]:
        for b in possibles[1]:
            for c in possibles[2]:
                pwd = [a, b, c]
                decoded = ''.join(
                    chr(x ^ pwd[idx % 3]) for idx, x in enumerate(msg))

                # test: wow!
                if ' the ' in decoded:
                    print ''.join(chr(x) for x in pwd)
                    print decoded


def main():
    method_2()

if __name__ == '__main__':
    main()
