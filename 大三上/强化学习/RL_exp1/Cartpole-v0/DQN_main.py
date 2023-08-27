from cProfile import label
import sys
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
import gym
import torch
from DQN import DQN

class Config:
    '''
        超参数类，进行超参数的设定和超参数值的设定
    '''
    def __init__(self, lr):
        self.env_name = 'CartPole-v0'
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")  # 若有安装cuda则优先在cuda上运行
        self.train_eps = 300  # 设置训练的回合数
        self.test_eps = 30  # 设置测试的回合数
        self.seed = 10  # 设置随机种子
        self.gamma = 0.99  # 折扣因子
        self.epsilon_start = 0.1  # e-贪心策略中初始值
        self.epsilon_end = 0.001  # e-贪心策略中的终止值
        self.epsilon_decay = 1000  # e-贪心策略中epsilon的衰减率
        self.lr = lr  # MLP的学习率
        self.memory_capacity = 500  # replay_buffer的容量
        self.batch_size = 64  # MBGD中的批量大小
        self.target_update = 4  # 目标网络的更新频率
        self.hidden_dim = 256  # 网络隐藏层神经元数


def create_env_agent(cfg):
    '''
        创建环境和智能体
        Args:
            cfg: Config类, 包含所有超参数
        Returns:
            env: 环境
            agent: 智能体
    '''
    env = gym.make(cfg.env_name)  # 创建环境
    state_dim = env.observation_space.shape[0]  # 状态维度
    action_dim = env.action_space.n  # 动作维度
    agent = DQN(state_dim, action_dim, cfg)  # 创建智能体
    if cfg.seed != 0: # 设置随机种子
        torch.manual_seed(cfg.seed) # 设置CPU生成随机数的种子 
        env.seed(cfg.seed)          # 设置环境的随机种子，利于实验的复现
        np.random.seed(cfg.seed)    # 设置numpy的随机种子
    return env, agent


def train(cfg, env, agent):
    '''
        训练
        Args:
            cfg: Config类, 包含所有超参数
            env: 环境, 在这里为Cliffwalking-v0
            agent: 智能体
        Returns:
            rewards: list, 为每一轮游戏智能体获得的奖励
            ma_rewards: list, 智能体获得平滑奖励(之前的*0.9+当前*0.1)
    '''
    print('Start training on ' + str(cfg.device))
    rewards = []  # 记录所有回合的奖励
    ma_rewards = [] # 记录平滑奖励
    for i_ep in range(cfg.train_eps):
        ep_reward = 0  # 记录一回合内的奖励
        state = env.reset()  # 重置环境，返回初始状态
        while True:
            action = agent.choose_action(state)  # 选择动作
            next_state, reward, done, _ = env.step(action)  # 更新环境，返回transition
            agent.memory.push(state, action, reward, next_state, done)  # 保存transition
            state = next_state  # 更新下一个状态
            agent.update()  # 更新智能体
            ep_reward += reward  # 累加奖励
            if done:
                break
        if (i_ep + 1) % cfg.target_update == 0:  # 智能体目标网络更新
            agent.target_net.load_state_dict(agent.policy_net.state_dict())
        rewards.append(ep_reward)
        if ma_rewards:
            ma_rewards.append(ma_rewards[-1] * 0.9 + ep_reward * 0.1)
        else:
            ma_rewards.append(ep_reward)
        if (i_ep + 1) % 10 == 0:
            print('episode: {}/{}, 奖励：{}'.format(i_ep + 1, cfg.train_eps, ep_reward))
    print('Finished training')
    env.close()
    return rewards, ma_rewards


def test(cfg, env, agent):
    '''
        测试
        Args:
            cfg: Config类, 包含所有超参数
            env: 环境, 在这里为CartPole-v0
            agent: 智能体
        Returns:
            rewards: list, 为每一轮游戏智能体获得的奖励
            ma_rewards: list, 智能体获得平滑奖励(之前的*0.9+当前*0.1)
    '''
    print('Start Testing')
    # 测试不需要epsilon
    cfg.epsilon_start = 0.0  
    cfg.epsilon_end = 0.0 
    rewards = []  # 记录所有回合的奖励
    ma_rewards = [] # 平滑奖励
    for i_ep in range(cfg.test_eps):
        ep_reward = 0  # 记录一回合内的奖励
        state = env.reset()  # 重置环境，返回初始状态
        while True:
            action = agent.choose_action(state)  # 选择动作
            next_state, reward, done, _ = env.step(action)  # 智能体与环境完成一次交互
            state = next_state  # 更新下一个状态
            ep_reward += reward  # 累加奖励
            if done:
                break
        rewards.append(ep_reward)
        if ma_rewards:
            ma_rewards.append(ma_rewards[-1] * 0.9 + ep_reward * 0.1)
        else:
            ma_rewards.append(ep_reward)
        print(f"episode: {i_ep+1}/{cfg.test_eps}，奖励：{ep_reward:.1f}")
    print('Finished Testing')
    env.close()
    return rewards, ma_rewards


if __name__ == "__main__":
    
    sns.set()
    plt.figure()
    plt.xlabel('epsiodes')
    
    for lr in [0.001, 0.005, 0.01, 0.02, 0.05, 0.08, 0.1, 0.15, 0.2, 0.3]:
        cfg = Config(lr)
        env, agent = create_env_agent(cfg)  # 创建agent和env
        rewards, ma_rewards = train(cfg, env, agent)  # 训练
        rewards, ma_rewards = test(cfg, env, agent) # 测试
        plt.plot(rewards, label = str(lr))

    plt.legend()
    plt.show()
    # 画图
    sns.set()
    plt.figure() 
    plt.xlabel('epsiodes')
    plt.plot(rewards, label='rewards')
    plt.plot(ma_rewards, label='ma rewards')
    plt.legend()
    plt.show()
    
    
    sns.set()
    plt.figure() 
    plt.xlabel('epsiodes')
    plt.plot(rewards, label='rewards')
    plt.plot(ma_rewards, label='ma rewards')
    plt.legend()
    plt.show()
    
