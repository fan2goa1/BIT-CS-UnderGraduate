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
    public static final String TABLE = "word";
    public static final String FAMILY = "count";

    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
        Configuration config = HBaseConfiguration.create();
        config.addResource(new Path(System.getenv("HBASE_CONF_DIR"), "hbase-site.xml"));
        config.addResource(new Path(System.getenv("HADOOP_CONF_DIR"), "core-site.xml"));

        Job job = Job.getInstance(config, "Inverted Index");
        job.setJarByClass(Main.class);
        job.setMapperClass(InvertedIndexMapper.class);
        job.setReducerClass(InvertedIndexReducer.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        TableMapReduceUtil.initTableReducerJob(TABLE, InvertedIndexReducer.class, job);
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}