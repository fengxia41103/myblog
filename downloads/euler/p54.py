# -*- coding: utf-8 -*-

import re


class MyHand:

    def __init__(self, hand_in_string):
        # top cards
        self.royal = 'TJQKA'

        # a full deck of cards regardless of suit
        self.deck = (map(str, range(10)) + list(self.royal))[2:]

        # given hand
        self.hand_in_string = re.sub('\s', '', hand_in_string)
        self.cards = re.findall('..?', self.hand_in_string)
        self.suits = re.findall('.(.?)', self.hand_in_string)
        self.vals = sorted(re.findall('(.?).', self.hand_in_string))
        self.vals_int = sorted(map(self.map_val_str_to_int, self.vals))[::-1]

        # attributes
        self.is_same_suit = len(set(self.suits)) == 1
        self.is_royal = set(self.royal) == set(self.vals)
        self.is_consecutive = len(set(self.vals)) == len(
            self.vals) and self.vals_int[0] - self.vals_int[-1] == 4
        self.vals_count = sorted(self.vals.count(x) for x in set(self.vals))
        self.rank, self.cmp_val = self.clean_data()

    def map_val_str_to_int(self, val_in_str):
        """Map card values.

        T(en) - 10
        J(ack) - 11
        Q(ueen) - 12
        K(ing) - 13
        A(ce) - 14
        """
        return self.deck.index(val_in_str) + 2

    def is_royal_flush(self):
        """Royal flush is TJQKA in same suit.
        """
        return self.is_royal and self.is_same_suit

    def is_straight_flush(self):
        """All cards are consecutive values of same suit.
        """
        return self.is_consecutive and self.is_same_suit

    def is_four_of_a_kind(self):
        """Four cards of the same value.
        """
        return self.vals_count == [1, 4]

    def is_full_house(self):
        """Three of a kind and a pair.
        """
        return self.vals_count == [2, 3]

    def is_flush(self):
        """All cards of the same suit.
        """
        return self.is_same_suit

    def is_straight(self):
        """All cards are consecutive values.
        """
        return self.is_consecutive

    def is_three_of_a_kind(self):
        """Three cards of the same value.
        """
        return self.vals_count == [1, 1, 3]

    def is_two_pairs(self):
        """Two different pairs.
        """
        return self.vals_count == [1, 2, 2]

    def is_one_pair(self):
        """Two cards of the same value.
        """
        return self.vals_count == [1, 1, 1, 2]

    def clean_data(self):
        rank = 0
        cmp_val = self.vals_int
        if self.is_royal_flush():
            rank = 9
        elif self.is_straight_flush():
            rank = 8
        elif self.is_four_of_a_kind():
            rank = 7
            # [7,4,4,4,4] -> 44447
            # [4,4,4,4,7] -> 44447
            four = None
            single = None
            for f in set(self.vals_int):
                if self.vals_int.count(f) == 1:
                    single = f
                else:
                    four = f
            cmp_val = [four] * 4 + [single]

        elif self.is_full_house():
            rank = 6
            # [9,9,3,3,3] -> 33399
            three = None
            pair = None
            for f in self.vals_int:
                if self.vals_int.count(f) == 2:
                    pair = f
                else:
                    three = f
            cmp_val = [three] * 3 + [pair] * 2

        elif self.is_flush():
            rank = 5
        elif self.is_straight():
            rank = 4
        elif self.is_three_of_a_kind():
            rank = 3
            # [9,6,3,3,3] -> 33396
            # [3,3,3,6,9] -> 33396
            three = None
            singles = []
            for f in self.vals_int:
                if self.vals_int.count(f) == 3:
                    three = f
                else:
                    singles.append(f)
            cmp_val = [three] * 3 + sorted(singles)[::-1]

        elif self.is_two_pairs():
            rank = 2
            # [6,6,9,9,10] -> [9,9,6,6,10]
            # [10,6,6,9,9] -> [9,9,6,6,10]
            pairs = []
            single = None
            for f in self.vals_int:
                if self.vals_int.count(f) == 1:
                    single = f
                else:
                    pairs.append(f)
            cmp_val = sorted(pairs)[::-1] + [single]

        elif self.is_one_pair():
            rank = 1

            # [6,6,8,9,7] -> [6,6,9,8,7]
            # [5,6,6,8,9] -> [6,6,9,8,5]
            pair = None
            singles = []
            for f in self.vals_int:
                if self.vals_int.count(f) == 1:
                    singles.append(f)
                else:
                    pair = f
            cmp_val = [pair] * 2 + sorted(singles)[::-1]
        return rank, cmp_val

    def __cmp__(self, other):
        if self.rank > other.rank:
            return 1
        elif self.rank < other.rank:
            return -1
        elif set(self.cmp_val) == set(other.cmp_val):
            return 0  # tie
        else:  # equal rank
            for i in range(len(self.cmp_val)):
                if self.cmp_val[i] < other.cmp_val[i]:
                    return -1
                elif self.cmp_val[i] > other.cmp_val[i]:
                    return 1


def method_1():
    count = 0
    with open('p054_poker.txt', 'r') as f:
        for hands in f:
            hand1 = MyHand(hands[:len(hands) / 2])
            hand2 = MyHand(hands[len(hands) / 2 - 1:])

            if hand1 > hand2:
                print 'player 1 win'
                count += 1

    print count


def rank_hand(hand):
    # utility functions
    deck = map(str, range(2, 10)) + list('TJQKA')
    card_val = lambda x: deck.index(x) + 2
    vals = lambda x: re.findall('(.?).', x)
    suits = lambda x: re.findall('.(.?)', x)
    is_straight = lambda x: x[0] - x[-1] == 4

    # parser
    s = suits(hand)
    v = sorted(map(card_val, vals(hand)))[::-1]

    # variables to track rank and pattern
    rank = 0
    cmp_val = v
    count = dict(zip(range(1, 5), [[] for i in range(4)]))
    for c in v:
        count[v.count(c)] += [c]

    # convert hand to rank and a comparable data form
    if len(set(s)) == 1:  # same suit
        if sum(count[1]) == 60:  # royal flush
            rank = 9
        elif len(count[1]) == 5:  # flush
            rank = 5
            if is_straight(count[1]):  # straight flush
                rank = 8

    else:  # different suit
        if count[4]:  # four of a kind
            rank = 7
            cmp_val = count[4] + count[1]
        elif count[3]:  # 3s
            if count[2]:  # full house
                rank = 6
                cmp_val = count[3] + count[2]
            else:  # three of a kind
                rank = 3
                cmp_val = count[3] + count[1]
        elif count[2]:  # 2s
            if len(count[2]) == 4:  # two pairs
                rank = 2
            else:
                rank = 1
            cmp_val = count[2] + count[1]
        elif is_straight(count[1]):  # straight
            rank = 4
    return rank, cmp_val


def method_2():
    count = 0
    with open('p054_poker.txt', 'r') as f:
        for hands in f:
            hands = re.sub('\s', '', hands)
            rank1, hand1 = rank_hand(hands[:10])
            rank2, hand2 = rank_hand(hands[10:])

            # comparison
            if rank1 > rank2:
                count += 1
            elif rank1 == rank2 and hand1 > hand2:
                count += 1

    print count


def main():
    method_2()

if __name__ == '__main__':
    main()
