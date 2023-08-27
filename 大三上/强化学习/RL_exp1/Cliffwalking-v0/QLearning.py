import math
import numpy as np
from collections import defaultdict

class QLearning(object):
    def __init__(self, state_dim, action_dim, cfg):
        self.action_dim = action_dim 
        self.lr = cfg.lr  # 学习率
        self.gamma = cfg.gamma  
        self.epsilon = 0 
        self.sample_count = 0  
        self.epsilon_start = cfg.epsilon_start
        self.epsilon_end = cfg.epsilon_end
        self.epsilon_decay = cfg.epsilon_decay
        self.Q_table  = defaultdict(lambda: np.zeros(action_dim)) # 用字典存放状态->动作Q值的映射，即Q表
    
    def choose_action(self, state):
        self.sample_count += 1
        self.epsilon = self.epsilon_end + (self.epsilon_start - self.epsilon_end) * \
            math.exp(-1. * self.sample_count / self.epsilon_decay) # epsilon指数递减
        # epsilon贪心策略
        if np.random.uniform(0, 1) > self.epsilon:  # 若[0, 1]中的随机数>epsilon
            action = self.predict(state)    # 选择Q(s,a)最大对应的动作
        else:
            action = np.random.choice(self.action_dim) # 随机选择动作
        return action
    
    def predict(self, state):        # 预测
        action = np.argmax(self.Q_table[str(state)])    # 选择能让Q值最大的action
        return action
    
    def update(self, state, action, reward, next_state, done):  # 根据当前状态、动作、即时奖励、下一状态更新Q表
        Q_now = self.Q_table[str(state)][action] # Q(s, a)的值
        if done: # 终止状态
            Q_target = reward
        else:   # 非终止状态
            Q_target = reward + self.gamma * np.max(self.Q_table[str(next_state)]) # Q_target为目标策略的Q值*折扣因子+即时奖励
        self.Q_table[str(state)][action] += self.lr * (Q_target - Q_now)    # 迭代更新