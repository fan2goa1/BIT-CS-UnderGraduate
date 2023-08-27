import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math



cart1_pd = pd.read_csv("1.csv")
cart2_pd = pd.read_csv("2.csv")
cart3_pd = pd.read_csv("3.csv")
cart4_pd = pd.read_csv("4.csv")
cart5_pd = pd.read_csv("5.csv")
cart6_pd = pd.read_csv("6.csv")
cart7_pd = pd.read_csv("7.csv")

cart1_np = np.array(cart1_pd)
cart2_np = np.array(cart2_pd)
cart3_np = np.array(cart3_pd)
cart4_np = np.array(cart4_pd)
cart5_np = np.array(cart5_pd)
cart6_np = np.array(cart6_pd)
cart7_np = np.array(cart7_pd)

cart1 = [i for line in cart1_np for i in line]
cart2 = [i for line in cart2_np for i in line]
cart3 = [i for line in cart3_np for i in line]
cart4 = [i for line in cart4_np for i in line]
cart5 = [i for line in cart5_np for i in line]
cart6 = [i for line in cart6_np for i in line]
cart7 = [i for line in cart7_np for i in line]

min_len = min(len(cart1), len(cart2), len(cart3), len(cart4), len(cart5), len(cart6), len(cart7))


cart1 = [cart1[i] for i in range(len(cart1)-min_len,len(cart1))]
cart2 = [cart2[i] for i in range(len(cart2)-min_len,len(cart2))]
cart3 = [cart3[i] for i in range(len(cart3)-min_len,len(cart3))]
cart4 = [cart4[i] for i in range(len(cart4)-min_len,len(cart4))]
cart5 = [cart5[i] for i in range(len(cart5)-min_len,len(cart5))]
cart6 = [cart6[i] for i in range(len(cart6)-min_len,len(cart6))]
cart7 = [cart7[i] for i in range(len(cart7)-min_len,len(cart7))]


# cart1_1 = [(cart1[i]*0.9+cart1[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_2 = [(cart2[i]*0.9+cart2[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_3 = [(cart3[i]*0.9+cart3[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_4 = [(cart4[i]*0.9+cart4[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_5 = [(cart5[i]*0.9+cart5[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_6 = [(cart6[i]*0.9+cart6[i+1]*0.1) for i in range(0 , min_len-2)]
# cart1_7 = [(cart7[i]*0.9+cart7[i+1]*0.1) for i in range(0 , min_len-2)]
# cart2_1 = [(cart1_1[i]+cart1_1[i+1])/2 for i in range(0 , min_len-3)]
# cart2_2 = [(cart1_2[i]+cart1_2[i+1])/2 for i in range(0 , min_len-3)]
# cart2_3 = [(cart1_3[i]+cart1_3[i+1])/2 for i in range(0 , min_len-3)]
# cart2_4 = [(cart1_4[i]+cart1_4[i+1])/2 for i in range(0 , min_len-3)]
# cart2_5 = [(cart1_5[i]+cart1_5[i+1])/2 for i in range(0 , min_len-3)]
# cart2_6 = [(cart1_6[i]+cart1_6[i+1])/2 for i in range(0 , min_len-3)]
# cart2_7 = [(cart1_7[i]+cart1_7[i+1])/2 for i in range(0 , min_len-3)]
cart1_sm, cart2_sm, cart3_sm, cart4_sm, cart5_sm, cart6_sm, cart7_sm =\
    [0]*min_len, [0]*min_len, [0]*min_len, [0]*min_len, [0]*min_len, [0]*min_len, [0]*min_len
print(min_len)
for i in range(min_len):
    if i == 0:
        cart1_sm[i] = cart1[i]
        cart2_sm[i] = cart2[i]
        cart3_sm[i] = cart3[i]
        cart4_sm[i] = cart4[i]
        cart5_sm[i] = cart5[i]
        cart6_sm[i] = cart6[i]
        cart7_sm[i] = cart7[i]
    else :
        print(i)
        cart1_sm[i] = cart1_sm[i - 1] * 0.8 + cart1[i] * 0.2
        cart2_sm[i] = cart2_sm[i - 1] * 0.8 + cart2[i] * 0.2
        cart3_sm[i] = cart3_sm[i - 1] * 0.8 + cart3[i] * 0.2
        cart4_sm[i] = cart4_sm[i - 1] * 0.8 + cart4[i] * 0.2
        cart5_sm[i] = cart5_sm[i - 1] * 0.8 + cart5[i] * 0.2
        cart6_sm[i] = cart6_sm[i - 1] * 0.8 + cart6[i] * 0.2
        cart7_sm[i] = cart7_sm[i - 1] * 0.8 + cart7[i] * 0.2

sns.set()
plt.rcParams['font.sans-serif'] = 'SimHei'
plt.figure()
plt.plot(cart7_sm, color = 'black', label = '深度Q网络')
plt.plot(cart2_sm, color = 'purple', label = '双深度Q网络')
plt.plot(cart4_sm, color = 'blue', label = '优先级经验回放双深度Q网络')
plt.plot(cart1_sm, color = 'red', label = '竞争双深度Q网络')
plt.plot(cart3_sm, color = 'orange', label = '噪声深度Q网络')
plt.plot(cart6_sm, color = 'pink', label = '分布式深度Q网络')
plt.plot(cart5_sm, color = 'green', label = '彩虹')
plt.legend()
plt.show()