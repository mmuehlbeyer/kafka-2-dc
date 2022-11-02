kafka-configs \
  --alter \
  --entity-type brokers \
  --bootstrap-server localhost:29091,localhost:29092 \
  --entity-name 1 \
  --add-config min.insync.replicas=1
kafka-configs \
  --alter \
  --entity-type brokers \
  --bootstrap-server localhost:29091,localhost:29092 \
  --entity-name 2 \
  --add-config min.insync.replicas=1