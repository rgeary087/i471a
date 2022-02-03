#!/usr/bin/env python3

import re
import sys
from collections import namedtuple

#The next_match() function uses the `:=` walrus operator recently
#introduced in Python 3.8.  In fact, this kind of use is precisely the
#rationale provided in the PEP.
#<https://www.python.org/dev/peps/pep-0572/#the-importance-of-real-code>


#returns pair containing regex match-object and token kind.  If token
#should be ignored, kind should be returned as None.
#note that m.group() gives lexeme after a successful match
def next_match(text):
    if (m := re.compile(r'(s+|/{2}.+)').match(text)) :
        return (m, None)  #None kind means ignore
    if (m := re.compile(r'[a-zA-Z_][0-9a-zA-Z]+').match(text)) :
        return (m, 'ID')   
    if (m := re.compile(r'\d+').match(text)) :
        return (m, 'INT')

    #must be last: match any char
    if (m := re.compile(r'.').match(text)) :
        return (m, m.group()) #m.group() returns matching text: the single char


def scan(text):
    tokens = []
    while (len(text) > 0):

        if (m := re.compile(r'(\s+|/{2}.+)').match(text)) :
            pass  # ignore whitespace
        elif (m := re.compile(r'[a-zA-Z_][0-9a-zA-Z]+').match(text)) :
            tokens.append(Token('ID', m.group()))
        elif (m := re.compile(r'\d+').match(text)) :
            tokens.append(Token('INT', m.group()))
        else :
            #must be last: match any char
            m = re.compile(r'.').match(text)
            tokens.append(Token(m.group(), m.group()))

        lexeme = m.group() #m.group() provides the matching text
        text = text[len(lexeme):] #remove lexeme prefix of text
    return tokens

def main():
    if (len(sys.argv) != 2): usage();
    contents = readFile(sys.argv[1]);
    tokens = scan(contents)
    for t in tokens: print(t)

def readFile(path):
    with open(path, 'r') as file:
        content = file.read()
    return content

Token = namedtuple('Token', ['kind', 'lexeme'])

def usage():
    print(f'usage: {sys.argv[0]} DATA_FILE')
    sys.exit(1)

if __name__ == "__main__":
    main()
