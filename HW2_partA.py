# Name: Ran Tao
# SID: 11488080
# Class: cpts355
# Date: 1/24/2017
# Assignment 2 (PostScript Interpreter - Part A)
# Windows-PyCharm Community Edition 2016.3.2 (Python 3.6.0 - 32bit)

# The Operand Stack
# The operand stack should be implemented as a Python list. The list will contain Python integers, arrays,
# and later in Part 2 code arrays. Python integers and arrays on the stack represent Postscript integer
# constants and array constants. Python strings which start with a slash / on the stack represent names of
# Postscript variables. When using a list as a stack one of the decisions you have to make is where the hot
# end of the stack is located. (The hot end is where pushing and popping happens). Will the hot end be at
# position 0, the head of the list, or at position -1, the end of the list? It's your choice.
opstack = []

# Pop from stack
def opPop():
    if len(opstack) > 0:
        return opstack.pop()
    print("Operand Stack is empty")

# push in stack
def opPush(x):
    opstack.append(x)

# The Dictionary Stack
# The dictionary stack is also implemented as a Python list. It will contain Python dictionaries which will be
# the implementation for Postscript dictionaries. The dictionary stack needs to support adding and
# removing dictionaries at the hot end, as well as defining and looking up names.
dictstack = []

# Pop in dictstack
def dictPop():
    if dictstack == []:
        print("Dictionary Stack is empty")
    return dictstack.pop()

# Push in dictstack
def dictPush(x):
    dictstack.append(x)

# Name Lookup
# Note that name lookup is not a Postscript operator, but you will implement it in your interpreter. In Part
# B, when you interpret simple Postscript expressions, you will call this function for variable lookups and
# function calls
def define(name, value):
    if(len(dictstack)>0):
        dictstack[-1][name]=value #define the dictstack
    d={}
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
    if var == 0:
        print("Variable not found")
    return var

# Operators
# Operators will be implemented as zero-argument Python functions that manipulate the operand and
# dictionary stacks. For example, the div operator could be implemented as the below Python function
# (with comments instead of actual implementations)

# Add
def add():
    op1 = opPop()
    op2 = opPop()
    opPush(op1 + op2)


# Sub
def sub():
    op1 = opPop()
    op2 = opPop()
    opPush(op2 - op1)


# Mul
def mul():
    op1 = opPop()
    op2 = opPop()
    opPush(op1 * op2)


# Div
def div():
    op1 = opPop()
    op2 = opPop()
    if op1 == 0:
        print("/undefinedresult in --div--")
        return False
    opPush(op2 / op1)

# Mod
def mod():
    op1 = opPop()
    op2 = opPop()
    opPush(op2 % op1)

# Array operators: define the array operators
# length
def length():
    opPush(len(opPop()))

#get
def get():
    if(len(opstack) == 0):
        print("/stackunderflow in --get--")
    num = opPop()
    l = opPop()
    opPush(l[num])

# Define the stack manipulation and print operators:
# dup
def dup():
    if(len(opstack) == 0):
        print("/stackunderflow in --dup--")
    op1 = opPop()
    opPush(op1)
    opPush(op1)


# exch
def exch():
    if(len(opstack)<2):
        print("/stackunderflow in --exch--")
    op1 = opPop()
    op2 = opPop()
    opPush(op1)
    opPush(op2)

# pop
def pop():
    opPop()

def roll():
    if(len(opstack) <= 1):
        return False
    op1 = opPop()
    op2 = opPop()
    if op1 > 0:
        for index in range(op1):
            opstack.insert(-op2 + 1, opPop())
    else:
        for index in range(op2 + op1):
            opstack.insert(-op2 + 1, opPop())

# copy
def copy():
    global opstack
    op1 = opPop()
    if(len(opstack) < op1):
        return False
    opstack += opstack[-op1:]

# clear
def clear():
    global opstack, dictstack
    opstack = []
    dictstack = []

# stack
def stack():
    tmp = []
    while opstack != []:
        tmp.append(opstack.pop())
        print(tmp[-1])
    while tmp != []:
        opstack.append(tmp.pop())

# Define the dictionary manipulation operators:
# dict
def dict():
    newdict = {}
    newdict = newdict.fromkeys(range(opPop()))
    opstack.append(newdict)


# begin
def begin():
    d = opstack.pop()
    if d != {}:
        print("/typecheck in --begin--")
        return False
    dictstack.append(d)


# end
def end():
    if(len(dictstack) == 0):
        print("/dictstackunderflow in --end--")
        return False
    return dictstack.pop()

# psdef
def psDef():
    op1 = opPop()
    op2 = opPop()
    if dictstack == []:
        dictstack.append({})
    value = dictPop()
    value[op2[1:]] = op1
    dictPush(value)


# Test Cases
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
    opPush([1,2,3])
    length()
    if opPop() != 3: return False
    return True

def testGet():
    opPush([1,2,3])
    opPush(2)
    get()
    if opPop() != 3:return False
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
    dictstack=[{'x': 1}]
    psDef()
    if(dictstack != [{'x':2}]): return False
    opPush('/y')
    opPush(3)
    psDef()
    if dictstack != [{'x': 2, 'y': 3}]: return False
    return True

# Main Program
if __name__ == '__main__':

    testCases = [('add', testAdd), ('sub', testSub), ('mul', testMul), ('div', testDiv),('mod', testMod),
                 ('length', testLength),('get', testGet),
                 ('define', testDefine), ('lookup', testLookup),
                 ('dup', testDup),('exch', testExch), ('pop', testPop),('roll', testRoll), ('copy', testCopy), ('clear', testClear), ('stack', testStack),
                 ('dict', testDict), ('begin', testBegin), ('end', testEnd), ('psDef', testpsDef)]

    failedTests = [testName for (testName, testProc) in testCases if not testProc()]

    if failedTests != []:  # has failed tests
        print('Some tests failed', failedTests)
    else:
        print('All tests OK')