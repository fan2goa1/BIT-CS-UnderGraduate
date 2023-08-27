import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

import java.io.IOException;
import java.util.StringTokenizer;

public class InvertedIndexMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        // 获取文件名
        String path = ((FileSplit)context.getInputSplit()).getPath().toString();
        String fileName = path.substring(path.lastIndexOf('/') + 1);
        // 将文档内容划分为一个个单词
        StringTokenizer tokenizer = new StringTokenizer(value.toString());
        final IntWritable ONE = new IntWritable(1);
        while (tokenizer.hasMoreTokens()) {
            String word = tokenizer.nextToken();
            // 输出键-值对
            context.write(new Text(word + "$" + fileName), ONE);
        }
    }
}
