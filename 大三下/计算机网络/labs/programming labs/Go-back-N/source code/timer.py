# timer.py - A timer class
import time


class Timer(object):
    defaultT = -1 # 默认的时间戳
    # 初始化计时器
    def __init__(self, duration):
        self.stTime = self.defaultT
        self.edTime = duration
    # 开始计时
    def start(self):
        if self.stTime == self.defaultT:
            self.stTime = time.time()
    # 停止计时
    def stop(self):
        if self.stTime != self.defaultT:
            self.stTime = self.defaultT

    # 判读计时器是否在counting
    def running(self):
        return self.stTime != self.defaultT
    # 判断是否超时
    def timeout(self):
        if not self.running():
            return False
        else:
            return time.time() - self.stTime >= self.edTime
