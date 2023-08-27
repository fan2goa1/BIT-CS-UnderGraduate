from turtle import color, done
import gym
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd


env = gym.make('CartPole-v0')

max_steps = 200   # 最多保持200ms，然后结束游戏

num_ep = 1000 # 游戏轮数设置


# q_table是一个256*2的二维数组
# 观测的4个值我们分别线性离散化成0~3中的一个数值；离散化后的状态共有4^4=256个状态
Q_table = np.random.uniform(low=-1, high=1, size=(4 ** 4, env.action_space.n))  # 用等分随机化Q表格

# 分箱处理函数，将对应区间等分成num份
def bins(clip_min, clip_max, num):
    return np.linspace(clip_min, clip_max, num + 1)[1:-1]

# 离散化处理，将由4个连续特征值组成的状态矢量转换为一个0~~255的整数离散值
def lisan_state(observation):
    cart_pos, cart_v, pole_angle, pole_v = observation
    # 分别对各个连续特征值进行离散化（分箱处理）
    digitized = [np.digitize(cart_pos, bins=bins(-2.4, 2.4, 4)),
                 np.digitize(cart_v, bins=bins(-3.0, 3.0, 4)),
                 np.digitize(pole_angle, bins=bins(-0.5, 0.5, 4)),
                 np.digitize(pole_v, bins=bins(-2.0, 2.0, 4))]
    # 将4个离散值再组合为一个离散值，具体计算方式为将4个观测值离散化后简单hash(*4^i)
    return sum([x * (4 ** i) for i, x in enumerate(digitized)])

# 根据本次的行动及其反馈（下一个时间步的状态），返回下一次的最佳行动
def get_action(state, action, observation, reward, epsilon):
    next_state = lisan_state(observation)    # 获取下一个时间步的状态，并将其离散化
    next_action = np.argmax(Q_table[next_state])    # 查表得到最佳行动
    alpha = 0.1     # 学习率
    gamma = 0.90     # 折扣因子
    if np.random.uniform(0, 1) <= epsilon:  # 若[0, 1]中的随机数<epsilon，则选择随机动作
            next_action = np.random.choice([0, 1]) # 随机选择动作
    Q_table[state, action] += alpha * (reward + gamma * Q_table[next_state, next_action] - Q_table[state, action])
    return next_action, next_state

def run_ep(eps, done_reward, type):
    rewards = []    # 每轮游戏的得分列表
    epsilon = 0.2
    epsilon_decay = 0.98   # epsilon衰减率0.98 ε(t+1) = ε(t) * 0.98
    for i_ep in range(eps):
        observation = env.reset()   # 初始化本场游戏的环境
        state = lisan_state(observation)     # 获取初始状态值
        action = np.argmax(Q_table[state])      # 根据状态值作出行动决策
        tot_reward = 0
        for t in range(max_steps):
            if type == 'test':
                env.render()            # 如果是测试，展现渲染图像
            observation, reward, done, info = env.step(action)  # 获取本次行动的反馈结果
            if done:
                reward = done_reward
            action, state = get_action(state, action, observation, reward, epsilon)  # 作出下一次行动的决策
            epsilon *= epsilon_decay
            tot_reward += reward
            if done:
                rewards.append(tot_reward)
                print('Episode %d/%d: %f time steps' % (i_ep, eps, t + 1))
                break
    return rewards

if __name__ == '__main__':
    rewards = []
    done_reward = 1
    i_ep = [i for i in range(num_ep)]
    rewards = run_ep(num_ep, done_reward, type = 'train')    # 训练
    
    # 调整回合结束时的一步奖励为-1000，重新训练
    done_reward = -1000
    Q_table = np.random.uniform(low=-1, high=1, size=(4 ** 4, env.action_space.n))  # 用等分随机化Q表格
    rewards_2 = run_ep(num_ep, done_reward, type = 'train')    # 再次训练
    rewards_2 = [i - done_reward for i in rewards_2]
    
    # 画散点图
    sns.set()
    plt.figure()
    plt.xlabel('episode')
    plt.scatter(i_ep, rewards, color = 'b')
    plt.scatter(i_ep, rewards_2, color = 'r')
    plt.legend()
    plt.show()
    
    # rewards = run_ep(10, type = 'test')
    # tot = 0
    # for i in rewards:
    #     tot += i
    # tot = tot / 10
    # print("Average test time: " + str(tot) + "ms")
    