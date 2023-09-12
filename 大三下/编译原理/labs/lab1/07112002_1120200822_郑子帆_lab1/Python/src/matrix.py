import time

# 读取矩阵A
with open('A.txt', 'r') as file:
    lines = file.readlines()
    MatA = [list(map(int, line.split())) for line in lines]
# 读取矩阵B
with open('B.txt', 'r') as file:
    lines = file.readlines()
    MatB = [list(map(int, line.split())) for line in lines]
st = time.time()
# 矩阵乘法
MatC = [[sum(a * b for a, b in zip(row_a, col_b)) for col_b in zip(*MatB)] for row_a in MatA]
ed = time.time()
# 写出矩阵C
with open('C_py.txt', 'w') as file:
    for row in MatC:
        file.write(' '.join(map(str, row)) + '\n')

print("total running time: %.3fs" % (ed - st))
