import System.Clock

-- 定义一个类型Matrix
type Matrix = [[Int]]

-- 矩阵相乘
mat_Mul :: Matrix -> Matrix -> Matrix
mat_Mul a b =
    let bt = transpose b
        n = length bt
    in [[sum $ zipWith (*) ar bc | bc <- bt] | ar <- a]
    -- in [[sum [ar !! k * bc !! k | k <- [0..n-1]] | bc <- bt] | ar <- a]
    -- 对于每一行和列的组合，计算两个向量的内积，并将结果添加到乘积矩阵中

-- 转置矩阵
transpose :: Matrix -> Matrix
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)

-- 读取文件转成矩阵
readMatrix :: FilePath -> IO Matrix
readMatrix file = do
    contents <- readFile file
    return (map (map read . words)(lines contents))

-- 将矩阵写入文件
writeMatrix :: FilePath -> Matrix -> IO ()
writeMatrix file matrix = writeFile file (unlines (map (unwords . map show) matrix))

main :: IO ()
main = do
    
    a <- readMatrix "A.txt"
    b <- readMatrix "B.txt"
    
    let c = mat_Mul a b
    st <- getTime Monotonic
    writeMatrix "C_haskell.txt" c
    ed <- getTime Monotonic
    let tot_t = fromIntegral(toNanoSecs $ diffTimeSpec ed st) / (10 ^ 9)
    putStrLn $ "total running time: " ++ show tot_t ++ " s"