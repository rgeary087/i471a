import sys
import json
import re

inputCode = ''
class Token():
	id = ''
	group = ''

	def __init__(self, id, group):
		self.id = id
		self.group = group

	def __str__(self):
		return f"{self.id} - {self.group}"



def regexInterpreter(inputLine):
	tokens = []
	symbol = False
	while len(inputLine) > 0: 
		if (m := re.compile(r'\s+').match(inputLine)) :
			pass  # ignore whitespace
		elif (m := re.compile(r'#else[^\n]*').match(inputLine)) :
			tokens.append(Token('ELSE', m.group()))
			symbol = False
		elif (m := re.compile(r'#endif[^\n]*').match(inputLine)) :
			tokens.append(Token('ENDIF', m.group()))
			symbol = False
		elif (m := re.compile(r'#elif[^\n]*').match(inputLine)) :
			tokens.append(Token('ELIF', m.group()))
			symbol = True
		elif (m := re.compile(r'#ifdef[^\n]*').match(inputLine)) :
			tokens.append(Token('IFDEF', m.group()))
			symbol = True
		elif (m := re.compile(r'#ifndef[^\n]*').match(inputLine)) :
			tokens.append(Token('IFNDEF', m.group()))
			symbol = True
		elif (m := re.compile(r'(\s|\w|# )+').match(inputLine)) :
			tokens.append(Token('TEXT', m.group()))
			symbol = False
		else :
			#must be last: match any char
			m = re.compile(r'.').match(inputLine)
			tokens.append(Token(m.group(), m.group()))
		lexeme = m.group() #m.group() provides the matching text
		inputLine = inputLine[len(lexeme):] #remove lexeme prefix of text
	return tokens


def main():
	inputCode = sys.stdin.read()
	tokens = regexInterpreter(inputCode)
	x=0
	while x < len(tokens):
		if tokens[x].id == "IFDEF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "IFNDEF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "ELIF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "ELSE":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
		elif tokens[x].id == "ENDIF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
		x+=1

	for i in tokens:
		print(repr(str(i)))
	#print(next(tokens))
	#json.dumps(tokens)
if __name__ == '__main__':
	main()
