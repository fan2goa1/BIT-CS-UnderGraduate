## 一、实验目的

本实验目的是加强学生对位级运算的理解及熟练使用的能力。

## 二、报告要求

本报告要求学生把实验中实现的所有函数逐一进行分析说明，写出实现的依据，也就是推理过程，可以是一个简单的数学证明，也可以是代码分析，根据实现中你的想法不同而异。

## 三、函数分析

### 1. bit-level函数

(1) bitXor函数

**函数要求：**

函数名 | bitXor
-|-
参数 | int x, int y 
功能实现 | x与y的异或和 
要求 | 只能使用 ~ 和 &, 最多使用14个操作符 

**实现分析：**

当x=y时，值为0；相反，值为1.

根据离散数学中所学过的知识，$a⊕b = (¬a ∧ b) ∨ (a ∧¬b)$，利用德摩根定律，将析取换成合取即可。

**函数实现：**

```C
int bitXor(int x, int y) {
  return ~(x & y) & ~(~x & ~y);
}
```

(2) getByte函数

**函数要求：**

| 函数名   | getByte                                       |
| -------- | --------------------------------------------- |
| 参数     | int x, int n                                  |
| 功能实现 | 导出x的第n个字节的值                          |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用6个操作符 |

**分析：**

将x右移n*8位后取出低8位的值即为答案。

**函数实现：**

```c
int getByte(int x, int n) {
  int ans = 0;
  ans = (x >> (n << 3)) & 0xff;
  return ans;
}
```

(3) logicalShift函数

**函数要求：**

函数名 | logicalShift 
-|-
参数 |int x, int n
功能实现 |x逻辑右移n位的值
要求 |只能使用! ~ & ^ \| + << >>, 最多使用20个操作符

**分析：**

对int型数直接使用>>是算术右移。逻辑右移即高位补0。

不考虑x的符号位，即先假设x为正数，那么其算术右移与逻辑右移等价，此时得到一个中间结果tmp。

现在考虑x的符号位右移产生的影响。若x为负数，则第31位的1被移到了第(31 - n)位上，构造一个其他位均为0，第(31-n)位为1的数与tmp按位或即为答案。

**函数实现：**

```C
int logicalShift(int x, int n) {
  int ans = 0;
  ans = ((x & ~(1 << 31)) >> n) | ((1 & (x >> 31)) << (31 + (~n + 1)));
  return ans;
}
```

(4) bitCount函数

**函数要求：**

| 函数名   | bitCount                                       |
| -------- | ---------------------------------------------- |
| 参数     | int x                                          |
| 功能实现 | 计算x中1的位数                                 |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用40个操作符 |

**分析：**

本题使用分治合并的思想，我们先算出来每两个相邻位1的个数。

举个例子，假设x的低8位为01101101，那么我们给它两两分组得到01 10 11 01，计算每组里面1的个数，得到中间结果tmp1=01 01 10 01。为实现这一过程，我们构造掩码mask1=01 01 01 01，(x & mask1) + ((x >> 1) & mask1)即为我们想要得到的tmp1。

得到每相邻两个位置的1的个数后，我们将tmp1每四个分一组，进一步合并得到每相邻4个一组的1的个数，具体做法构造mask2=0011 0011，(tmp1 & mask2) + ((tmp1 >> 2) & mask2)即为我们想要的每相邻四个的1的个数。

以此类推，依次合并每相邻8个一组，16个一组，32个一组的1的个数，即可得到ans。

**函数实现：**

```c
int bitCount(int x){
  int _mask1 = (0x55)|(0x55<<8);
  int _mask2 = (0x33)|(0x33<<8);
  int _mask3 = (0x0f)|(0x0f<<8);
  int mask1 = _mask1|(_mask1<<16);
  int mask2 = _mask2|(_mask2<<16);
  int mask3 = _mask3|(_mask3<<16);
  int mask4 = (0xff)|(0xff<<16);
  int mask5 = (0xff)|(0xff<<8);

  int ans = (x & mask1) + ((x>>1) & mask1);
  ans = (ans & mask2) + ((ans>>2) & mask2);
  ans = (ans & mask3) + ((ans>>4) & mask3);
  ans = (ans & mask4) + ((ans>>8) & mask4);
  ans = (ans & mask5) + ((ans>>16) & mask5);

  return ans;
}
```

(5) conditional函数

**函数要求：**

| 函数名   | Conditional                                    |
| -------- | ---------------------------------------------- |
| 参数     | int x, int y, int z                            |
| 功能实现 | 返回(x ? y : z)                                |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用16个操作符 |

**分析：**

构造两个掩码con1，con2。

当x为0时，con1=0x00000000，con2=0xffffffff；

当x不为0时，con1=0xffffffff，con2=0x00000000。

通过观察可以发现con1，con2二者互为取反。ans即为(y & con1) | (z & con2)。

**函数实现：**

```c
int conditional(int x, int y, int z) {
  int pd = !!x;
  int con1 = (pd << 31) >> 31;
  int con2 = ~con1;
  int ans = (con1 & y) | (con2 & z);
  return ans;
}
```

### 2. two's complement

(1) tmin函数

**函数要求：**

| 函数名   | Tmin                                          |
| -------- | --------------------------------------------- |
| 参数     |                                               |
| 功能实现 | 返回补码值最小的数                            |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用4个操作符 |

**分析：**

概念题，k位补码的表示范围为$[-2^{k-1}, 2^{k-1}-1]$，分别对应1000...00和0111...11。

**函数实现：**

```c
int tmin(void) {
  return (1 << 31);
}
```

(2) fitsBits函数

**函数要求：**

| 函数名   | fitsBits                                       |
| -------- | ---------------------------------------------- |
| 参数     | int x, int n                                   |
| 功能实现 | 如果x能用n位补码表示，返回1；否则返回0         |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用15个操作符 |

**分析：**

利用性质：若x能用n为补码表示，那么x左移(32-n)位再右移(32-n)位与原来相等（因为右移补的是符号位，如果左移时丢弃了“有用的”1或者丢弃了“有用的”0都会导致算数右移后值发生改变）。

**函数实现：**

```c
int fitsBits(int x, int n) {
  int p = 32 + (~n + 1);
  int cg = (x << p) >> p;
  int ans = !(x ^ cg);
  return ans;
}
```

(3) dividePower2函数

**函数要求：**

| 函数名   | dividePower2                                   |
| -------- | ---------------------------------------------- |
| 参数     | int x, int n                                   |
| 功能实现 | 计算$\frac{x}{2^n}$，并向0取整                 |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用15个操作符 |

**分析：**

由书上第73页可知，$\frac{x}{2^{n}}$向上取整为(x + (1 << n) - 1) >> n。其中偏置bias=(1 << n) - 1。因为是向0取整，故当x为正数时bias=0；x为负数时bias=(1 << n) - 1。最终答案ans=(x+bias) >> n。

**函数实现：**

```c
int dividePower2(int x, int n) {
    int mask = (x >> 31);
    int bias = ((1 << n) + (~1 + 1)) & mask;
    int ans = (x + bias) >> n;
    return ans;
}
```

(4) negate函数

**函数要求：**

| 函数名   | negate                                        |
| -------- | --------------------------------------------- |
| 参数     | int x                                         |
| 功能实现 | 返回-x                                        |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用5个操作符 |

**分析：**

x+(~x)=-1

所以-x = ~x + 1

**函数实现：**

```c
int negate(int x) {
  int ans = ~x + 1;
  return ans;
}
```

(5) howManyBits函数

**函数要求：**

| 函数名   | howManyBits                                    |
| -------- | ---------------------------------------------- |
| 参数     | int x                                          |
| 功能实现 | 返回x的补码表示最小需要几位                    |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用90个操作符 |

**分析：**

对于负数，我们将其按位取反，因为取反后的数x'需要的补码位数与原来的x需要的补码位数相同。

剩下的即可借助下面的intLog2函数计算其最高的1的位置，加2即是我们需要的最小的补码位数。

注意，对于0需要特判，ans=1；

**函数实现：**

```c
int howManyBits(int x) {
  int ans = 0;
  int is_zero = 0;
  int mask = 0;
  x = (x >> 31) ^ x;
  is_zero = !x;
  mask = (!is_zero) << 31 >> 31;  // if x is 0, mask = 0; else mask = 0xffffffff
  // cout << bitset <sizeof(int) * 8> (mask) << endl;
  ans = ans + ((!!(x >> 16)) << 4);   // find the left 16bits if there have any 1
  ans = ans + ((!!(x >> (8 + ans))) << 3);  // find if there any 1 in current 8 bits
  ans = ans + ((!!(x >> (4 + ans))) << 2);
  ans = ans + ((!!(x >> (2 + ans))) << 1);
  ans = ans + (!!(x >> (1 + ans))) + 2;
  ans = (ans & mask) | is_zero;   // if x is zero, ans = 1
  return ans;
}
```

(6) isLessOrEqual函数

**函数要求：**

| 函数名   | isLessOrEqual                                  |
| -------- | ---------------------------------------------- |
| 参数     | int x, int y                                   |
| 功能实现 | 若$x\leq y$，返回1；否则返回0                  |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用24个操作符 |

**分析：**

先提出x和y的符号。

若x和y的符号不同，当x为负数y为正数时ans=1；其他情况皆为ans=0。

若x和y的符号相同，计算x-(y + 1)的值，若这个值为负数，则ans=1；否则ans=0

**函数实现：**

```c
int isLessOrEqual(int x, int y) {
  int signx = (x >> 31) & 0x1;      // signx = (x < 0) ? 1 : 0
  int signy = (y >> 31) & 0x1;      // signy is same as above
  int sign_diff = signx ^ signy;    // if sign of x and y is different, sign_diff = 1
  int diff = x + (~y);    // ~y = ~(y + 1) + 1
  int ans = (!sign_diff & !!(diff >> 31)) | (sign_diff & signx);  // x <= y equals to ((x < 0 && y >= 0) || (x, y have same sign && x - (y+1) < 0))
  return ans;
}
```

(7) intLog2函数

**函数要求：**

| 函数名   | intLog2                                        |
| -------- | ---------------------------------------------- |
| 参数     | int x                                          |
| 功能实现 | 返回$\lfloor \log_2{x}\rfloor$                 |
| 要求     | 只能使用! ~ & ^ \| + << >>, 最多使用90个操作符 |

**分析：**

答案ans可以表示成$a\times 2^{4}+b\times 2^{3} + c\times 2^{2} + d \times 2^{1} + e\times 2^{0}$

考虑二分思想，先判断高16位里有无1，若有，a=1，下一次判断高8位有无1；否则a=0，下一次判断低16位中的高8位有无1。

再判断高/低16位中的高8位有无1，若有，b=1；否则b=0。

在判断高or低16位中的高or低8位中的高4位有无1，以此类推，最终得到ans。

**函数实现：**

```c
int intLog2(int x) {
  int ans = 0;
  ans = ans + ((!!(x >> 16)) << 4);   // find the left 16bits if there have any 1
  ans = ans + ((!!(x >> (8 + ans))) << 3);  // find if there any 1 in current 8 bits
  ans = ans + ((!!(x >> (4 + ans))) << 2);
  ans = ans + ((!!(x >> (2 + ans))) << 1);
  ans = ans + (!!(x >> (1 + ans)));
  return ans;
}
```

### 3. float

(1) floatAbsVal函数

**函数要求：**

| 函数名   | floatAbsVal                                          |
| -------- | ---------------------------------------------------- |
| 参数     | unsigned uf                                          |
| 功能实现 | 计算uf的绝对值的位级表示（NaN原值返回）              |
| 要求     | 任意操作符包括 && \|\| if while , 最多使用10个操作符 |

**分析：**

对于IEEE标准下的浮点数，第31位为符号位sign，第30～23位为阶码exp，第22～0位为尾数frac。

若exp为1111 1111，为NaN或者无穷大数，返回原值。

否则构造掩码mask=011...11，ans&mask即为答案。

**函数实现：**

```c
unsigned floatAbsVal(unsigned uf) {
  unsigned int mask = ~(1 << 31);
  unsigned int ans = 0;
  if((uf & mask) > 0x7f800000) ans = uf;
  else {
    ans = uf & mask;
  }
  return ans;
}
```

(2) floatScale1d2函数

**函数要求：**

| 函数名   | floatScale1d2                                        |
| -------- | ---------------------------------------------------- |
| 参数     | unsigned uf                                          |
| 功能实现 | 计算uf*0.5的位级表示（NaN原值返回）                  |
| 要求     | 任意操作符包括 && \|\| if while , 最多使用30个操作符 |

**分析：**

分类讨论：

1）当exp为1111 1111时，uf为NaN或无穷大，返回原值。

2）当exp>1时，直接阶码-1，其他不变为ans。

3）当exp<=1时，其他不动，尾码右移一位：若尾码的低两位为11则进位；其他情况舍去。

**函数实现：**

```c
unsigned floatScale1d2(unsigned uf) {
  unsigned sign = (uf >> 31);
  unsigned exp = (uf & 0x7f800000) >> 23;
  if(((uf >> 23) & 0xff) == 0xff) return uf;  // uf is NaN or infinity
  if(exp > 1) return (uf & 0x807fffff) | ((exp - 1) << 23);
  if((uf & 0x3) == 0x3) uf = uf + 0x2;    // 01, round down; 10, divided; 11, round up
  return ((uf >> 1)  & 0x007fffff) | (sign << 31);
}
```

(3) floatFloat2Int函数

**函数要求：**

| 函数名   | floatFloat2Int                                        |
| -------- | ----------------------------------------------------- |
| 参数     | unsigned uf                                           |
| 功能实现 | 返回uf的转int型的位级表示（NaN和无穷返回0x80000000u） |
| 要求     | 任意操作符包括 && \|\| if while , 最多使用30个操作符  |

**分析：**

分类讨论：

1）当exp<127时，因为偏置bias=127，故exp-bias<0，尾数至少右移一位，取整为0；

2）当exp-bias >= 8时，因为尾数最多左移7位，否则则会占用符号位造成溢出，此时返回0x80000000u

3）当0<=exp-bias<=7时，给尾数加上小数点前的1，并左移(exp-bias)位，转换成int即可。

**函数实现：**

```c
int floatFloat2Int(unsigned uf) {
  unsigned int sign = uf >> 31;
  unsigned int exp = (uf & 0x7f800000) >> 23;
  unsigned int frac = uf & 0x007fffff;
  int bits = exp - 127u;
  int ans = 0;
  if(exp < 127u) return 0x0;
  else if(!exp) return 0x0;       // exp is 00000000
  else if((exp & 0xff) == 0xff) return 0x80000000u; // exp is 11111111
  else {
    frac = frac + (1 << 23);
    if(bits > 7) return 0x80000000u;    // overflow
    frac = ((frac << bits) & 0x7f800000) >> 23;
    ans = frac;
    if(sign) ans = (~ans) + 1;
  }
  return ans;
}
```



## 四、实验总结

### 1. 实验中遇到的问题及解决方案

（1）思路卡顿

​	对于其中有几道题（如bitCount的分治合并）思考了较长时间没有好的思路，通过网上搜集资料（知乎，csdn）可以找到有关分治解决该问题的方法。学习明白后可以在后面的howManyBits和intLog2函数中运用相似的二分思想。

（2）将文件下载到物理机上，使用vscode运行btest无法通过，但上传到虚拟机上本地测试可以通过

​	对于这一问题，如写floatFloat2int函数时，我在自己的电脑上```return 0x80000000u```得到的结果为-2147483648，而在实验平台的虚拟机上的答案为2147483648。我也上网搜集了有关资料，于是了解到我的电脑时64位的，```(int)0x80000000u```会得到一个负数，编译器的原因导致它没能强制转换成一个无符号数；而在32位的虚拟机上则能得到我们想要的正数结果。

### 2. 实验的建议与心得

（1）函数顺序进行调换
	本实验是按照bit-level、two's complement和float进行划分的，其中two'complement中可能有一些比较简单的函数，我认为可以放到前面，这样保证做题顺序基本按照难度递增排列，可以更好的理解位级运算。例如，negate函数为得到一个数的相反数，像这一技巧在前面就已经用到过了很多次，所以我认为这道题可以放到更前面的位置。另外，几道需要用到二分思想的函数可以放在一起，既能启发学生又能让同学们巩固二分思想。

（2）心得
	本次实验通过写一些有关位运算的函数实现一些基本功能，加强了我对位级运算的理解及熟练使用的能力，并且进一步巩固了我对于课上、书本上所学的内容。在实验中我也遇到了一些问题，并能通过和同学们谈论或者上网查找资料解决这些问题，提高了我动手实践并解决问题的能力。
