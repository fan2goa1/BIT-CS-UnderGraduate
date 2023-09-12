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
State_char = 0
State_string = 0
State_constant = 0
State_operator = 0


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
        global State_string
        while index < len(code):
            codeValue = codeValue + character
            if State_string == 0:
                if character == '"':
                    State_string = 1
            elif State_string == 1:
                if character == '\\':
                    State_string = 3
                elif character == '"':
                    State_string = 2
                    break
            elif State_string == 2:
                break
            elif State_string == 3:
                if character in cEscSequence:
                    State_string = 1
            character = code[index]
            index = index + 1
            codeCol = codeCol + 1

        if State_string == 2:
            codeType = 'string'
            State_string = 0
        else:
            print('Illegal string.')
            State_string = 0

    # 字符
    elif character == '\'':
        global State_char
        while index < len(code):
            codeValue = codeValue + character
            if State_char == 0:
                if character == '\'':
                    State_char = 1
            elif State_char == 1:
                if character == '\'':
                    State_char = 2
                    break
                elif character == '\\':
                    State_char = 3
            elif State_char == 2:
                break
            elif State_char == 3:
                if character in cEscSequence:
                    State_char = 1
            character = code[index]
            index = index + 1
            codeCol = codeCol + 1
        if State_char == 2:
            codeType = 'character'
            State_char = 0
        else:
            codeType = 'illegal char'
            State_char = 0

    # 整型、浮点型变量
    elif character.isdigit():
        global State_constant
        while character.isdigit() or character in '-.xXeEaAbBcCdDfFuUlL':
            codeValue = codeValue + character
            if State_constant == 0:
                if character == '0':
                    State_constant = 1
                elif character in '123456789':
                    State_constant = 2
            elif State_constant == 1:
                if character in 'xX':
                    State_constant = 3
                elif character in '01234567':
                    State_constant = 4
                elif character == '.':
                    State_constant = 5
                elif character in 'lL':
                    State_constant = 9
                elif character in 'uU':
                    State_constant = 11
                else:
                    State_constant = -1
            elif State_constant == 2:
                if character.isdigit():
                    State_constant = 2
                elif character == '.':
                    State_constant = 5
                elif character in 'lL':
                    State_constant = 9
                elif character in 'uU':
                    State_constant = 11
            elif State_constant == 3:
                if character in 'aAbBcCdDeEfF' or character.isdigit():
                    State_constant = 14
            elif State_constant == 4:
                if character in '01234567':
                    State_constant = 4
                elif character in 'lL':
                    State_constant = 9
                elif character in 'uU':
                    State_constant = 11
                else:
                    State_constant = -1
            elif State_constant == 5:
                if character.isdigit():
                    State_constant = 6
            elif State_constant == 6:
                if character.isdigit():
                    State_constant = 6
                elif character in 'eE':
                    State_constant = 7
                elif character in 'fFlL':
                    State_constant = 15
                else:
                    State_constant = -1
            elif State_constant == 7:
                if character.isdigit():
                    State_constant = 6
                elif character == '-':
                    State_constant = 8
            elif State_constant == 8:
                if character.isdigit():
                    State_constant = 6
            elif State_constant == 9:
                if character in 'lL':
                    State_constant = 10
                elif character in 'uU':
                    State_constant = 12
                else:
                    State_constant = -1
            elif State_constant == 10:
                if character in 'uU':
                    State_constant = 13
                else:
                    State_constant = -1
            elif State_constant == 11:
                if character in 'lL':
                    State_constant = 12
                else:
                    State_constant = -1
            elif State_constant == 12:
                if character in 'lL':
                    State_constant = 13
                else:
                    State_constant = -1
            elif State_constant == 14:
                if character.isdigit() or character in 'aAbBcCdDeEfF':
                    State_constant = 14
                elif character in 'lL':
                    State_constant = 9
                elif character in 'uU':
                    State_constant = 11
                else:
                    State_constant = -1
            elif State_constant == 13 or State_constant == 15:
                if character:
                    State_constant = -1

            character = code[index]
            index = index + 1
            codeCol = codeCol + 1
        index = index - 1
        codeCol = codeCol - 1
        if State_constant in (1, 2, 4, 9, 10, 11, 12, 13, 14):
            codeType = 'integer constant'
            State_constant = 0
        elif State_constant == 6 or State_constant == 15:
            codeType = 'floating constant'
            State_constant = 0
        else:
            codeType = 'illegal constant'
            State_constant = 0

    # 界限符
    elif character in cDelimiter:
        codeValue = codeValue + character
        codeType = 'delimiter'

    # 运算符
    elif character in cOperator:
        global State_operator
        while character in cOperator:
            codeValue = codeValue + character
            if State_operator == 0:
                if not character in cBinaryOp:
                    State_operator = 20
                    break
                else:
                    if character == '+':
                        State_operator = 2
                    elif character == '-':
                        State_operator = 3
                    elif character == '<':
                        State_operator = 4
                    elif character == '>':
                        State_operator = 5
                    elif character == '=':
                        State_operator = 6
                    elif character == '!':
                        State_operator = 7
                    elif character == '&':
                        State_operator = 8
                    elif character == '|':
                        State_operator = 9
                    elif character == '*':
                        State_operator = 10
                    elif character == '/':
                        State_operator = 11
                    elif character == '%':
                        State_operator = 12
                    elif character == '^':
                        State_operator = 13
                    elif character == '#':
                        State_operator = 14
                    elif character == ':':
                        State_operator = 15
                    elif character == '.':
                        State_operator = 18

            elif State_operator == 1:
                break
            elif State_operator == 2:
                if character in '+=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 3:
                if character in '-=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 4:
                if character in '=:%':
                    State_operator = 1
                    break
                elif character == '<':
                    State_operator = 16
                else:
                    State_operator = -1
            elif State_operator == 5:
                if character in '=':
                    State_operator = 1
                    break
                elif character == '>':
                    State_operator = 17
                else:
                    State_operator = -1
            elif State_operator == 6:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 7:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 8:
                if character in '&=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 9:
                if character in '|=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 10:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 11:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 12:
                if character in '=>:':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 13:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 14:
                if character == '#':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 15:
                if character == '>':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 16:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 17:
                if character == '=':
                    State_operator = 1
                    break
                else:
                    State_operator = -1
            elif State_operator == 18:
                if character == '.':
                    State_operator = 19
                else:
                    State_operator = -1
            elif State_operator == 19:
                if character == '.':
                    State_operator = 1
                    break
                else:
                    State_operator = -1

            character = code[index]
            index = index + 1
            codeCol = codeCol + 1

        if State_operator >= 2 and State_operator <= 18:
            index = index - 1
            codeCol = codeCol - 1
            codeType = 'Unary operator'
            State_operator = 0
        elif State_operator == 20:
            codeType = 'Unary operator'
            State_operator = 0
        elif State_operator == 1:
            codeType = 'Multicast operator'
            State_operator = 0
        else:
            index = index - 1
            codeCol = codeCol - 1
            codeType = 'Illegal operator'
            State_operator = 0
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
