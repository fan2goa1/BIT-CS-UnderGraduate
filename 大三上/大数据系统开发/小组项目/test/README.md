## 环境

- Ubuntu Server 20.04 LTS
- OpenJDK 8
- Hadoop 3.2.4
- HBase HBase 2.4.14

## 使用方法

（1）安装OpenJDK 8：

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y openjdk-8-jdk-headless
```

（2）将Hadoop安装到`/usr/local/hadoop`，将HBase安装到`/usr/local/hbase`。

（3）将以下内容添加到`~/.bashrc`的末尾：

```bash
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HBASE_HOME=/usr/local/hbase
export HBASE_CONF_DIR=$HBASE_HOME/conf
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$HBASE_HOME/bin
```

然后执行`source ~/.bashrc`。

（4） [以伪分布式模式配置Hadoop](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)和[HBase](https://hbase.apache.org/book.html#standalone_dist)。

（5）格式化HDFS：

```bash
hdfs namenode -format
```

（6）启动HDFS和HBase：

```bash
start-dfs.sh
start-hbase.sh
```

（7）在HDFS中创建用户目录：

```bash
hdfs dfs -mkdir -p /user/your_username
```

（将`your_username`替换为当前用户的用户名）

（8）分割`sentences.txt`并放入HDFS：

```bash
mkdir input
cd input
split -d -a2 -l100000 --additional-suffix=.txt /path/to/sentences.txt sentences-
cd ..
hdfs dfs -put input
```

（将`/path/to/sentences.txt`替换为`sentences.txt`的路径）

（9）在HBase中创建表`test`，包含一个列族`cf`：

```bash
hbase shell
```

然后

```ruby
create 'word', 'count'
```

（10）使用IntelliJ IDEA构建`InvertedIndex.jar`（Build > Build Artifacts…）。

（11）使用Hadoop运行`InvertedIndex.jar`：

```bash
hadoop jar /path/to/InvertedIndex.jar sentences.txt
```

（将`/path/to/InvertedIndex.jar`替换为`InvertedIndex.jar`的路径）

（12）查看结果：

```bash
hbase shell
```

然后

```ruby
scan 'word'
```

