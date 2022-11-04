# kafka-multi-dc

kafka multi dc example with docker-compose 
inspired by https://github.com/1123/Kafka-2DC-HA-Demo
credits to https://github.com/1123

## Prerequisites

* A recent version of Confluent Platform installed
* Linux or MacOS operating system 
* bash



## How to run this demo

1. Startup the whole stack with docker-compose (with the  docker-compose.yml file, we will use docker-compose-degraded.yml later)

    1. `docker-compose up -d zookeeper01 zookeeper02 zookeeper03 zookeeper04 zookeeper05 zookeeper06`

 
   wait a little to get all the processes and services startetd properly
   check the status of the containers with

    1. `docker-compose ps`

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

7. check the new created topics with 
    1. `./describe-topics.sh`

    both topics have replication factor 4 and min.insync.replicas configuration of 3

8. kill one broker to simulate a machine failure
    1. `docker kill kafka04`

    producer and consumer continue operating without errors.


9. kill another broker to simulate a 2nd machine failure

    1. `docker kill kafka01`

    now the producer is no longer able to produce messages as `min.insync.replicas` setting is no longer fullfilled.
    the setup tolerates one broker error, but not two

10. restart the two broker
    1. `docker-compose start kafka01 kafka04`
    producer should continue to work

11. now kill all in datacenter B. now neither the producer nor the consumer are working.

    1. `./kill-dcB.sh`

12. bring zookeeper to reduced operational mode:
    stop all remaining zookeeper nodes.
    1. `docker-compose stop zookeeper01 zookeeper02 zookeeper03`

    start zookeper in simple quorum mode
    1. `docker-compose -f docker-compose-degraded.yml up -d zookeeper01 zookeeper02 zookeeper03`

13. bring kafka to reduced operational mode. 
    reduce the min.insync.replicas setting for the remaining brokers:
    1. `./alter-min-isr.sh`

     producer and consumer are now again functional. 
     in this reduced operational mode we can still tolerate the outage of another kafka broker and another zookeeper node.

14. bring zookeeper 04-06 and kafka 03 and 04 back online

    1. `docker-compose -f docker-compose.yml up -d zookeeper04 zookeeper05 zookeeper06`

    1. `docker-compose -f docker-compose.yml up -d kafka03 kafka04`

    check the cluster status only zookeeper01-03 are currently serving requests

15. increase min.insync.replicas back to 3
    1. `increase-min-isr.sh`

    in productive environments do this only if there are no more under-replicated partitions

16. bring back zookeeper to hierarchical quorum by restarting zookeeper01-03

    1. `docker-compose -f docker-compose.yml up -d zookeeper01 zookeeper02 zookeeper03`

17. check zookeeper status again, all zookeeper nodes should now be back serving requests

    1. `./check-zookeeper.sh`

18. stop all once finished by
    1. `docker-compose down`

