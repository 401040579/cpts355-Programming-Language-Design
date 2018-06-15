########################################################################################################################
# Name: Ran Tao
# SID: 11488080
# Class: cpts355
# Date: 2/26/2017
# Assignment 2 (PostScript Interpreter - Part B)
# Windows-PyCharm Community Edition 2016.3.2 (Python 3.6.0 - 32bit)
########################################################################################################################

########################################################################################################################
# The Operand Stack
# The operand stack should be implemented as a Python list. The list will contain Python integers, arrays,
# and later in Part 2 code arrays. Python integers and arrays on the stack represent Postscript integer
# constants and array constants. Python strings which start with a slash / on the stack represent names of
# Postscript variables. When using a list as a stack one of the decisions you have to make is where the hot
# end of the stack is located. (The hot end is where pushing and popping happens). Will the hot end be at
# position 0, the head of the list, or at position -1, the end of the list? It's your choice.
########################################################################################################################
opstack = []


# Pop from stack
def opPop():
    if len(opstack) > 0:
        return opstack.pop()
    print("Operand Stack is empty")

########################################################################################################################
# push in stack
########################################################################################################################
def opPush(x):
    opstack.append(x)

########################################################################################################################
# The Dictionary Stack
# The dictionary stack is also implemented as a Python list. It will contain Python dictionaries which will be
# the implementation for Postscript dictionaries. The dictionary stack needs to support adding and
# removing dictionaries at the hot end, as well as defining and looking up names.
########################################################################################################################
dictstack = []

########################################################################################################################
# Pop in dictstack
########################################################################################################################
def dictPop():
    if dictstack == []:
        print("Dictionary Stack is empty")
    return dictstack.pop()

########################################################################################################################
# Push in dictstack
########################################################################################################################
def dictPush(x):
    dictstack.append(x)

########################################################################################################################
# Name Lookup/define
# Note that name lookup is not a Postscript operator, but you will implement it in your interpreter. In Part
# B, when you interpret simple Postscript expressions, you will call this function for variable lookups and
# function calls
########################################################################################################################
def define(name, value):
    if (len(dictstack) > 0):
        dictstack[-1][name] = value  # define the dictstack
    d = {}
    d[name] = value
    dictPush(d)

def lookup(name):
    var = 0
    tmp = []
    for x in dictstack:
        tmp.append(x)

    tmp.reverse()

    for y in tmp:
        var = y.get(name, 0)
        if var != 0:
            return var
    return var

########################################################################################################################
# Operators
# Operators will be implemented as zero-argument Python functions that manipulate the operand and
# dictionary stacks. For example, the div operator could be implemented as the below Python function
# (with comments instead of actual implementations)
########################################################################################################################

########################################################################################################################
# Add
########################################################################################################################
def add():
    op1 = opPop()
    op2 = opPop()
    opPush(op1 + op2)

########################################################################################################################
# Sub
########################################################################################################################
def sub():
    op1 = opPop()
    op2 = opPop()
    opPush(op2 - op1)

########################################################################################################################
# Mul
########################################################################################################################
def mul():
    op1 = opPop()
    op2 = opPop()
    opPush(op1 * op2)

########################################################################################################################
# Div
########################################################################################################################
def div():
    op1 = opPop()
    op2 = opPop()
    if op1 == 0:
        print("/undefinedresult in --div--")
        return False
    opPush(op2 / op1)

########################################################################################################################
# Mod
########################################################################################################################
def mod():
    op1 = opPop()
    op2 = opPop()
    opPush(op2 % op1)

########################################################################################################################
# Array operators: define the array operators
# length
########################################################################################################################
def length():
    opPush(len(opPop()))

########################################################################################################################
# get
########################################################################################################################
def get():
    if (len(opstack) == 0):
        print("/stackunderflow in --get--")
    num = opPop()
    l = opPop()
    opPush(l[num])

########################################################################################################################
# Define the stack manipulation and print operators:
# dup
########################################################################################################################
def dup():
    if (len(opstack) == 0):
        print("/stackunderflow in --dup--")
    op1 = opPop()
    opPush(op1)
    opPush(op1)

########################################################################################################################
# exch
########################################################################################################################
def exch():
    if (len(opstack) < 2):
        print("/stackunderflow in --exch--")
    op1 = opPop()
    op2 = opPop()
    opPush(op1)
    opPush(op2)

########################################################################################################################
# pop
########################################################################################################################
def pop():
    opPop()

########################################################################################################################
# roll
########################################################################################################################
def roll():
    if (len(opstack) <= 1):
        return False
    op1 = opPop()
    op2 = opPop()
    if op1 > 0:
        for index in range(op1):
            opstack.insert(-op2 + 1, opPop())
    else:
        for index in range(op2 + op1):
            opstack.insert(-op2 + 1, opPop())

########################################################################################################################
# copy
########################################################################################################################
def copy():
    global opstack
    op1 = opPop()
    if (len(opstack) < op1):
        return False
    opstack += opstack[-op1:]

########################################################################################################################
# clear
########################################################################################################################
def clear():
    global opstack, dictstack
    opstack = []
    dictstack = []

########################################################################################################################
# stack
########################################################################################################################
def stack():
    tmp = []
    while opstack != []:
        tmp.append(opstack.pop())
        print(tmp[-1])
    while tmp != []:
        opstack.append(tmp.pop())

########################################################################################################################
# Define the dictionary manipulation operators:
# dict
########################################################################################################################
def dict():
    newdict = {}
    newdict = newdict.fromkeys(range(opPop()))
    opstack.append(newdict)

########################################################################################################################
# begin
########################################################################################################################
def begin():
    d = opstack.pop()
    if d != {}:
        print("/typecheck in --begin--")
        return False
    dictstack.append(d)

########################################################################################################################
# end
########################################################################################################################
def end():
    if (len(dictstack) == 0):
        print("/dictstackunderflow in --end--")
        return False
    return dictstack.pop()

########################################################################################################################
# psdef
########################################################################################################################
def psDef():
    op1 = opPop()
    op2 = opPop()
    if dictstack == []:
        dictstack.append({})
    value = dictPop()
    value[op2[1:]] = op1 # skip the '/' sign
    dictPush(value)

########################################################################################################################
# <init> <incr> <final> <code array> for
# – Pops four items: init and incr and and final and code array.
# – Then, for each integer starting at init and going by steps of incr until
# passing final, it pushes the current integer index onto the stack and then
# executes the array.
########################################################################################################################
def forr():
    arr = opPop()
    stopindex = opPop()
    increment = opPop()
    startindex = opPop()
    while(True):
        opPush(startindex)
        if(len(arr)==1):
            if(arr[0] == 'add'):
                add()
            elif (arr[0] == 'sub'):
                sub()
            elif (arr[0] == 'mul'):
                mul()
            elif (arr[0] == 'div'):
                div()
            elif (arr[0] == 'mod'):
                mod()
            elif (arr[0] == 'dup'):
                dup()
            else:
                return False
        elif(len(arr)==2):
            opPush(arr[0])
            if(arr[1] == 'add'):
                add()
            elif (arr[1] == 'sub'):
                sub()
            elif (arr[1] == 'mul'):
                mul()
            elif (arr[1] == 'div'):
                div()
            elif (arr[1] == 'mod'):
                mod()
            elif (arr[1] == 'dup'):
                dup()
            else:
                return False
        else:
            return  False

        if(startindex == stopindex):
            break

        startindex = startindex + increment

########################################################################################################################
# Postscript defines a forall operator that takes an
# array and a code-block as operands. The code-block is
# performed on each member of the array.
########################################################################################################################
def forall():
    operator = opPop()
    arr = opPop()
    for i in arr:
        opPush(i)
        opPush(operator[0])
        if (operator[1] == 'add'):
            add()
        elif (operator[1] == 'sub'):
            sub()
        elif (operator[1] == 'mul'):
            mul()
        elif (operator[1] == 'div'):
            div()
        elif (operator[1] == 'mod'):
            mod()
        elif (operator[1] == 'dup'):
            dup()
        else:
            return False

########################################################################################################################
# 1. Convert all the string to a list of tokens.
# For tokenizing we'll use the “re” package for Regular Expressions.
########################################################################################################################
import re

########################################################################################################################
# def tokenize(s):
########################################################################################################################
def tokenize(s):
    retValue = re.findall("/?[a-zA-Z][a-zA-Z0-9_]*|[[][a-zA-Z0-9_\s!][a-zA-Z0-9_\s!]*[]]|[-]?[0-9]+|[}{]+|%.*|[^ \t\n]",
                          s)
    return retValue
########################################################################################################################
# isNumber is a function to decide is A number
########################################################################################################################
def isnumber(x):
    try:
        x=int(x)
        return isinstance(x,int)
    except ValueError:
        return False

########################################################################################################################
# groupMatching(it)
########################################################################################################################
def groupMatching(it):
    res = []
    for c in it:
        if c == '}':
            return res
        elif c=='{':
            # note how we use a recursive call to group the inner
            # matching parenthesis string and append it as a whole
            # to the list we are constructing.
            res.append(groupMatching(it))
        else:
            if isnumber(c):
                a = int(c)
                res.append(a)
            elif c[0] == '[':
                c = c[1:]
                c = c[:-1]
                strarr = c.split()
                intarr = [int(x) for x in strarr]
                res.append(intarr)
            else:
                res.append(c)
    return False

########################################################################################################################
# function to turn a string of properly nested parentheses
# into a list of properly nested lists.
########################################################################################################################
def parse(s):
    s = fixParse(s)
    if s[0] == '{':
        return groupMatching(iter(s[1:]))
    return False  # If it starts with ')' it is not properly nested

# add '{' and '}' into the array
def fixParse(arr):
    arr.insert(0, '{')
    arr.append('}')
    return arr

########################################################################################################################
# Function: def interpret(code):
# Write the necessary code here; again write
# auxiliary functions if you need them. This will probably be the largest
# function of the whole project, but it will have a very regular and obvious
# structure if you've followed the plan of the assignment.
########################################################################################################################
def interpret(code):
    ####################################################################################################################
    #    if taken is interger
    #        push to opstack
    #    if token is string
    #        if it is a name
    #            push to opstack
    #        if it is a variable loopup  ] variable lookup -> push to opstack
    #            get variable value from the dictstack ] and function call -> interpret
    #        if one of the built in opertions
    #           call the function for the opertion
    #    if token is a list
    #        push to opstack
    ####################################################################################################################
    if(code != []):
        token = code.pop(0)
        if type(token) == int:
            opPush(token)
        elif type(token) == type(""):
            if(token[0] == '/'):
                opPush(token)
            elif(lookup(token)):
                if(type(lookup(token)) == int):
                    opPush(lookup(token))
                else:
                    a = lookup(token)(:)
                    interpret(a) # and rec
            elif(token == 'add'):
                add()
            elif(token == 'sub'):
                sub()
            elif(token == 'mul'):
                mul()
            elif(token == 'div'):
                div()
            elif(token == 'mod'):
                mod()
            elif(token == 'dict'):
                dict()
            elif(token == 'length'):
                length()
            elif(token == 'get'):
                get()
            elif(token == 'dup'):
                dup()
            elif(token == 'exch'):
                exch()
            elif(token == 'pop'):
                pop()
            elif(token == 'roll'):
                roll()
            elif(token == 'copy'):
                copy()
            elif(token == 'clear'):
                clear()
            elif(token == 'stack'):
                stack()
            elif(token == 'dict'):
                dict()
            elif(token == 'begin'):
                begin()
            elif(token == 'end'):
                end()
            elif(token == 'def'):
                psDef()
            elif(token == 'for'):
                forr()
            elif(token == 'forall'):
                forall()
            else:
                return False
        elif type(token) == type([]):
            opPush(token)
        else:
            return False

        interpret(code)
    else:
        return True

########################################################################################################################
# Copy this to your HW2_partB.py file>
########################################################################################################################
def interpreter(s): # s is a string
    interpret(parse(tokenize(s)))

########################################################################################################################
# Test Cases
########################################################################################################################
def testAdd():
    opPush(1)
    opPush(2)
    add()
    if opPop() != 3: return False
    return True


def testSub():
    opPush(1)
    opPush(2)
    sub()
    if opPop() != -1: return False
    return True


def testMul():
    opPush(1)
    opPush(2)
    mul()
    if opPop() != 2: return False
    return True


def testDiv():
    opPush(2)
    opPush(1)
    div()
    if opPop() != 2: return False
    return True


def testMod():
    opPush(9)
    opPush(5)
    mod()
    if opPop() != 4: return False
    return True


def testLength():
    opPush([1, 2, 3])
    length()
    if opPop() != 3: return False
    return True


def testGet():
    opPush([1, 2, 3])
    opPush(2)
    get()
    if opPop() != 3: return False
    return True


def testDefine():
    define('class', 355)
    if lookup('class') != 355: return False
    return True


def testLookup():
    opPush("/n1")
    opPush(1)
    psDef()
    if lookup("n1") != 1: return False
    return True


def testDup():
    opPush(1)
    dup()
    if opstack[-2:] != [1, 1]: return False
    return True


def testExch():
    opPush(1)
    opPush(2)
    exch()
    if opstack[-2:] != [2, 1]: return False
    return True


def testPop():
    clear()
    opPush(1)
    pop()
    if opstack != []: return False
    return True


def testRoll():
    global opstack
    opstack = [1, 2, 3, 4, 5]
    opPush(4)
    opPush(2)
    roll()
    if opstack != [1, 4, 5, 2, 3]: return False
    return True


def testCopy():
    clear()
    opPush(1)
    opPush(2)
    opPush(2)
    copy()
    if opstack != [1, 2, 1, 2]: return False
    return True


def testClear():
    global opstack, dictstack
    opstack = ["things"]
    dictstack = [{'t': 'h', 'i': 'n'}, {'g': 's'}]
    clear()
    if (opstack, dictstack) != ([], []): return False
    return True


def testStack():
    stack()
    return True


def testDict():
    clear()
    opPush(1)
    dict()
    if opstack != [{0: None}]: return False
    return True


def testBegin():
    clear()
    opPush({})
    begin()
    if dictstack != [{}]: return False
    return True


def testEnd():
    global dictstack
    dictstack = [{'a': 1}, {'b': 2}]
    end()
    if dictstack != [{'a': 1}]: return False
    return True


def testpsDef():
    global opstack, dictstack
    opstack = [1, '/x', 2]
    dictstack = [{'x': 1}]
    psDef()
    if (dictstack != [{'x': 2}]): return False
    opPush('/y')
    opPush(3)
    psDef()
    if dictstack != [{'x': 2, 'y': 3}]: return False
    return True

def testForall():
    clear()
    opPush([1,2,3,4])
    opPush([1,'add'])
    forall()
    if opPop() != 5: return  False
    return True

def testFor():
    clear()
    opPush(1)
    opPush(5)
    opPush(-1)
    opPush(1)
    opPush(['mul'])
    forr()
    if opPop() != 120: return False
    opPush(1)
    opPush(1)
    opPush(3)
    opPush([10, 'mul'])
    forr()
    if(opPop() != 30): return False
    return True

########################################################################################################################
# Main Program
########################################################################################################################
if __name__ == '__main__':

    testCases = [('add', testAdd), ('sub', testSub), ('mul', testMul), ('div', testDiv), ('mod', testMod),
                 ('length', testLength), ('get', testGet),
                 ('define', testDefine), ('lookup', testLookup),
                 ('dup', testDup), ('exch', testExch), ('pop', testPop), ('roll', testRoll), ('copy', testCopy),
                 ('clear', testClear), ('stack', testStack),
                 ('dict', testDict), ('begin', testBegin), ('end', testEnd), ('psDef', testpsDef),
                 ('forall', testForall),('for', testFor)]

    failedTests = [testName for (testName, testProc) in testCases if not testProc()]

    if failedTests != []:  # has failed tests
        print('Some tests failed', failedTests)
    else:
        print('All tests OK')

########################################################################################################################
# HW2_partB
# test case 1
########################################################################################################################
clear()
print()
print("HW2_partB test case 1:")
print("GS>/square {dup mul} def 1 square 2 square 3 square add add")
print('GS<1>stack')
interpreter("""
/square {dup mul} def 1 square 2 square 3 square add add stack
""")
print()

########################################################################################################################
# test case 2
########################################################################################################################
clear()

print("test case 2:")
print("GS>/n 5 def 1 n -1 1 {mul} for")
print('GS<1>stack')
interpreter("""
/n 5 def 1 n -1 1 {mul} for stack
""")
print()

########################################################################################################################
# test case 3
########################################################################################################################
clear()
print("test case 3:")
print("GS>/sum { -1 0 {add} for} def 0 [1 2 3 4] length sum 2 mul [1 2 3 4] {2 mul} forall add add add")
print('GS<2>stack')
interpreter("""
/sum { -1 0 {add} for} def
0
[1 2 3 4] length
sum
2 mul
[1 2 3 4] {2 mul} forall
add add add
stack
""")
print()
########################################################################################################################
# test case 4
########################################################################################################################
clear()
print("test case 4:")
print("GS>/fact {0 dict begin /n exch def 1 n -1 1 {mul} for end} def [1 2 3 4 5] dup 4 get pop length fact")
print('GS<1>stack')
interpreter(
"""
/fact{
0 dict
begin
/n exch def
1
n -1 1 {mul} for
end
}def
[1 2 3 4 5] dup 4 get pop
length
fact
stack
""")