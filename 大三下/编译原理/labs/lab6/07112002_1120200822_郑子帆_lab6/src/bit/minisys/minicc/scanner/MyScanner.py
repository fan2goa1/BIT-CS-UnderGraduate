# -*- coding: utf-8 -*-
#! /usr/local/bin/python3

import os
import sys
import string

# 关键词
cKeywords = ['auto', 'break', 'case', 'char', 'const',
             'continue', 'default', 'do', 'double', 'else',
             'enum', 'extern', 'float', 'for', 'goto',
             'if', 'inline', 'int', 'long', 'register',
             'restrict', 'return', 'short', 'signed', 'sizeof',
             'static', 'struct', 'switch', 'typedef', 'union',
             'unsigned', 'void', 'volatile', 'while']
# 转义字符
cEscSequence = ['\'', '"', '?', '\\', 'a', 'b', 'f', 'n', 'r', 't', 'v']
# 运算符
cOperator = ['+', '-', '&', '*', '~', '!', '/',
             '^', '%', '=', '.', ':', '?', '#', '<', '>', '|', '`']
# 可作为二元运算符首字符的算符
cBinaryOp = ['+', '-', '>', '<', '=', '!',
             '&', '|', '*', '/', '%', '^', '#', ':', '.']
# 界限符
cDelimiter = ['[', ']', '(', ')', '{', '}', '\'', '"', ',', ';', '\\']

# 指针查找位置
index = 0

# 属性
codeNum = 1
codeType = ''
codeCol = 0
codeLine = 1
codeValue = ''
codeValid = 0

# 自动机状态
charState = 0
stringState = 0
constantState = 0
operatorState = 0


def preProcess(content):
    code = ''
    for line in content:
        if line != '\n':
            code = code + line
        else:
            code = code + line
    code = code + '@'   # 加一个@表示EOF
    return code


def scanner(code):
    # 从左到右分别为：当前扫描代码位置、当前识别符数、当前代码行、识别到词语的类别、识别到的词语
    global index, codeNum, codeLine, codeType, codeValue, codeCol
    
    codeType = ''
    codeValue = ''
    
    # 当前识别字符
    character = code[index]
    index = index + 1
    codeCol = codeCol + 1

    # 空格直接跳过
    while character == ' ':
        character = code[index]
        index = index + 1
        codeCol = codeCol + 1

    # 标识符or关键字
    if character.isalpha() or character == '_':
        while character.isalpha() or character.isdigit() or character == '_':
            codeValue = codeValue + character
            character = code[index]
            index = index + 1
            codeCol = codeCol + 1
        codeType = 'identifier'
        index = index - 1
        codeCol = codeCol - 1
        # 关键字
        for keyword in cKeywords:
            if codeValue == keyword:
                codeType = 'keyword'
                break

    # 字符串
    elif character == '"':
        global stringState
        while index < len(code):
            codeValue = codeValue + character
            if stringState == 0:
                if character == '"':
                    stringState = 1
            elif stringState == 1:
                if character == '\\':
                    stringState = 3
                elif character == '"':
                    stringState = 2
                    break
            elif stringState == 2:
                break
            elif stringState == 3:
                if character in cEscSequence:
                    stringState = 1
            character = code[index]
            index = index + 1
            codeCol = codeCol + 1

        if stringState == 2:
            codeType = 'string'
            stringState = 0
        else:
            print('Illegal string.')
            stringState = 0

    # 字符
    elif character == '\'':
        global charState
        while index < len(code):
            codeValue = codeValue + character
            if charState == 0:
                if character == '\'':
                    charState = 1
            elif charState == 1:
                if character == '\'':
                    charState = 2
                    break
                elif character == '\\':
                    charState = 3
            elif charState == 2:
                break
            elif charState == 3:
                if character in cEscSequence:
                    charState = 1
            character = code[index]
            index = index + 1
            codeCol = codeCol + 1
        if charState == 2:
            codeType = 'character'
            charState = 0
        else:
            codeType = 'illegal char'
            charState = 0

    # 整型、浮点型变量
    elif character.isdigit():
        global constantState
        while character.isdigit() or character in '-.xXeEaAbBcCdDfFuUlL':
            codeValue = codeValue + character
            if constantState == 0:
                if character == '0':
                    constantState = 1
                elif character in '123456789':
                    constantState = 2
            elif constantState == 1:
                if character in 'xX':
                    constantState = 3
                elif character in '01234567':
                    constantState = 4
                elif character == '.':
                    constantState = 5
                elif character in 'lL':
                    constantState = 9
                elif character in 'uU':
                    constantState = 11
                else:
                    constantState = -1
            elif constantState == 2:
                if character.isdigit():
                    constantState = 2
                elif character == '.':
                    constantState = 5
                elif character in 'lL':
                    constantState = 9
                elif character in 'uU':
                    constantState = 11
            elif constantState == 3:
                if character in 'aAbBcCdDeEfF' or character.isdigit():
                    constantState = 14
            elif constantState == 4:
                if character in '01234567':
                    constantState = 4
                elif character in 'lL':
                    constantState = 9
                elif character in 'uU':
                    constantState = 11
                else:
                    constantState = -1
            elif constantState == 5:
                if character.isdigit():
                    constantState = 6
            elif constantState == 6:
                if character.isdigit():
                    constantState = 6
                elif character in 'eE':
                    constantState = 7
                elif character in 'fFlL':
                    constantState = 15
                else:
                    constantState = -1
            elif constantState == 7:
                if character.isdigit():
                    constantState = 6
                elif character == '-':
                    constantState = 8
            elif constantState == 8:
                if character.isdigit():
                    constantState = 6
            elif constantState == 9:
                if character in 'lL':
                    constantState = 10
                elif character in 'uU':
                    constantState = 12
                else:
                    constantState = -1
            elif constantState == 10:
                if character in 'uU':
                    constantState = 13
                else:
                    constantState = -1
            elif constantState == 11:
                if character in 'lL':
                    constantState = 12
                else:
                    constantState = -1
            elif constantState == 12:
                if character in 'lL':
                    constantState = 13
                else:
                    constantState = -1
            elif constantState == 14:
                if character.isdigit() or character in 'aAbBcCdDeEfF':
                    constantState = 14
                elif character in 'lL':
                    constantState = 9
                elif character in 'uU':
                    constantState = 11
                else:
                    constantState = -1
            elif constantState == 13 or constantState == 15:
                if character:
                    constantState = -1

            character = code[index]
            index = index + 1
            codeCol = codeCol + 1
        index = index - 1
        codeCol = codeCol - 1
        if constantState in (1, 2, 4, 9, 10, 11, 12, 13, 14):
            codeType = 'integer constant'
            constantState = 0
        elif constantState == 6 or constantState == 15:
            codeType = 'floating constant'
            constantState = 0
        else:
            codeType = 'illegal constant'
            constantState = 0

    # 界限符
    elif character in cDelimiter:
        codeValue = codeValue + character
        codeType = 'delimiter'

    # 运算符
    elif character in cOperator:
        global operatorState
        while character in cOperator:
            codeValue = codeValue + character
            if operatorState == 0:
                if not character in cBinaryOp:
                    operatorState = 20
                    break
                else:
                    if character == '+':
                        operatorState = 2
                    elif character == '-':
                        operatorState = 3
                    elif character == '<':
                        operatorState = 4
                    elif character == '>':
                        operatorState = 5
                    elif character == '=':
                        operatorState = 6
                    elif character == '!':
                        operatorState = 7
                    elif character == '&':
                        operatorState = 8
                    elif character == '|':
                        operatorState = 9
                    elif character == '*':
                        operatorState = 10
                    elif character == '/':
                        operatorState = 11
                    elif character == '%':
                        operatorState = 12
                    elif character == '^':
                        operatorState = 13
                    elif character == '#':
                        operatorState = 14
                    elif character == ':':
                        operatorState = 15
                    elif character == '.':
                        operatorState = 18

            elif operatorState == 1:
                break
            elif operatorState == 2:
                if character in '+=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 3:
                if character in '-=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 4:
                if character in '=:%':
                    operatorState = 1
                    break
                elif character == '<':
                    operatorState = 16
                else:
                    operatorState = -1
            elif operatorState == 5:
                if character in '=':
                    operatorState = 1
                    break
                elif character == '>':
                    operatorState = 17
                else:
                    operatorState = -1
            elif operatorState == 6:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 7:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 8:
                if character in '&=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 9:
                if character in '|=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 10:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 11:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 12:
                if character in '=>:':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 13:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 14:
                if character == '#':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 15:
                if character == '>':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 16:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 17:
                if character == '=':
                    operatorState = 1
                    break
                else:
                    operatorState = -1
            elif operatorState == 18:
                if character == '.':
                    operatorState = 19
                else:
                    operatorState = -1
            elif operatorState == 19:
                if character == '.':
                    operatorState = 1
                    break
                else:
                    operatorState = -1

            character = code[index]
            index = index + 1
            codeCol = codeCol + 1

        if operatorState >= 2 and operatorState <= 18:
            index = index - 1
            codeCol = codeCol - 1
            codeType = 'Unary operator'
            operatorState = 0
        elif operatorState == 20:
            codeType = 'Unary operator'
            operatorState = 0
        elif operatorState == 1:
            codeType = 'Multicast operator'
            operatorState = 0
        else:
            index = index - 1
            codeCol = codeCol - 1
            codeType = 'Illegal operator'
            operatorState = 0
    # 换行
    elif character == '\n':
        codeLine = codeLine + 1
        codeCol = 0
    # EOF
    elif character == '@':
        codeValue = codeValue + character
        codeType = 'END OF FILE'


def main():
    # 读源文件
    filePath = sys.argv[1]
    f = open(filePath, 'r')
    content = f.readlines()
    f.close()
    
    # 预处理文件
    code = preProcess(content)

    # 扫描
    FileOutPut = ""
    global codeNum
    while index <= len(code) - 1:
        scanner(code)
        if codeType != '':
            FileOutPut += "[@" + str(codeLine) + "," + str(codeCol) + ":" + str(codeCol) + "\'" + str(codeValue) + "\'" + "<" + str(codeType) + ">," + str(codeLine) + ":" + str(codeCol) + "]\n"
            codeNum = codeNum + 1

    # 输出到文件    
    OutfilePath = sys.argv[2]
    f = open(OutfilePath, 'w')
    f.write(FileOutPut)


if __name__ == "__main__":
    main()
