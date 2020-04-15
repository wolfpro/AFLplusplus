#!/bin/python3
import os

path_AFL = '/home/kali/diplom/AFLplusplus-master/'

path = os.path.abspath(os.curdir)

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

def go(cur):
    # print('go ' + cur)

    for dr in os.listdir(cur):
        abs_path = os.path.join(cur, dr)
        # print('  go abs_path ' + abs_path)

        if os.path.isdir(abs_path):
            # print('dir')
            go(abs_path)
        elif 'Makefile'  == dr:
            curFile = abs_path
            print('Find file {}['.format(YELLOW) +curFile+']{}'.format(NC))
            # string out
            outStrs = ''
            with open(curFile, 'r') as f:            	
                for i in f:
                    if ' gcc' in i:
                        print('{}[old]{}{}'.format(YELLOW, NC, RED), i, end=NC)
                        s = i
                        s = s.replace(' gcc', ' '+ path_AFL +'afl-gcc')
                        s = s.replace(' g++', ' '+ path_AFL +'afl-g++')
                        i = s 
                        print('{}[new]{}{}'.format(YELLOW, NC, GREEN), i, end=NC	)
                    if'CFLAGS =' in i or 'CPPFLAGS =' in i:
                        print('{}[old]{}{}'.format(YELLOW, NC, RED), i, end=NC)                     
                        i = i[:-1] + ' --coverage\n' 
                        print('{}[new]{}{}'.format(YELLOW, NC, GREEN), i, end=NC	)

                    outStrs += i

            with open(curFile, 'w') as f:
            	f.write(outStrs)            	 

go(path)