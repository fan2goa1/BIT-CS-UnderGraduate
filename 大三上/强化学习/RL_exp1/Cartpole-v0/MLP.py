import gym
import numpy as np
import torch
from torch import nn
from torch import optim
import matplotlib.pyplot as plt
import seaborn as sns

class MLP(nn.Module):
    def __init__(self, input_dim, hid_dim1, hid_dim2, output_dim):
        super(MLP, self).__init__()
        
        self.layer = nn.Sequential(
          nn.Linear(input_dim, hid_dim1),
          nn.ReLU(),
          nn.Linear(hid_dim1, hid_dim2),
          nn.ReLU(),
          nn.Linear(hid_dim2, output_dim),
          nn.ReLU()
        )
        
    def forward(self, x):
        x = self.layer(x)
        return x

def run_one_episode(env):
    '''
        生成单次游戏的训练数据
    '''
    X, Y, score = [], [], 0
    obs = env.reset()
    while True:
        action = env.action_space.sample()
        X.append(obs)
        Y.append([1, 0] if action == 0 else [0, 1])
        obs, reward, done, info = env.step(action)
        score += reward
        if done:
            break
    return X, Y, score

def get_train_data(env, expected_score=100):
    '''
        生成N次游戏的训练数据, 并选择 > 100 的数据作为训练集
    '''
    data_X, data_Y, scores = [], [], []
    for i in range(100000):
        X, Y, score = run_one_episode(env)  # 智能体随机动作进行一次游戏
        # 如果这轮游戏得分超过我们的预期得分，则作为训练数据
        if score > expected_score:          
            data_X += X
            data_Y += Y
            scores.append(score)
    print('dataset size: {}'.format(len(data_X)))
    return np.array(data_X), np.array(data_Y)

def train(train_epoch, model, lr, data_X, data_Y):
    '''
        训练模型，梯度下降
    '''
    loss = []
    get_loss = nn.CrossEntropyLoss()        # loss函数选用交叉熵函数
    optimizer = optim.SGD(params = model.parameters(), lr = lr) # 优化器选用SGD优化器
    for idx in range(train_epoch):
        pred_y = model(data_X)      # MLP预测
        optimizer.zero_grad()       # 梯度清零
        tot_loss = get_loss(pred_y, data_Y)
        loss.append(tot_loss.sum().item())
        tot_loss.backward()     # loss反向传播
        optimizer.step()        # 优化器迭代更新参数
    return loss

def test(test_epoch, env, model):
    '''
        测试智能体的游玩效果
    '''
    scores = []
    with torch.no_grad():
        for _ in range(test_epoch):
            obs = env.reset()
            score = 0
            while True:
                env.render()   # 显示画面
                input = torch.tensor(np.float32(np.array([obs])))
                output = model(input)[0]  # 放入网络得到输出
                action = int(output.argmax())  # 根据网络的输出预测动作
                obs, reward, done, info = env.step(action)  # 执行这个动作
                score += reward     # 每回合的得分
                if done:       # 游戏结束
                    scores.append(score)
                    break
                    
    return scores

if __name__  == '__main__':
    
    state_dim, action_dim = 4, 2
    lr = 0.1
    train_epoch = 5000
    test_epoch = 100

    env = gym.make("CartPole-v0")
    data_X, data_Y = get_train_data(env)
    model = MLP(state_dim, 256, 256, action_dim)
    
    loss = train(train_epoch, model, lr, torch.tensor(np.float32(data_X)), torch.tensor(np.float32(data_Y)))
    scores = test(test_epoch, env, model)
    train_epochs = [i + 1 for i in range(train_epoch)]
    test_epochs = [i + 1 for i in range(test_epoch)]
    env.close()
    
    sns.set()
    plt.figure()
    plt.xlabel('epoch')
    plt.ylabel('score')
    plt.plot(test_epochs, scores)
    plt.legend()
    plt.show()