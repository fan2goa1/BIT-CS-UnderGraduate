# udt.py - Unreliable data transfer using UDP
import random

# Send a packet across the unreliable channel
# Packet may be lost
def send(packets, sock, addr, ErrorRate=0, LostRate=0, type='data'):
    if type != 'data':  # 发送如ack信号时，不会丢包
        sock.sendto(packets, addr)
        return
    
    if ErrorRate != 0 and random.randint(0, int(100/ErrorRate)) == 0:  # 出错帧
        errorArr = [0]
        packets = packets[0:-2] + bytes(0)  # 将check_sum的最后一个字节置为0
    if LostRate != 0 and random.randint(0, int(100/LostRate)) == 0: # 丢失帧
        return
    
    sock.sendto(packets, addr)
    return


# Receive a packet from the unreliable channel
def recv(sock, max_size=1029):
    packets, addr = sock.recvfrom(max_size)
    return packets, addr