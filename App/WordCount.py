from pyspark import SparkConf, SparkContext

conf = SparkConf().setAppName("WordCount")
sc = SparkContext(conf=conf)

HOMEAPP_DATA = "/home/app/Data/"
filename = "movies.csv"

lines = sc.textFile(HOMEAPP_DATA + filename)

word_count = lines.flatMap(lambda line: line.split(" ")) \
                 .map(lambda word: (word, 1)) \
                 .reduceByKey(lambda a, b: a + b)

sorted_word_count = word_count.sortBy(lambda x: x[1], ascending=False)

sorted_word_count_single_partition = sorted_word_count.coalesce(1)

sorted_word_count_single_partition.saveAsTextFile(HOMEAPP_DATA + "output")

sc.stop()