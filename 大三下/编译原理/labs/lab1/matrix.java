import java.io.*;
import java.util.*;

public class matrix{
    public static void main(String[] args) throws IOException {
        // 读取矩阵A
        Scanner fileA = new Scanner(new File("A.txt"));
        int numRowsA, numColsA, numRowsB, numColsB, numRowsC, numColsC;
        numRowsA = numColsA = numRowsB = numColsB = numRowsC = numColsC = 300;

        int[][] MatA = new int[numRowsA][numColsA];
        for(int i = 0; i < numRowsA; i ++){
            for(int j = 0; j < numColsA; j ++){
                MatA[i][j] = fileA.nextInt();
            }
        }
        fileA.close();
        // 读取矩阵B
        Scanner fileB = new Scanner(new File("B.txt"));
        int[][] MatB = new int[numRowsB][numColsB];
        for(int i = 0; i < numRowsB; i ++){
            for(int j = 0; j < numColsB; j ++){
                MatB[i][j] = fileB.nextInt();
            }
        }
        fileB.close();
        // 矩阵乘法
        int[][] MatC = new int[numRowsC][numColsC];
        double st = System.currentTimeMillis();
        for(int i = 0; i < 300; i ++){
            for(int j = 0; j < 300; j ++){
                MatC[i][j] = 0;
                for (int k = 0; k < 300; k ++){
                    MatC[i][j] += MatA[i][k] * MatB[k][j];
                }
            }
        }

        double ed = System.currentTimeMillis();

        // 写出矩阵C
        PrintStream printS = new PrintStream(new FileOutputStream("C_java.txt"));
        for(int i = 0; i < numRowsC; i ++){
            for(int j = 0; j < numColsC; j ++){
                printS.print(MatC[i][j] + " ");
            }
            printS.println();
        }
        printS.close();
        double totalTime = ed - st;
        System.out.println("total running time: " + totalTime/1000.0 + "s");
    }
}
