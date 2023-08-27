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
        String path = ((FileSplit)context.getInputSplit()).getPath().toString();
        String fileName = path.substring(path.lastIndexOf('/') + 1);
        StringTokenizer tokenizer = new StringTokenizer(value.toString());
        tokenizer.nextToken();
        final IntWritable ONE = new IntWritable(1);
        while (tokenizer.hasMoreTokens()) {
            context.write(new Text(fileName + "$" + tokenizer.nextToken()), ONE);
        }
    }
}
