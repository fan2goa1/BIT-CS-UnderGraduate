import gym
import torch
import datetime
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
from QLearning import QLearning
from Sarsa import Sarsa
from gridworld_env import CliffWalkingWapper
from gridworld_env import FrozenLakeWapper

def ql_train(cfg, env, agent):
    '''
        训练qlearning模型
        Args:
            cfg: Config类, 包含所有超参数
            env: 环境, 在这里为Cliffwalking-v0
            agent: 智能体
        Returns:
            rewards: list, 为每一轮游戏智能体获得的奖励
    '''
    print('Training qlearning')
    rewards = []    # 记录奖励
    for i_ep in range(cfg.train_epi):
        tot_reward = 0  # 记录每一轮的奖励
        state = env.reset()  # 重置环境，开始新的一轮
        while True:
            action = agent.choose_action(state)  # 根据对应的算法选择一个动作
            next_state, reward, done, _ = env.step(action)  # 与环境进行一次交互
            agent.update(state, action, reward, next_state, done)  # 利用算法对应的公式进行更新
            state = next_state  # 将状态进行更新
            tot_reward += reward # 将当前获得的即时价值加进总奖励中
            if done:            # 如果游戏结束，则跳出循环结束这一轮
                break
        rewards.append(tot_reward)   # 将这一轮中智能体在游戏中获得的总奖励添加到列表中
        print("回合数：{}/{}，奖励{:.1f}".format(i_ep + 1, cfg.train_epi, tot_reward))    # 输出当前轮及获得的奖励
    print('Finished training qlearning')
    return rewards          # 返回每一轮获得的奖励的列表

def sarsa_train(cfg, env, agent):
    '''
        训练sarsa模型
        Args:
            cfg: Config类, 包含所有超参数
            env: 环境, 在这里为Cliffwalking-v0
            agent: 智能体
        Returns:
            rewards: list, 为每一轮游戏智能体获得的奖励
    '''
    print('Training sarsa')
    rewards = []    # 记录奖励
    for i_ep in range(cfg.train_epi):
        tot_reward = 0  # 记录每一轮的奖励
        state = env.reset()  # 重置环境，开始新的一轮
        action = agent.choose_action(state) # 根据对应的算法选择一个动作
        while True:
            next_state, reward, done, _ = env.step(action)  # 与环境进行一次交互
            if reward == -100:
                reward = -100000
            next_action = agent.choose_action(next_state)  # 根据对应的算法选择一个动作
            agent.update(state, action, reward, next_state, next_action, done)  # 利用算法对应的公式进行更新
            state = next_state  # 将状态进行更新
            action = next_action    # 更新当前动作
            tot_reward += reward # 将当前获得的即时价值加进总奖励中
            if done:            # 如果游戏结束，则跳出循环结束这一轮
                break
        rewards.append(tot_reward)   # 将这一轮中智能体在游戏中获得的总奖励添加到列表中
        print("回合数：{}/{}，奖励{:.1f}".format(i_ep + 1, cfg.train_epi, tot_reward))    # 输出当前轮及获得的奖励
    print('Finished training sarsa')
    return rewards          # 返回每一轮获得的奖励的列表

def test(cfg, env, agent):
    '''
        测试模型
        Args:
            cfg: Config类, 包含所有超参数
            env: 环境, 在这里为Cliffwalking-v0
            agent: 智能体
        Returns:
            rewards: list, 为每一轮游戏智能体获得的奖励
    '''
    print('Testing')
    rewards = []  # 记录所有回合的奖励
    for i_ep in range(cfg.test_epi):
        ep_reward = 0  # 记录每一轮的reward
        state = env.reset()  # 重置环境，开始新的一轮
        while True:
            action = agent.predict(state)  # 选择Q值最大的动作
            next_state, reward, done, _ = env.step(action)  # 与环境进行一次交互
            state = next_state  # 将状态进行更新
            ep_reward += reward # 将当前获得的即时价值加进总奖励中
            env.render()
            if done:            # 如果游戏结束，则跳出循环结束这一轮
                break
        rewards.append(ep_reward)   # 将这一轮中智能体在游戏中获得的总奖励添加到列表中
        print("回合数：{}/{}，奖励：{:.1f}".format(i_ep + 1, cfg.test_epi, ep_reward))    # 输出当前轮及获得的奖励
    print('Finished testing')
    return rewards          # 返回每一轮获得的奖励的列表

class Config:
    '''
        超参数类，进行超参数的设定和超参数值的设定
    '''
    def __init__(self):
        self.env_name = 'CliffWalking-v0'  # 环境名称
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")  # 若有安装cuda则优先在cuda上运行
        # self.seed = 10 # 设置随机种子，置0则不设置随机种子
        self.train_epi = 1000  # 设置训练的回合数
        self.test_epi = 1  # 设置测试的回合数
        
        self.gamma = 0.90  # 折扣因子
        self.epsilon_start = 0.2  # e-greedy策略中初始epsilon
        self.epsilon_end = 0.001  # e-greedy策略中的终止epsilon
        self.epsilon_decay = 100  # e-greedy策略中epsilon的衰减率
        self.lr = 0.05  # 学习率
    
class Train:
    def __init__(self, typ, cfg):
        '''
            Args:
                cfg: Config类
                type: 0表示qlearning 1表示Sarsa
        '''
        self.typ = typ
        self.cfg = cfg
            
    def create_env_agent(self, seed = 1):
        '''
            创建环境和智能体
            Args:
                cfg: Config类, 包含所有超参数
                seed: 随机种子, 默认为1
            Returns:
                env: 环境
                agent: 智能体
        '''
        self.env = gym.make(self.cfg.env_name)  # 设置环境
        if self.cfg.env_name == 'CliffWalking-v0':
            self.env = CliffWalkingWapper(self.env)
        self.env.seed(seed) # 设置随机种子
        self.state_dim = self.env.observation_space.n # 获得状态维度
        self.action_dim = self.env.action_space.n     # 获得动作维度
        self.test_func = test
        if self.typ == 0:
            self.agent = QLearning(self.state_dim, self.action_dim, self.cfg)   # 创建智能体，实例化QLearning类
            self.train_func = ql_train
        else :
            self.agent = Sarsa(self.state_dim, self.action_dim, self.cfg)   # 创建智能体，实例化Sarsa类
            self.train_func = sarsa_train

if __name__ == "__main__":
    cfg = Config()
    
    typ = int(input('Please choose the model: 0: qlearning     1: sarsa'))
    
    train_model = Train(typ, cfg)           # 实例化训练模型类
    
    # 训练
    train_model.create_env_agent(seed = 1)
    rewards = train_model.train_func(train_model.cfg, train_model.env, train_model.agent)
    
    sns.set()
    plt.figure()
    plt.xlabel('episode')
    plt.plot(rewards, label='rewards')
    plt.legend()
    plt.show()
    
    # 测试
    rewards = train_model.test_func(train_model.cfg, train_model.env, train_model.agent)
    
    act_list = []
    for i in range(48):
        act_list.append([i, np.argmax(train_model.agent.Q_table[str(i)])])
    A = np.array(act_list)
    data = pd.DataFrame(A)
    writer = pd.ExcelWriter('qtable.xlsx')		# 写入Excel文件
    data.to_excel(writer, 'page_1', float_format='%.3f') # 将data转为excel形式
    writer.save()
    writer.close()

