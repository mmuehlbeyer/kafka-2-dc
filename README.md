# kafka-multi-dc

kafka multi dc example with docker-compose 
inspired by https://github.com/1123/Kafka-2DC-HA-Demo

## Prerequisites

* A recent version of Confluent Platform installed
* Linux or MacOS operating system 
* bash



## How to run this demo

1. Startup the whole stack with docker-compose (with the  docker-compose.yml file, we will use docker-compose-degraded.yml later)

`docker-compose up -d zookeeper01 zookeeper02 zookeeper03 zookeeper04 zookeeper05 zookeeper06`


wait a little to get all the processes and services startetd properly
check the status of the containers with

`docker-compose ps`

and check the logs if needed with
docker logs $containername

2. check the zookeeper status 

    1. `./check-zookeeper.sh`

    1. `./check-zookeeper.sh | grep leader`

    1. `./check-zookeeper.sh | grep follower`


all zookeeper should be running, and there is exactly one leader and 5 followers. 


3. kill zookeeper01 and zookeeper04 to simulate a machine failure

    1. `docker-compose kill zookeeper01` 

    1. `docker-compose kill zookeeper04`

check the zookeeper cluster status and see that there are 4 zookeeper running, exactly one leader and 3 followers. 

the cluster is still operational, as it tolerates one outage per zookeeper group.

4. start zookeeper01 and zookeeper04 again, cluster should be back in normal state

    1. `docker-compose start zookeeper01`

    1. `docker-compose start zookeeper04`


5. Start the Kafka brokers

    1. `docker-compose up -d kafka01 kafka02 kafka03 kafka04`

    check if everything is fine with

	1. `docker-compose ps`


6. start a sample producer and a sample consumer application in two more terminal windows. 
   producer is configured with the acks=all setting. This will create the topics test and __consumer_offsets.
	1. `./run-producer.sh`
	1. `./run-consumer.sh`