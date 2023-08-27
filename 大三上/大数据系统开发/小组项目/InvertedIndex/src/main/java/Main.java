import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.mapreduce.TableMapReduceUtil;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
        Configuration config = HBaseConfiguration.create();
        // 创建作业
        Job job = Job.getInstance(config);
        // 设置主类、mapper类和reducer类
        job.setJarByClass(Main.class);
        job.setMapperClass(InvertedIndexMapper.class);
        job.setReducerClass(InvertedIndexReducer.class);
        // 设置mapper输出类型
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);
        // 设置输入格式
        FileInputFormat.addInputPath(job, new Path(args[0]));
        // 设置输出格式
        TableMapReduceUtil.initTableReducerJob("word", InvertedIndexReducer.class, job);
        // 执行作业
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}