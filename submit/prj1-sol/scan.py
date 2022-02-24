import sys
import json
import re

from simplejson import JSONEncoder

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
	def toJSON(self):
		
		return json.dumps([self.id, self.group], separators=(',', ':'))
class TokenEncoder(JSONEncoder):
	def default(self, o):
		return o.__dict__

class defAST():
	tag = ''
	sym = ''
	xkids = []

	def __init__(self, id):
		self.tag = id

	def __str__(self):
		return f" \n DD : {self.tag} - {self.sym} - \/{[str(i)  for i in self.xkids]}\/"

	def toJSON(self):
		return json.dumps(self, default=lambda o: o.__dict__,separators=(',', ':'))

class textAST():
	tag = 'TEXT'
	text = ''

	def __init__(self, text):
		self.tag = 'TEXT'
		self.text = text
		
	
	def __str__(self):
		return f"\n TT : {self.tag} - {self.text}"
	def toJSON(self):
		return json.dumps(self, default=lambda o: o.__dict__,separators=(',', ':'))



def regexInterpreter(inputLine):
	tokens = []
	symbol = False
	while len(inputLine) > 0: 
		# if (m := re.compile(r'\s+').match(inputLine)) :
		# 	pass  # ignore whitespace
		#print(repr(inputLine))
		if (m := re.compile(r'\s*#else[^\n]*').match(inputLine)) :
			tokens.append(Token('ELSE', m.group()))
			symbol = False
		elif (m := re.compile(r'\s*#endif[^\n]*').match(inputLine)) :
			tokens.append(Token('ENDIF', m.group()))
			symbol = False
		elif (m := re.compile(r'\s*#elif[^\n]*').match(inputLine)) :
			tokens.append(Token('ELIF', m.group()))
			symbol = True
		elif (m := re.compile(r'\s*#ifdef[^\n]*').match(inputLine)) :
			tokens.append(Token('IFDEF', m.group()))
			symbol = True
		elif (m := re.compile(r'\s*#ifndef[^\n]*').match(inputLine)) :
			tokens.append(Token('IFNDEF', m.group()))
			symbol = True
		elif (m := re.compile(r'.*\n').match(inputLine)) :
			#print(m.group())
			tokens.append(Token('TEXT', m.group()))
			symbol = False
		else :
			#must be last: match any char
			#print(inputLine)
			m = re.compile(r'.').match(inputLine)
			tokens.append(Token(m.group(), m.group()))
		lexeme = m.group() #m.group() provides the matching text
		inputLine = inputLine[len(lexeme):] #remove lexeme prefix of text
	return tokens

def regexFilter(tokens):
	x=0
	while x < len(tokens):
		#print(tokens[x].group)
		#print(tokens[x].id)
		if tokens[x].id == "IFDEF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if len(listTok) > 1 and bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "IFNDEF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if len(listTok) > 1 and bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "ELIF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
			if len(listTok) > 1 and bool(re.match(r"[a-zA-Z_][0-9a-zA-Z_]*", listTok[1])):
				tokens.insert(x+1, Token('SYM',listTok[1]))
				x+=1
		elif tokens[x].id == "ELSE":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
		elif tokens[x].id == "ENDIF":
			listTok = tokens[x].group.split()
			tokens[x].group = listTok[0]
		elif tokens[x].id == "TEXT":
			#print(tokens[x].group)
			bolle = False
			if(x < len(tokens)-1 and (len(tokens[x+1].id) <=1 or tokens[x+1].id == "TEXT")):
				tokens[x].group += (tokens[x+1].group)
				del tokens[x+1]
				bolle = True
			if(bolle):
				bolle = False
				x-=1
		elif tokens[x].id == "SYM":
			pass
		else:
			tokens[x].id = "TEXT"
			x-=1
		x+=1
	i = 0
	while i < len(tokens):
		tokens[i].group = tokens[i].group.rstrip(" ")
		tokens[i].group = tokens[i].group.lstrip("\n")
		if(len(str(tokens[i].group.strip())) == 0):
			#print("aa")
			del tokens[i]
			i-=1
			continue
		i+=1
	return tokens



def parse(tokens):
	def check(kind): return lookahead.id == kind
	def match(kind):
		nonlocal lookahead
		if (lookahead.id == kind):
			lookahead = nextToken()
		else:
			print(f'expecting {kind} at {lookahead.id}',
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
	def source():
		result = []
		while (not check('EOF')):
			if check('TEXT'):
				result.append(textAST(lookahead.group))
				match('TEXT')
				print('TEXT')
			elif check('IFDEF') or check('IFNDEF') or check('ELIF') or check('ELSE') or check('ENDIF'):
				jString = False
				x = ifdef()
			
			else:
				break
			#for i in result:
				#print(repr(str(i)))
		if(len(result) == 1):
			return result[0]		
		return result

	def ifdef():
		print('if')
		xkids = []
		t = defAST('')
		e = None
		if check('IFDEF'):
			print('IF')
			match('IFDEF')
			if(check('SYM')):
				t.sym = lookahead.group
				match('SYM')
				
				print('SYM')
			t.tag = 'IFDEF'
			x = source()
			xkids.append(x)
		elif check('IFNDEF'):
			print('IFN')
			match('IFNDEF')
			if(check('SYM')):
				t.sym = lookahead.group
				match('SYM')
				print('SYM')
			t.tag = 'IFDEF'
			x = source()
			xkids.append(x)
		while(check('ELIF')):
			print('ELIF')
			match('ELIF')
			e = defAST('ELIF')
			if(check('SYM')):
				e.sym = lookahead.group
				match('SYM')
				print('SYM')
			x = source()
			e.xkids = x
			xkids.append(e)
		if check('ELSE'):
			print('ELSE')
			match('ELSE')
			e = defAST('ELSE')
			exkids = []
			if(check('SYM')):
				e.sym = lookahead.group
				match('SYM')
				print('SYM')
			x = source()
			exkids.append(x)
			e.xkids = exkids
			xkids.append(e)
		if check('ENDIF'):
			print('ENDIF')
			match('ENDIF')
		t.xkids = xkids
		
		return t

   
    #begin parse()
	index = 0
	lookahead = nextToken()
	value = source()
	if (not check('EOF')):
		print(f'expecting <EOF>, got {lookahead.id}', file=sys.stderr)
		sys.exit(1)
	return value


def main():
	inputCode = sys.stdin.read()
	#print(str(len(inputCode)))
	tokens = regexInterpreter(inputCode)
	#print(str(len(tokens)))
	tokens = regexFilter(tokens)
	tokens.append(Token('EOF', '<EOF>'))
	tokensParsed = parse(tokens)
	tokenJSON = []
	if tokensParsed.__class__ ==  textAST:
		print(("[{0}]".format(json.loads(json.dumps(tokensParsed.toJSON())))))
		return
	for i in tokensParsed:
	# 	print(str(i))
		if(i == None):
			continue
		tokenJSON.append(i.toJSON())
		#print(next(tokens))
		#sys.stdout.write(i.toJson())
	
	print(("[{0}]".format(','.join(map(str, json.loads(json.dumps(tokenJSON)))))))

	
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
