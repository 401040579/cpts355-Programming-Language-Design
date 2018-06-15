# Name: Ran Tao
# SID: 11488080
# Class: cpts355
# Date: 1/24/2017
# HW1.py
# Windows-PyCharm Community Edition 2016.3.2 (Python 3.6.0 - 32bit)

debugging = False

# Define a function debug
def debug(*s):
    if debugging:
        print("This is my debugging output:")
        print(*s)


# 1. Warmup – cryptDict() and decrypt() – 35%

# Define a function cryptDict(s1,s2) that returns a dictionary such that each character in
# s1 is mapped to the character at the corresponding position in s2.
def cryptDict(s1, s2):
    d = {}
    for i in range(len(s1)):
        d[s1[i]] = s2[i]
    debug(d)
    return d


# define a function decrypt(cdict,S) decrypt translates its string argument, S, according
# to its decryption dictionary argument, cdict.
def decrypt(cdict, S):
    str = ""
    for c in S:
        str = str + cdict.get(c, c)
    debug(str)
    return str


# define a function testDecrypt()
# function to test translation code
# return True if successful, False if any test fails
def testDecrypt():
    cdict = cryptDict("abc", "xyz")
    revcdict = cryptDict("xyz", "abc")
    tests = "Now I know my abc's"
    answer = "Now I know my xyz's"
    if decrypt(cdict, tests) != answer:
        return False
    if decrypt(revcdict, "Now I know my xyz's") != "Now I know mb abc's":
        return False
    if decrypt(cdict, "") != '':
        return False
    if decrypt(cryptDict("", ""), "abc") != "abc":
        return False
    return True


# testDecrypt()

# 2. charCount() - 30%

# Define a function, charCount(S) counting the number of times that each character appears
# in a given string.
def charCount(S):
    d = {}
    S = S.replace(' ', '')
    for c in S:
        d[c] = d.get(c, 0) + 1
    debug(sorted(d.items(), key=lambda item: item[1]))
    return sorted(d.items(), key=lambda item: item[1])


# testCount() that tests your charCount(S) function, returning True if
# the code passes your tests, and False if the tests fail.
def testCount():
    testString = "Cpts355 --- Assign1"
    answer = [('C', 1), ('p', 1), ('t', 1), ('3', 1), ('A', 1), ('i', 1), ('g', 1), ('n', 1), ('1', 1), ('5', 2),
              ('s', 3), ('-', 3)]
    if charCount(testString) != answer:
        return False
    if charCount(" ") != []:
        return False
    return True


# testCount()

# 3. dictAddup() - 35%

# Define a function, dictAddup(d) which adds up the number of hours you studied for each
# of the courses during the week and returns the summed values as a dictionary.
def dictAddup(d):
    valuesOfd = {}
    op = {}
    for i in d:
        valuesOfd = d[i]
        for classes in valuesOfd:
            op[classes] = op.get(classes, 0) + valuesOfd[classes]
    debug(op)
    return op


# Define a function testAddup() that tests your dictAddup(d) function, returning True if the
# code passes your tests, and False if the tests fail.
def testAddup():
    testDict = {'Monday': {'355': 2, '451': 1, '360': 2},
                'Tuesday': {'451': 2, '360': 3},
                'Thursday': {'355': 3, '451': 2, '360': 3},
                'Friday': {'355': 2},
                'Sunday': {'355': 1, '451': 3, '360': 1}}
    answer = {'355': 8, '451': 8, '360': 9}
    if dictAddup(testDict) != answer:
        return False
    return True


# testAddup()

# main program
if __name__ == '__main__':
    passedMsg = "%s passed"
    failedMsg = "%s failed"
    if testDecrypt():
        print(passedMsg % 'testDecrypt')
    else:
        print(failedMsg % 'testDecrypt')
    if testCount():
        print(passedMsg % 'testCount')
    else:
        print(failedMsg % 'testCount')
    if testAddup():
        print(passedMsg % 'testAddup')
    else:
        print(failedMsg % 'testAddup')
