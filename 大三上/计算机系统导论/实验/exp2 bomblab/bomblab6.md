反汇编：

![image-20221014162707114](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014162707114.png)

![image-20221014162725652](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014162725652.png)

![image-20221014162741295](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221014162741295.png)

```c++
rsp -= 0x60
eax = 0
rsi = rsp
call <read_six_numbers>		// 读入6个数进来
r12 = rsp					// r12是第一个数的地址
r13 = rsp
r14d = 0x0

1:rbp = r13
eax = *r13
eax -= 0x1
if(eax > 0x5){		// 用的ja无符号比较，所以也能排除负数 要求eax <= 5
    call <explode_bomb>
}
r14d += 0x1			// r14d用来计数，r13用来存rsp数组中的数的地址；eax为当前数组中的数-1
if(r14d == 0x6){	// 扫到最后一个数
    rcx = r12 + 0x18
    edx = 0x7			// 把所有数转化成7-x
    do {
        eax = edx
        eax -= *r12
        *(r12) = eax
        r12 += 0x4
    }while(rcx != r12);
    esi = 0x0;
    while(1){
        ecx = *(rsp + 4 * rsi)
        eax = 0x1
        edx = 0x6032d0
        if(ecx > 0x1){
            do{
                rdx = *(rdx + 0x8)
                eax += 0x1
            }while(ecx != eax)
        }
    	*(rsp + 8 * rsi + 0x20) = rdx
        rsi += 0x1
        if(rsi == 0x6){
            rbx = *(rsp + 0x20)
                rax = *(rsp + 0x28)
                *(rbx + 0x8) = rax
                rdx = *(rsp + 0x30)
                *(rax + 0x8) = rdx
                rdx = *(rsp + 0x40)
                *(rax + 0x8) = rdx
                rax = *(rsp + 0x48)
                *(rdx + 0x8) = rax
                *(rax + 0x8) = 0x0
                ebp = 0x5

                2:rax = *(rbx + 0x8)	
                    eax = *(rax)
                    if(*rbx >= eax){
                        rbx = *(rbx + 0x8)
                            ebp -= 0x1
                            if(ebp == 0x0){
                                retq
                            }
                        else {
                            goto 2;
                        }
                    }
                    else {
                        call <explode_bomb>
                    }
        }
    }
}
else {	// rbp依次放的是第1，2，3，4，5个数；这段代码用于检验6个数互不相同，否则bomb
    ebx = r14d
    while(1){
        rax = ebx
        eax = *(rsp + 4 * rax)
        if(*rbp != eax){
            ebx += 0x1
            if(ebx > 0x5){
                r13 += 0x4
                goto 1;
                break;
            }
        }
        else {
            call <explode_bomb>
        }
    }
}
```

0x6032d0是一个链表1-6

![image-20221016193121919](C:\Users\steve\AppData\Roaming\Typora\typora-user-images\image-20221016193121919.png)

输入的一串数将第三列的顺序链表重新按输入输入接上，最后是让按着重组后的链表顺序使得对应的第一列数从大到小排，所以应该是3 2 1 5 4 6；由于有一个7-x，所以答案是4 5 6 2 3 1
