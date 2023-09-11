import threading
import client
import configparser
import time

client1 = None
file_count = 0

def stop_threads():
    for thread in threading.enumerate():
        # 杀死线程
        thread.kill = True

    # 等待所有线程结束
    for thread in threading.enumerate():
        if thread != threading.current_thread():
            thread.join()

if __name__ == '__main__':
    '''
    读取配置文件Config.ini, 包含:
    host:
        error_rate
        loss_rate
        max_seq
        SWS
        timeout
    host1:
        port
    host2:
        port
    '''
    hostID = int(input('Enter your host ID(1 or 2):'))
    config_path = input('Enter the config file path: ') 
    config = configparser.ConfigParser()
    config.read(config_path)    # 读取配置文件
    
    host_port, host_port1 = None, None
    if hostID == 1:
        host_port = config.getint('host1', 'port')
        host_port1 = config.getint('host2', 'port')
    else :
        host_port = config.getint('host2', 'port')
        host_port1 = config.getint('host1', 'port')
    host_error_rate = config.getint('host', 'error_rate')
    host_loss_rate = config.getint('host', 'loss_rate')
    host_max_seq = config.getint('host', 'max_seq')
    host_SWS = config.getint('host', 'SWS')
    host_timeout = config.getfloat('host', 'timeout')

    # 创建发送对象和接收对象
    client1 = client.CLIENT(host_port, host_port1, host_timeout, host_max_seq, host_SWS, host_error_rate, host_loss_rate)
    
    recv_thread = threading.Thread(target=client1.receiver)
    recv_thread.start()

    # 输入文件路径并发送文件
    while True:
        stt = time.time()
        filename = input('Enter the file path(Auto receiving, Or enter \"q\" to quit): ')
        if filename == 'q':
            stop_threads()
            break
        client1.sender(filename)
        print('Time cost: ', time.time() - stt)