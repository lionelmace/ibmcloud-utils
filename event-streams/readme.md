# Event Streams Sample Application

## Pre-Requisites

1. Install Kafka `brew install kafka`

## Send message

1. Create a file kafka.properties with your Service Credentials

    ```sh
    bootstrap.servers=<your-kafka-bootstrap-endpoints>
    security.protocol=SASL_SSL
    sasl.mechanism=PLAIN
    sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="token" password="<your-password-from-service-credentials>";
    ssl.ca.location=/path/to/ca.pem
    ```

1. Run Kafka producer to verify the producer performance

    ```sh
    kafka-producer-perf-test --topic <your-topic-name> --num-records 10000 --record-size 1000 --throughput 1000 --producer.config kafka.properties
    ```

    Output:

    ```sh
    2913 records sent, 580,2 records/sec (0,55 MB/sec), 1408,0 ms avg latency, 2110,0 ms max latency.
    3536 records sent, 693,3 records/sec (0,66 MB/sec), 2841,2 ms avg latency, 3676,0 ms max latency.
    10000 records sent, 661,2 records/sec (0,63 MB/sec), 2969,84 ms avg latency, 5142,00 ms max latency, 3010 ms 50th, 4931 ms 95th, 5122 ms 99th, 5135 ms 99.9th.
    ```

## Run perf test

1. Create a dedicated topic (e.g., burn-2tb)
    Partitions: pick something moderate, e.g. 24.
    Replication factor: 3 (that’s what Event Streams uses for HA). 
    Topic configs (so data isn’t deleted while you’re filling):
        retention.ms=2592000000 (30 days)
        retention.bytes=35000000000 (≈ 35 GB per partition)
        → With 24 partitions that’s ≈ 840 GB of user data; with RF=3 that reserves ≈ 2.52 TB on disk, comfortably past your 2 TB cap. Note Kafka reserves a bit more than your retention to keep an extra segment and indexes.

1. Use a load generator
   Produce big, uncompressible messages fast. You’re capped at 1 MB per message on Event Streams, so just use 900 KB–1 MB to be safe.
    Disable compression (compression.type=none) or send random bytes.

    ```sh
    kafka-producer-perf-test \
    --topic burn-2tb \
    --num-records 760000 \
    --record-size 900000 \
    --throughput -1 \
    --producer.config kafka.properties \
    --producer-props acks=all compression.type=none
    ```

    > Note: 900 KB × ~758k ≈ ~700 GB user data → with RF=3 ≈ ~2.1 TB reserved.
