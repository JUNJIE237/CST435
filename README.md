# Hadoop Cluster Docker Setup in Single Machine and Multiple machine、
This project is extended from https://github.com/kiwenlau/hadoop-cluster-docker.git, a collaborative effort by<br>
- Angeline Teoh Qee  (159023)
- Tan Jun Jie  (158253)
- Then Tai Yu  (159152)
- Yeo Ying Sheng (157627)
- Lee Ter Qin  (159389)
---
### Notes
You can find built images through 
```bash
docker pull junjie237/cst435:3.0
```
---
# Hadoop Cluster Docker Setup in Single Machine

## Introduction
This guide provides step-by-step instructions to set up and execute a Hadoop cluster using Docker. It includes cloning necessary repositories, modifying resources, generating datasets, building Docker images, and running MapReduce jobs.

---

## Prerequisites
- Ensure Docker is installed and running on your system.
- Python3 must be installed to run the dataset generation script.

---

## Steps

### 1. Clone the Hadoop Cluster Docker Repository
```bash
git clone https://github.com/kiwenlau/hadoop-cluster-docker
cd hadoop-cluster-docker/
```

### 2. Clone and Modify Resources
- Clone the repository containing modified resources.
- Move the necessary files to the `config` directory.

```bash
git clone https://github.com/JUNJIE237/CST435
cd CST435/
sudo chmod 777 setup.sh
./setup.sh
cd ..
```

### 3. Generate the Dataset
Run the Python script `generate.py` to generate the dataset. Specify the number of rows as a parameter.

```bash
cd config
python3 generate.py 6758
cd ..
```

### 4. Build the Docker Image
Build a new Docker image with a custom tag.

```bash
docker build -t kiwenlau/hadoop:<newtag> .
```

### 5. Modify the Start Script
Edit the `start-container.sh` script to use the new Docker image tag.

```bash
vim start-container.sh
```
- Update the Docker image tag to the newly built image `<newtag>`.

### 6. Start the Container
#### Default Node Numbers (1 Master, 2 Slaves)
```bash
./start-container.sh
```

#### Custom Node Numbers (e.g., 1 Master, 3 Slaves)
```bash
./start-container.sh 4
```

### 7. Start Hadoop and Execute MapReduce
- Access the `hadoop-master` container.
- Start Hadoop and execute the MapReduce job to calculate the average temperature.

```bash
./start-hadoop.sh
./run-average.sh
```

---

### Notes
- Replace `<newtag>` with your desired Docker image tag.
- Ensure that all necessary files are correctly moved to the `config` directory before building the Docker image.
- Verify the functionality of the `generate.py` script and MapReduce programs before running.

---

### Troubleshooting
If you encounter any issues, check:
1. Docker installation and status.
2. Correct configuration of the `start-container.sh` script.
3. Permissions of scripts and files.
---
# Hadoop Cluster Docker Setup in Across Multiple Machine
---
## Introduction 
This guide provides step-by-step instructions to set up and execute a Hadoop cluster using Docker Swarm across multiple instances. It includes initializing a swarm, labeling nodes, creating a network, deploying services, and running MapReduce jobs.

---

## Prerequisites
- Ensure Docker is installed and running on all instances.
- Python3 must be installed to run the dataset generation script.

---

## Steps

### 1. Create Instances
Set up 4 instances (Instance1, Instance2, Instance3, Instance4).

### 2. Initialize Docker Swarm
On Instance1, initialize the Docker Swarm and advertise its IP address:
```bash
# On Instance1
docker swarm init --advertise-addr <ip-address-of-the-instance>
```
Copy the token displayed after initialization.

### 3. Join Other Instances to the Swarm
Use the token from Instance1 to join Instance2, Instance3, and Instance4 to the swarm:
```bash
# On Instance2, Instance3, Instance4
docker swarm join --token <token> <ip-address-of-instance1>:2377
```

### 4. Create Docker Network
Create a Docker overlay network to join all nodes together:
```bash
# On Instance1
docker network create --attachable --driver overlay Hadoop
```

### 5. Label the Nodes
Label each node to define its role in the Hadoop cluster:
```bash
# On Instance1
docker node ls  # To identify the name of each instance
docker node update --label-add role=hadoop-master <Name of Instance2>
docker node update --label-add role=Hadoop-slave1 <Name of Instance3>
docker node update --label-add role=Hadoop-slave2 <Name of Instance4>
```

### 6. Pull Docker Image
On Instance2, Instance3, and Instance4, pull the Docker image:
```bash
# On Instance2, Instance3, Instance4
docker pull junjie237/cst435:3.0
```

### 7. Run Docker Image as Services
Run the Docker image as services from Instance1:
#### Hadoop Master
```bash
# On Instance1
docker service create --hostname hadoop-master --network Hadoop -p 50070:50070 -p 8088:8088 --entrypoint /bin/bash --tty --replicas 1 --constraint "node.labels.role == hadoop-master" --name hadoop-master junjie237/cst435:3.0
```
#### Hadoop Slave1
```bash
# On Instance1
docker service create --hostname hadoop-slave1 --network Hadoop --entrypoint /bin/bash --tty --replicas 1 --constraint "node.labels.role == hadoop-slave1" --name hadoop-slave1 junjie237/cst435:3.0
```
#### Hadoop Slave2
```bash
# On Instance1
docker service create --hostname hadoop-slave2 --network Hadoop --entrypoint /bin/bash --tty --replicas 1 --constraint "node.labels.role == hadoop-slave2" --name hadoop-slave2 junjie237/cst435:3.0
```

### 8. Access the Containers
On Instance2, Instance3, and Instance4, access the containers:
```bash
# On Instance2, Instance3, Instance4
docker ps  # To get the container ID
docker exec -it <container_ID> /bin/bash
```
Inside each container, start the SSH service:
```bash
# Inside the container
sudo service ssh start
```

### 9. Start Hadoop and Run MapReduce
On the Hadoop-master container:
```bash
# On Hadoop-master
./start-hadoop.sh
./run-average.sh
```

---

## Notes
- Replace `<ip-address-of-the-instance>` and `<token>` with the appropriate values.
- Replace `<Name of InstanceX>` with the names of the instances.
- Ensure that all necessary files are correctly moved to the `config` directory before building the Docker image.
- Verify the functionality of the `generate.py` script and MapReduce programs before running.

---

## Troubleshooting
If you encounter any issues, check:
1. Docker installation and status on all instances.
2. Correct configuration of the swarm and labels.
3. Permissions of scripts and files.

