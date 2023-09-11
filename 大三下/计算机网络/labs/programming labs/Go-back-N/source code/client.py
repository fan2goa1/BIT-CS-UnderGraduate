import PDU
import socket
from timer import Timer
import time
import utils

'''
CLIENT类包含:
    My_Port: 本机端口
    Dest_Port: 目标端口
    timeout: 超时时间, 默认为0.03
    MAX_SEQ: 序列长度, 默认为8
    SWS: 窗口大小, 默认为5
    error_rate: 错误率, 默认为0
    lost_rate: 丢包率, 默认为0
'''
class CLIENT:
    def __init__(self, My_Port, Dest_Port, timeout=0.03, MAX_SEQ=8, SWS=5, error_rate=0, lost_rate=0):
        # 设置地址和端口
        self.MY_ADDR = ('localhost', My_Port)
        self.YOUR_ADDR = ('localhost', Dest_Port)
        # 设置序列长度和窗口大小
        self.MAX_SEQ = MAX_SEQ
        self.SWS = SWS
        # 设置错误率、丢包率
        self.error_rate = error_rate
        self.lost_rate = lost_rate

        # sender用
        self.send_timer = Timer(timeout)
        self.nowack = 0  # 目前需要确认的帧号，取值0 ~ num_packets
        self.is_sending = 0 # 是否正在发送
        self.next_frame_to_send = 0  # 要发的下一帧的帧号，取值0 ~ num_packets
        self.needRT = 0     # 是否需要重传
        self.needTO = 0     # 是否需要超时重传
        self.max_frame_ID = -1   # 当前传过的最大的帧号
        # receiver用
        self.frame_expected = 0  # 接收方当前要接受的序号，取值0 ~ MAX_SEQ-1
        self.recv_state = 0   # 当前状态，0表示等待文件传输 1表示正在进行文件传输

        # udp socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.bind(self.MY_ADDR)
        self.sock.settimeout(0.03)  # 设置获取Ack信号的超时时间
        # log file
        log_filepath = "log_for_" + str(My_Port) + ".txt"
        self.logger = open(log_filepath, 'w')   # 打开日志文件
        self.logCount = 1   # 日志编号

    def clrset(self): # 重置sender相关标识
        self.nowack = self.is_sending = self.next_frame_to_send = self.needRT = self.needTO = 0
        self.max_frame_ID = -1

    def set_window_size(self, num_packets): # 设置窗口大小，不能超过当前剩余的数据包数
        return min(self.SWS, num_packets-1 - self.nowack)

    def inc(self, num): # 序号自增1
        return (num+1) % self.MAX_SEQ

    def getSenderMsg(self): # 生成发送端的日志信息
        if self.needRT == 1:
            return f'{self.logCount},pdu_to_send={self.next_frame_to_send},status=RT,ackedNo={self.nowack}\n'
        elif self.needTO == 1:
            return f'{self.logCount},pdu_to_send={self.next_frame_to_send},status=TO,ackedNo={self.nowack}\n'
        else:
            return f'{self.logCount},pdu_to_send={self.next_frame_to_send},status=New,ackedNo={self.nowack}\n'

    def sender(self, filename):
        # 将要发送的文件拆分，存储到packets中
        packets = []
        try:
            file = open(filename, 'rb')
        except IOError:
            print('Cannot open file: ', filename)
            exit(0)

        self.is_sending = 1
        while True:
            data = file.read(1024) # 读取得到字节流，1024B为一个packet
            if not data:
                break
            packets.append(data)

        num_packets = len(packets)
        print('This file can be divided into ' + str(num_packets) + ' packets.')
        window_size = self.set_window_size(num_packets)

        # 循环发送数据包，直到数据包全部发出
        while self.nowack < num_packets:
            # 为数据包添加头部和校验位构成frame
            while self.next_frame_to_send < self.nowack + window_size and self.next_frame_to_send < num_packets:
                s = PDU.make(self.next_frame_to_send % self.MAX_SEQ, self.nowack % self.MAX_SEQ, 1, self.MAX_SEQ, packets[self.next_frame_to_send])
                utils.send(s, self.sock, self.YOUR_ADDR, self.error_rate, self.lost_rate)  # 发送数据包
                if self.next_frame_to_send > self.max_frame_ID:
                    self.max_frame_ID = self.next_frame_to_send
                    self.needTO = self.needRT = 0
                SendMsg = self.getSenderMsg()
                self.logger.write(SendMsg)
                self.logCount += 1
                self.next_frame_to_send += 1
                window_size = self.set_window_size(num_packets)  # 防止packets越界
            
            # 窗口达到右边沿，打开计时器
            if not self.send_timer.running():
                # print('start timer')
                self.send_timer.start()

            flag = 0    # 判断是否有收到Ack/Dek
            # 等待计时器超时或收到Ack
            while self.send_timer.running() and not self.send_timer.timeout():
                if(self.next_frame_to_send < self.nowack + window_size or self.needRT == 1):
                    flag = 1
                    break
                time.sleep(0.01)

            if flag == 1:
                self.send_timer.stop()
                if self.needRT == 1:    # 如果需要重传，则需要重置next_frame_to_send
                    self.next_frame_to_send = self.nowack
                continue
            
            # 计时器超时，需要重发
            if self.send_timer.timeout():
                self.send_timer.stop()
                self.needTO = 1
                self.next_frame_to_send = self.nowack
        utils.send(b'', self.sock, self.YOUR_ADDR, self.error_rate, self.lost_rate)  # 用于表示发送结束
        # print('already sent')
        self.clrset()   # 重置相关标识
        return

    def get_Ack(self):  # 获取接收方发来的Ack信号
        flag = 0
        while True:
            while self.is_sending == 1:
                flag = 1
                try:
                    _pkt, addr = utils.recv(self.sock, 3)
                    seq, ack, data_value = PDU.extract_header(_pkt) # 解析header
                    if data_value == 1:     # 如果是数据包则跳过
                        continue
                    pkt, addr = utils.recv(self.sock, 2)  # 接收查看是否有ack/dek信号
                    # print(seq, ack, data_value, data, check_sum)
                    if seq == 0 and data_value == 0:  # 说明收到了ack信号
                        # print('Receive ACK of packet No.', self.nowack)
                        self.nowack += 1
                    elif seq == 1 and ack == self.nowack and data_value == 0: # 说明DataError
                        self.needRT = 1
                except socket.error:
                    continue
            if flag == 1 and self.is_sending == 0:
                break
        return 
    
    def receiver(self):
        file_count = 0
        file = None     # 文件对象
        while True:
            try:
                pkt, addr = utils.recv(self.sock, 1029)
            except:
                continue

            if not pkt:  # 所有数据包全部被接收
                file.close()  # 关闭文件
                self.recv_state = 0     # 更改当前的状态为接收完毕
                self.frame_expected = 0 # 重置期望接受帧号
                continue
            
            # if self.recv_state == 0:
            #     print(pkt[0], pkt[1], pkt[2])

            seq, ack, data_value, data, check_sum = PDU.extract(pkt) # 解析
            if data_value == 0:     # 如果不是数据包，则为ACK，NAK信号
                if seq == 0 and data_value == 0:  # 说明收到了ack信号
                    # print('Receive ACK of packet No.', self.nowack)
                    self.nowack += 1
                elif seq == 1 and ack == self.nowack and data_value == 0: # 说明DataError
                    self.needRT = 1
                continue
            elif data_value == 1 and self.recv_state == 0:   # 如果是接收的该文件的第一个数据包
                self.recv_state = 1     # 更改当前的状态为正在接收
                file = open(f'copy_from_{self.YOUR_ADDR[1]}_{file_count}.txt', 'wb') # 创建接收文件
                file_count += 1

            # print(seq, ack ,data_value)
            # 否则为数据包
            # 对收到包进行冗余校验，如果检查包有问题直接丢包
            rev_check_sum = PDU.CRCCCITT(pkt[:-2])
            # print(seq, self.frame_expected)
            if seq != self.frame_expected:  # 说明收到的包序号不对，有丢包
                # print(seq, self.frame_expected)
                NoErrorMsg = f'{self.logCount},pdu_exp={self.frame_expected},pdu_recv={seq},status=NoErr\n'
                self.logger.write(NoErrorMsg)
                self.logCount += 1
            
            elif rev_check_sum == check_sum:    # 说明收到的包的数据没有问题
                self.frame_expected = self.inc(self.frame_expected)
                pkt_ack = PDU.make(0, self.frame_expected, 0, self.MAX_SEQ)  # data段为空,data_value为0
                utils.send(pkt_ack, self.sock, self.YOUR_ADDR, type='ack')
                file.write(data)
                OKMsg = f'{self.logCount},pdu_exp={seq},pdu_recv={seq},status=OK\n'
                self.logger.write(OKMsg)
                self.logCount += 1

            else:   # 说明收到的包的数据有问题
                # print(rev_check_sum, check_sum)
                pkt_dek = PDU.make(1, self.frame_expected, 0, self.MAX_SEQ)
                utils.send(pkt_dek, self.sock, self.YOUR_ADDR, type='dek')
                DataErrorMsg = f'{self.logCount},pdu_exp={self.frame_expected},pdu_recv={seq},status=DataErr\n'
                self.logger.write(DataErrorMsg)
                self.logCount += 1
        return