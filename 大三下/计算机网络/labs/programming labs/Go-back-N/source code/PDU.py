import socket

def CRCCCITT(bitstr):
    loc = [16, 12, 5, 0]
    p = [0 for i in range(17)]
    for i in loc:
        p[16 - i] = 1   # 反转，p[0]表示16次方，以此类推
    # print(p)
    info_list = []
    for xstr in bitstr:
        bin_s = bin(xstr).replace('0b', '') # 得到每个字节的二进制串
        bin_s_len = len(bin_s)
        for i in range(8 - bin_s_len):  # 不够8位的补0
            info_list.append(0)
        for j in bin_s:
            info_list.append(int(j))
    bitstr = info_list.copy()
    strlen = len(bitstr)

    for i in range(16):
        bitstr.append(0)    # 在最后补16个0

    for i in range(strlen):
        if bitstr[i] == 1:
            for j in range(17):
                bitstr[j + i] = bitstr[j + i] ^ p[j]
    check_code = bitstr[-16::]  # 取最后16位
    check_sum = 0
    for i in range(16): # 将16位转换为十进制
        check_sum = check_sum * 2 + check_code[i]
    return check_sum

'''
制作PDU 包括header、data、trailer
header包括 发送方frame编号(seq_byte) 接收方期望接受到的frame编号(ack_byte) 是否有数据(data_value_byte)
trailer包括checksum(2 bytes)
'''
def make(frame_nr, frame_expected, data_value, MAX_SEQ, data=b''):
    seq = frame_nr % MAX_SEQ    # frame编号
    seq_byte = seq.to_bytes(1, byteorder='big', signed=False)  # frame编号转换为byte
    ack = frame_expected % MAX_SEQ  # ack编号
    ack_byte = ack.to_bytes(1, byteorder='big', signed=False)  # ack编号转换为byte
    data_value_byte = data_value.to_bytes(1, byteorder='big', signed=False)    # data_value转换为byte
    header = seq_byte + ack_byte + data_value_byte# frame头部
    checksum = CRCCCITT(header + data)      # 计算checksum（按照CRCCCITT标准）
    checksum = checksum.to_bytes(2, byteorder='big', signed=False)  # checksum转换为byte
    trailer = checksum  # frame尾部
    return header + data + trailer

def extract(packet):    # 解析一个数据包
    seq = packet[0] # 第一个字节为seq
    ack = packet[1] # 第二个字节为ack
    data_value = packet[2]  # 第三个字节为data_value
    data = packet[3:-2]
    checksum = int.from_bytes(packet[-2:], byteorder='big', signed=False)
    return seq, ack, data_value, data, checksum

if __name__ == '__main__':
    frame = make(0, 1, 1, 8, b'I like computer network\'s homework')
    print(frame.hex())

    # print("test of bitstr\'123456789\'")
    # print(CRCCCITT(b'123456789'))