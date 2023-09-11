import sys
import os

if __name__ == "__main__":
    argc = len(sys.argv)
    if argc != 2:
        print("Usage: python LogAnalyzer.py [logfile.txt]")
        exit(0)
    
    f = open(sys.argv[1], "r")
    lines = f.readlines()

    cnt_tot, cnt_err = 0, 0
    for i in range(len(lines)-1):
        log1, log2, log3, log4 = lines[i].strip().split(',')
        MsgType, pdu_recv = log2.split('=')
        _, status = log3.split('=')
        _, ackedNo = log4.split('=')
        if MsgType == "pdu_exp":    # 说明是receiver的log
            continue
        cnt_tot += 1
        if status == "RT" or status == "TO":
            cnt_err += 1

    print(cnt_err/cnt_tot * 100)

