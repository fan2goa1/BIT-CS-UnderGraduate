反汇编：

![image-20221014153732997](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014153732997.png)

![image-20221014153750166](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014153750166.png)

```c++
phase_5:
rsp -= 0x18
eax = 0
rcx = rsp + 0x4
rdx = rsp
esi = 0x4025cf	// 还是%d %d输入两个数
sccanf
if(eax <= 0x1){
    call <explode_bomb>
}
eax = *rsp	// 第一个数
eax &= 0xf	// 取二进制的后四位
*(rsp) = eax
if(eax == 0xf){	// 如果第一个数的二进制后四位是1111 bomb
    call <explode_bomb>
}
ecx = 0x0
edx = 0x0
do{
    edx += 0x1
    cltq	// 将eax符号扩展到rax
    eax = *(0x402480 + 4 * rax)
    ecx += eax
}while(eax != 0xf);
*rsp = 0xf
if(edx != 0x3){
    call <explode_bomb>
}
if(*(rsp + 0x4) == ecx){
	...
    retq
}
```

x/16 0x402480的结果：

![image-20221014162008385](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014162008385.png)

分析程序的大概意思就是输入了x y，然后根据x索引找到地址里的数，再将这个数作为地址索引找到对应存放的值，直到3此这样寻找后找到0xf，即15.

答案就是2 35，2->6->15，其中35 = 14 + 6 + 15