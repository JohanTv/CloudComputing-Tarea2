from pyspark import SparkConf, SparkContext
from pyspark.sql import HiveContext
from pyspark.sql.functions import split
from pyspark.sql.functions import desc

# Configurar Spark
conf = SparkConf().setAppName("PythonWordCount")
sc = SparkContext(conf=conf)
hiveContext = HiveContext(sc)

# Cargar datos
data = hiveContext.read.format('com.databricks.spark.csv').options(header='false', inferSchema='true').load('movies.csv')

# Realizar las transformaciones
df = data.select(split(data['_c0'], ' ').alias('words')) \
         .selectExpr('explode(words) as word') \
         .groupBy('word') \
         .count() \
         .orderBy(desc('count'))

# Guardar el DataFrame resultante como un archivo CSV
df.toPandas().to_csv("output.csv", index=False)

# Detener SparkContext
sc.stop()