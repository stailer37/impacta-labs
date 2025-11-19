#! python

import random
import string

# data generators
random_getter = lambda (it) : (lambda : it[random.randrange(len(it))])
ts_gen = random_getter(['2017-08-10 01:23:45', '2017-08-11 01:23:45', '2017-08-12 01:23:45'])
card_id_gen = random_getter([''.join(random.sample(string.lowercase + string.digits, 8)) for i in xrange(1000)])
store_gen = random_getter(['Loja1', 'Loja2', 'Loja3', 'Loja4', 'Loja5', 'Loja6', 'Loja7'])
status_gen = random_getter(['APROVADA', 'NAO AUTORIZADA', 'CANCELADA'])
currency_gen = random_getter(['BRL', 'USD'])
amount_gen = lambda : str(random.randrange(100, 10000))

# generation
def main ():
    TOTAL = 100000
    for i in xrange(TOTAL):
        print ",".join([ts_gen(), card_id_gen(), store_gen(), status_gen(), currency_gen(), amount_gen()])


if __name__ == '__main__':
    main()