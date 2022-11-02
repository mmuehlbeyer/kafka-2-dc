kafka-configs \
  --alter \
  --entity-type brokers \
  --bootstrap-server localhost:29091,localhost:29092,localhost:29093,localhost:29094 \
  --entity-name 1 \
  --add-config min.insync.replicas=3
kafka-configs \
  --alter \
  --entity-type brokers \
  --bootstrap-server localhost:29091,localhost:29092,localhost:29093,localhost:29094 \
  --entity-name 2 \
  --add-config min.insync.replicas=3