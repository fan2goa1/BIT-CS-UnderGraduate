import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableReducer;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;

import java.io.IOException;

public class InvertedIndexReducer extends TableReducer<Text, IntWritable, ImmutableBytesWritable> {
    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        String[] fileNameAndWord = key.toString().split("\\$");
        int count = 0;
        for (IntWritable value : values) {
            count += value.get();
        }
        Put put = new Put(fileNameAndWord[1].getBytes());
        put.addColumn(Main.FAMILY.getBytes(), fileNameAndWord[0].getBytes(), String.valueOf(count).getBytes());
        context.write(null, put);
    }
}
