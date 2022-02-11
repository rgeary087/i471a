import sys
import json
import re

inputCode = ''

def regexInterpreter(inputLine):
	if re.match('\s+#ifdef\b+', inputLine):
		print("matched")
		return True
	print('not matched')
	return False


def main():
	inputCode = sys.stdin.read().splitlines()
	print(inputCode)
	tokens = map(regexInterpreter, inputCode)
	#print(next(tokens))

if __name__ == '__main__':
	main()
