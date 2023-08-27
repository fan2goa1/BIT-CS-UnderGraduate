import gym
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def policy_improvement(env, V, old_policy, policy_stable = True):   # 策略改进，根据Q值重选策略
    obs_dim = env.observation_space.n
    act_dim = env.action_space.n
    policy = np.zeros(obs_dim)
    for s in range(obs_dim):
        old_action = policy[s]
        q_value = np.zeros(act_dim)
        for action in range(act_dim):
            for p, next_state, reward, done in env.env.P[s][action]:
                q_value[action] += p * (reward + V[next_state]) # 利用更新完的V函数计算Q值
        policy[s] = np.argmax(q_value)  # 选出当前状态下Q值最大的动作作为新的策略
        if policy[s] != old_policy[s]:  # 如果策略收敛，退出
            policy_stable = False

    return policy, policy_stable

def policy_evaluation(env, theta, V, policy):   #策略评估，并更新V函数
    obs_dim = env.observation_space.n
    act_dim = env.action_space.n
    while True:
        delta = 0
        old_V = np.copy(V)
        for s in range(obs_dim):                # 枚举状态
            action = policy[s]                  # 当前决策的动作
            v = 0
            for p, next_state, reward, done in env.env.P[s][action]:    # 枚举不同状态之间转移的概率
                v += p * (reward + old_V[next_state])   # 计算当前状态在决策动作下获得的价值的期望
            V[s] = v                            # 更新V函数
            if delta < abs(V[s] - old_V[s]):
                delta = abs(V[s] - old_V[s])
        if delta < theta:
            print(V)
            return V

def policy_Iteration(env, theta):   # 策略迭代主函数
    theta = theta                   # 设置theta值
    print("theta: " + str(theta))
    obs_dim = env.observation_space.n
    act_dim = env.action_space.n
    policy = np.zeros(obs_dim)  # 初始化policy
    V = np.zeros(obs_dim)       # 初始化V函数
    iteration_epoch = 0
    while True:
        iteration_epoch += 1
        V = policy_evaluation(env = env, theta = theta, V = V, policy = policy)     # 策略评估
        new_policy, policy_stable = policy_improvement(env = env, V = V, old_policy = policy)   # 策略改进

        if policy_stable:      # 如果相邻两次策略相同，说明收敛，结束
            return iteration_epoch, new_policy
        else :                 # 否则继续迭代
            policy = new_policy

def run_episode(env, policy, render = False):   # 智能体玩一次游戏
    obs = env.reset()
    total_reward = 0
    step_idx = 0
    while True:
        if render:
            env.render()
        obs, reward, done, _ = env.step(int(policy[obs]))   # 按照学习好的策略与环境交互
        total_reward += reward
        step_idx += 1
        if done:
            break
    return total_reward
        
def test(env, policy, n = 100):
    scores = [run_episode(env, policy) for _ in range(n)]
    return scores

if __name__ == "__main__":
    env = gym.make("FrozenLake-v1")
    env.reset()
    
    eplist = [i + 1 for i in range(15)]
    avg_reward = []
    iter_epoch = []
    
    theta_list = []
    base = 0.1
    for i in range(15):
        theta_list.append(base * 0.1)
        base *= 0.1
    
    for theta in theta_list:
        iteration_epoch, new_policy = policy_Iteration(env, theta)
        scores = test(env, new_policy)
        print(new_policy)
        print('Average scores = ', np.mean(scores))
        avg_reward.append(np.mean(scores))
        iter_epoch.append(iteration_epoch)
    
    sns.set()
    plt.figure()
    plt.xlabel('theta\'s ep')
    plt.ylabel('average_reward')
    plt.ylim(0, 1)
    plt.plot(eplist, avg_reward)
    plt.legend()
    plt.show()
    
    sns.set()
    plt.figure()
    plt.xlabel('theta\'s ep')
    plt.ylabel('iteration epoch')
    plt.ylim(0, 10)
    plt.plot(eplist, iter_epoch)
    plt.legend()
    plt.show()
    