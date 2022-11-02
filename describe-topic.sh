echo "describe topic test"
kafka-topics --describe \
  --topic test \
  --bootstrap-server localhost:29091,localhost:29092,localhost:29093,localhost:29094 
echo "describe topic __consumer_offsets"
kafka-topics --describe \
  --topic __consumer_offsets \
  --bootstrap-server localhost:29091,localhost:29092,localhost:29093,localhost:29094 