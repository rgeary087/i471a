from lib2to3.pgen2 import token
import sys
import json
import re

inputCode = ''
source = {'TEXT': True, 'IFDEF': True,'IFNDEF': True, 'ELIF': True, 'ENDIF': True, 'SYM': False}
source = {'TEXT': True, 'IFDEF': True,'IFNDEF': True, 'ELIF': True, 'ENDIF': True,
'SYM': True}


class Token():
	id = ''
	group = ''

	def __init__(self, id, group):
		self.id = id
		self.group = group

	def __str__(self):
		return f"{self.id} - {self.group}"
	def toJson(self):
		return json.dumps(self, default=lambda o: o.__dict__, indent=2)

class defAST():
	tag = ''
	sym = ''
	xkids = []

	def __init__(self, id, sym, xkids):
		self.tag = id
		self.sym = sym
		self.xkids = xkids


	def __str__(self):
		return f" \n DD : {self.tag} - {self.sym} - \/{[str(i)  for i in self.xkids]}\/"

	def toJson(self):
		return json.dumps(self, default=lambda o: o.__dict__, indent=2)

class elseAST():
	tag = ''
	xkids = []

	def __init__(self, id, xkids):
		self.tag = id
		self.xkids = xkids


	def __str__(self):
		return f" \n DD : {self.tag} - \/{[str(i)  for i in self.xkids]}\/"

	def toJson(self):
		return json.dumps(self, default=lambda o: o.__dict__, indent=2)

class textAST():
	tag = 'TEXT'
	text = ''

	def __init__(self, text):
		self.text = text
	
	def __str__(self):
		return f"\n TT : {self.tag} - {self.text}"
	def toJson(self):
		return json.dumps(self, default=lambda o: o.__dict__, indent=2)



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

def regexFilter(tokens):
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
	return tokens


def parse(tokens):
	def check(kind): return lookahead.id == kind
	def sourceMatch(kind):
		nonlocal lookahead
		if (source[kind] && lookahead.id == kind):
			lookahead = nextToken()
		else:
			print(f'expecting {kind} at {lookahead.group}',
					file=sys.stderr)
			sys.exit(1)
	def ifdefMatch(kind):
		nonlocal lookahead
		if (ifdef[kind] && lookahead.id == kind):
			lookahead = nextToken()
		else:
			print(f'expecting {kind} at {lookahead.group}',
					file=sys.stderr)
			sys.exit(1)
	def nextToken():
		nonlocal index
		if (index >= len(tokens)):
			return Token('EOF', '<EOF>')
		else:
			tok = tokens[index]
			index += 1
			return tok
	def peak(kind):
		if lookahead.id == kind:
			return True
		else:
			return False
	def source():
		if check('TEXT'):
			print('y')
			sourceMatch('TEXT')
			return textAST(lookahead.group)
			pass
		elif check('SYM'):
			print('y')
			print('error')
			pass
		else:
			print('x')
			sourceMatch('')
			ifdef()
		return

	def ifdef():
		ifdefMatch('SOURCE')
		return

	def program():
		asts = []
		while (not check('EOF')):
			if peak('TEXT') or peak("IFDEF"):
				asts.append(source())
		return asts

   
    #begin parse()
	index = 0
	lookahead = nextToken()
	value = program()
	if (not check('EOF')):
		print(f'expecting <EOF>, got {lookahead.lexeme}', file=sys.stderr)
		sys.exit(1)
	return value

def main():
	inputCode = sys.stdin.read()
	tokens = regexInterpreter(inputCode)
	tokens = regexFilter(tokens)
	tokens.append(Token('EOF', '<EOF'))
	tokens = parse(tokens)
	
	for i in tokens:
	# 	print(str(i))
		#print(next(tokens))
		print(i.toJson())
	
if __name__ == '__main__':
	main()

 # def expr():
    #     t = term()
    #     while (check('+') or (check('-'))):
    #         kind = lookahead.kind
    #         match(kind)
    #         t1 = term()
    #         t = Ast(kind, t, t1)
    #     return t

    # def term():
    #     if (check('-')):
    #         match('-')
    #         return Ast('-', term())
    #     else:
    #         f = factor()
    #         if(check('**')):
    #             match('**')
    #             return Ast('**', f, term())
    #         return f

    # def factor():
    #     if (check('INT')):
    #         value = int(lookahead.lexeme)
    #         match('INT')
    #         ast = Ast('INT')
    #         ast['value'] = value
    #         return ast
    #     else:
    #         match('(')
    #         value = expr()
    #         match(')')
    #         return value


# def astBuilder(tokens, tag, num):
# 	ret = []
# 	x = 0
# 	if tag == None:
# 		while x < len(tokens):
# 			if tokens[x].id == 'TEXT':
# 				print('v0')
# 				ret.append(textAST(tokens[x].group))
# 				x+=1
# 			elif tokens[x].id == 'IFNDEF':
# 				print('x0')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFNDEF', x+1)
# 				ret.append(defAST('IFNDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'IFDEF':
# 				print('y0')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFDEF', x+1)
# 				ret.append(defAST('IFDEF', retList))
# 				x += newStart
# 			else:
# 				print('z0')
# 				ret.append(tokens[x])
# 				x+=1
# 	elif tag == 'IFNDEF':
# 		while x < len(tokens) and (tokens[x].id != 'ENDIF' or tokens[x].id != 'ELIF'):
# 			if tokens[x].id == 'TEXT':
# 				print('v1')
# 				ret.append(textAST(tokens[x].group))
# 				x+=1
# 			elif tokens[x].id == 'SYM':
# 				print('w1')
# 				ret.append(tokens[x].group)
# 				x+=1
# 			elif tokens[x].id == 'IFNDEF':
# 				print('x1')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFNDEF', x+1)
# 				ret.append(defAST('IFNDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'IFDEF':
# 				print('y1')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFNDEF', x+1)
# 				ret.append(defAST('IFNDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'ENDIF':
# 				print('y3')
# 				if ( x+1 < len(tokens) and tokens[x+1].id == 'SYM'):
# 					ret.append(defAST('ENDIF', [tokens[x+1].group]))
# 					x+=1
# 					return (ret, num + x)
# 			else:
# 				print('z1')
# 				ret.append(tokens[x])
# 				x+=1
# 	elif tag == 'IFDEF':
# 		while x < len(tokens) and (tokens[x].id != 'ENDIF' or tokens[x].id != 'ELIF'):
# 			if tokens[x].id == 'TEXT':
# 				print('v2')
# 				#print(tokens[x].group)
# 				ret.append(textAST(tokens[x].group))
# 				x+=1
# 			elif tokens[x].id == 'SYM':
# 				print('w2')
# 				#ret.append(tokens[x].group)
# 				x+=1
# 			elif tokens[x].id == 'IFNDEF':
# 				print('x2')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFNDEF', x+1)
# 				ret.append(defAST('IFNDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'IFDEF':
# 				print('y2')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFDEF', x+1)
# 				ret.append(defAST('IFDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'ELIF':
# 				print('y3')
# 				if ( x+1<len(tokens) and tokens[x+1].id == 'SYM'):
# 					ret.append(defAST('ELIF', [tokens[x+1].group]))
# 					x+=1
# 			else:
# 				print('z2')
# 				ret.append(tokens[x])
# 				x+=1
# 	elif tag == 'ELIF':
# 		while x < len(tokens) and (tokens[x].id != 'ENDIF' or tokens[x].id != 'ELIF'):
# 			if tokens[x].id == 'TEXT':
# 				print('v2')
# 				#print(tokens[x].group)
# 				ret.append(textAST(tokens[x].group))
# 				x+=1
# 			elif tokens[x].id == 'SYM':
# 				print('w2')
# 				ret.append(tokens[x].group)
# 				x+=1
# 			elif tokens[x].id == 'IFNDEF':
# 				print('x2')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFNDEF', x+1)
# 				ret.append(defAST('IFNDEF', retList))
# 				x += newStart
# 			elif tokens[x].id == 'IFDEF':
# 				print('y2')
# 				(retList, newStart) = astBuilder(tokens[x+1:], 'IFDEF', x+1)
# 				ret.append(defAST('IFDEF', retList))
# 				x += newStart
# 			else:
# 				print('z2')
# 				ret.append(tokens[x])
# 				x+=1
# 		# if tokens[x] 
# 		# 	return (ret.append(defAST))
# 	else:
# 		ret = tokens



# 	#continue if see text
# 	#return if see endif
# 	return (ret, num + x)