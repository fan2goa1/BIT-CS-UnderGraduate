import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableReducer;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;

import java.io.IOException;

public class InvertedIndexReducer extends TableReducer<Text, IntWritable, ImmutableBytesWritable> {
    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        // 从键中分离单词和文档文件名
        String[] wordAndFileName = key.toString().split("\\$");
        String word = wordAndFileName[0], fileName = wordAndFileName[1];
        // 求单词在文档中的总出现次数
        int count = 0;
        for (IntWritable value : values) {
            count += value.get();
        }
        // 写入HBase
        Put put = new Put(word.getBytes());
        put.addColumn("count".getBytes(), fileName.getBytes(), String.valueOf(count).getBytes());
        context.write(null, put);
    }
}
