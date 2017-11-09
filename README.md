# Run ODM DSI Runtime on Docker

## Prerequisites

You can use the provided materials on MacOS or Ubuntu 16.04 LTS 64-bit. And you can use any Linux VM with a recent version of Docker. 
Before you start, make sure you have installed the following software:
* IBM ODM Decision Server Insights V8.9.0
* Docker 1.12.6
* Docker Compose 1.8.0
* Curl 7.47.0

Note: To be able to create the Docker image you must have an installation of IBM ODM
Decision Server Insights V8.9.0.

OK, let's continue...

## Build the Docker image

### Install the scripts

The source for this tutorial is available on Github in this
GIT repository: https://github.com/ODMDev/odm-dsi-docker.

Change the current working directory to the location where you want the cloned directory to be made.
Get the source files from Github over the SSH transfer protocol by typing:

``
git clone https://github.com/ODMDev/odm-dsi-docker.git
``

Note: You'll need an existing SSH key in your GitHub account to use for authentication.

In the following document:
 * `DSI_DOCKER_GIT` designates the directory containing the working copy of
   this GIT repository.
 * `DSI_HOME` designates the directory containing the installation of ODM DSI V8.9.0.

### Create the Docker image

The Docker image can be produced by running the script 'build.sh'. Pass the path of the ODM installation directory as the first
argument. For example:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime
./build.sh $DSI_HOME
```

The output should end with:

```
The docker image dsi-runtime has been created.
```

This message means that the Docker image `dsi-runtime` has been produced.
The command `docker images` can be used to verify that the image is now listed in the local registry of Docker.

### MacOS

On MacOS the build of the image will use the IBM JDK from the 'ibmjava' image, which might be different to the one supported by DSI Runtime.

To make sure you use a supported JDK, build the DSI runtime image from a Linux installation directory.

## Run a single DSI runtime with Docker

```sh
docker run -p9443:9443 --name dsi-runtime dsi-runtime
```

The name of the Docker container is `dsi-runtime` and the port `9443` of
the DSI REST API is bound to port `9443` of the host.

When DSI is started, the output ends with the following lines:
```
[AUDIT   ] CWWKF0011I: The server dsi-runtime is ready to run a smarter planet.
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/debug/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/gateway/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/IBMJMXConnectorREST/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/rest/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/insights/
```

## Test a DSI Runtime running in Docker

### Deploy a solution

To deploy a solution and the connectivity configuration,
the usual command line tools `solutionManager` and `connectivityManager` can be used.

The sample script `solution_deploy.sh` can also be used to deploy a simple test solution and its connectivity configuration.
In a separate command shell to the one you used to run the DSI container:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/simple
./solution_deploy.sh $DSI_HOME localhost 9443
```

The first argument is the path to the installation directory of DSI.
The second argument is the hostname of the DSI runtime.
The third argument is the port of the DSI Runtime.

The output of the command line should be similar to:
```
Solution successfully deployed.
CWMBE1146I: Reading the input file: ./simple_solution-0.0.esa
CWMBE1475I: The connectivity server configuration file for the solution "simple_solution" contains the configuration required for the specified endpoints.
CWMBE1148I: Writing to the output file: /tmp/simple_solution-inbound.ear7303141339821942454.tmp
CWMBE1452I: Successfully deployed connectivity for the solution "simple_solution".
CWMBE1498I: Number of active inbound endpoints: 1
CWMBE1499I: Number of active outbound endpoints: 0
```

The DSI runtime console should display a message about the solution:
```
[AUDIT   ] CWWKG0017I: The server configuration was successfully updated in 0.407 seconds.
[AUDIT   ] CWWKF0012I: The server installed the following features: [usr:simple_solution-0.0].
[AUDIT   ] CWWKF0008I: Feature update completed in 0.402 seconds.
[AUDIT   ] CWMBD0055I: Solution simple_solution-0.0 installed.
[AUDIT   ] CWWKG0016I: Starting server configuration update.
[AUDIT   ] CWWKG0028A: Processing included configuration resource: /opt/dsi/runtime/wlp/usr/servers/cisDev/simple_solution-config.xml
[AUDIT   ] CWWKG0017I: The server configuration was successfully updated in 0.040 seconds.
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/in/
[AUDIT   ] CWWKZ0001I: Application simple_solution-inbound started in 0.097 seconds.
[AUDIT   ] CWMBD0060I: Solution simple_solution-0.0 ready.
```

### Check that the solution is deployed

Open the URL https://localhost:9443/ibm/ia/rest/solutions/simple_solution/.

The REST command returns the following data:

```xml
<object type="com.ibm.ia.admin.solution.Solution">
        <attribute name="entityTypes">
                <collection type="entityTypes">
                        <string>simple.Person</string>
                </collection>
        </attribute>
        <attribute name="eventTypes">
                <collection type="eventTypes">
                        <string>simple.SayHello</string>
                        <string>simple.CreatePerson</string>
                        <string>simple.Message</string>
                </collection>
        </attribute>
        <attribute name="name">
                <string>simple_solution</string>
        </attribute>
        <attribute name="timeZone">
                <object type="java.time.ZoneId">UTC</object>
        </attribute>
</object>
```

### Send an event

To create an entity of the type `simple.Person`, and an event of type `simple.CreatePerson` send REST API calls to the DSI runtime.

The script `create_person.sh` can be used:
```sh
cd $DSI_DOCKER_GIT/samples/simple
./create_person.sh localhost
```

The first argument is the hostname of the DSI runtime.

### View the created entity

The sent event creates an entity instance of 'simple.Person'.

Open the URL https://localhost:9443/ibm/ia/rest/solutions/simple_solution/entity-types/simple.Person.

The REST command returns the following data:

```xml
<object xmlns:xsd="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.ibm.com/ia/Entity" type="Collection[simple.Person]">
  <attribute name="entities">
    <collection>
      <object type="simple.Person">
        <attribute name="$CreationTime">
          <null/>
        </attribute>
        <attribute name="$IdAttrib">
          <string>name</string>
        </attribute>
        <attribute name="description">
          <string>  </string>
        </attribute>
        <attribute name="name">
          <string>jean</string>
        </attribute>
      </object>
    </collection>
  </attribute>
</object>
```

## Advanced usage of Docker

### Persist deployed solutions

As docker containers are stateless, deployed solutions in containers are not persisted.
Following, two different ways to persist the solutions.

#### Keep deployed solution in a Docker volume

The preferred way to persist data in docker is to use volumes (https://docs.docker.com/engine/admin/volumes/volumes/).

To avoid the need to redeploy a solution after a container is restarted, a Docker volume can be used to store the DSI data.

First, create a volume:
```sh
docker volume create --name dsi-runtime-volume
```

Run a Docker container using this volume to store the DSI files:
```sh
docker run -p9443:9443 -v dsi-runtime-volume:/opt/dsi/runtime/wlp --name dsi-runtime dsi-runtime
```

Deploy the solution in the running container:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/simple
./solution_deploy.sh $DSI_HOME localhost 9443
```

The solution is now in the volume and can be used by another container.

#### Creation of a docker image with a deployed solution

Run a Docker container:
```sh
docker run -p9443:9443 dsi-runtime
```

Deploy the solution in the running container:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/simple
./solution_deploy.sh $DSI_HOME localhost 9443
```

Stop the running DSI runtime in a clean way:
```sh
docker exec -ti dsi-runtime /opt/dsi/runtime/wlp/bin/server stop dsi-runtime
```

Create an image with the deployed solution:
```sh
docker commit dsi-runtime dsi-runtime-simple-sol
```

Now, you can run a container with the 'simple' solution by using the
docker image you created:
```sh
docker run -p9443:9443 dsi-runtime-simple-sol
```

### Change the default configuration of DSI

Depending on your needs, you might want to use another DSI configuration.

It is possible to add multiple DSI configurations to the same Docker image.
Each configuration has to be added in a separate sub-directory under the directory `<DSI_DOCKER_GIT>/templates/servers`.

To add a new DSI configuration in the Docker image:
 * Copy the files in `<DSI_DOCKER_GIT>/templates/servers/dsi-runtime`
   to a new directory, for example `<DSI_DOCKER_GIT>/templates/servers/my-dsi-template`
 * Edit the files in `<DSI_DOCKER_GIT>/templates/servers/my-dsi-template`.
 * Rebuild the Docker image using the script `<DSI_DOCKER_GIT>/builds.sh`.

When running the DSI Docker container, the name of the DSI configuration must
be passed as the first argument of the startup script:

```sh
docker run -p9443:9443 --name my-dsi-runtime /root/start.sh my-dsi-template
```

### Start and test a DSI cluster

The directory `samples/cluster` contains an example of a DSI cluster based on
Docker Compose. Used with Docker Swarm, the cluster can be hosted on multiple servers.
The topology of the sample cluster is using 1 catalog server, 3 runtime servers, 1 inbound and 1
outbound server. It can be modified by changing the file `docker-compose.yaml`.

On MacOS, the default docker daemon setting is 2 CPUs with 2 GB of memory. This setting is insufficient to run the DSI cluster. Make sure that you set to a higher value. For example, 6 CPUs with 12 GB of memory if your machine has the capability. The setting can be modified at Docker > Preferences... > Advanced section.

To start the DSI cluster:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/cluster
docker-compose up
```

Wait until the cluster is ready, the output should end with:
```
dsi-runtime-container2    | [AUDIT   ] CWMBD9737I: Waiting for backing store to become available
dsi-runtime-container1    | [AUDIT   ] CWMBD0000I: IBM Decision Server Insights version 8.9.0.201710162214
dsi-runtime-container3    | [AUDIT   ] CWMBD0000I: IBM Decision Server Insights version 8.9.0.201710162214
dsi-runtime-container1    | [AUDIT   ] CWWKF0012I: The server installed the following features: [ia:iaRuntime-8.9.0, jsp-2.2, servlet-3.1, ia:iaRulesEngineApi-1.4.0, ssl-1.0, jndi-1.0, ia:iaCommon-8.9.0, eXtremeScale.client-1.1, ia:iaAnalytics-8.9.0, appSecurity-2.0, jaxrs-1.1, restConnector-1.0, blueprint-1.0, ia:iaGateway-8.9.0, json-1.0, eXtremeScale.server-1.1, distributedMap-1.0, wab-1.0, ia:iaDispatcher-8.9.0, ia:iaRulesEngine-1.30.2, ia:iaRulesEngine-1.40.3].
dsi-runtime-container1    | [AUDIT   ] CWWKF0011I: The server dsi-runtime-container is ready to run a smarter planet.
dsi-runtime-container3    | [AUDIT   ] CWWKF0012I: The server installed the following features: [ia:iaRuntime-8.9.0, jsp-2.2, servlet-3.1, ia:iaRulesEngineApi-1.4.0, ssl-1.0, jndi-1.0, ia:iaCommon-8.9.0, eXtremeScale.client-1.1, ia:iaAnalytics-8.9.0, appSecurity-2.0, jaxrs-1.1, restConnector-1.0, blueprint-1.0, ia:iaGateway-8.9.0, json-1.0, eXtremeScale.server-1.1, distributedMap-1.0, wab-1.0, ia:iaDispatcher-8.9.0, ia:iaRulesEngine-1.30.2, ia:iaRulesEngine-1.40.3].
dsi-runtime-container3    | [AUDIT   ] CWWKF0011I: The server dsi-runtime-container is ready to run a smarter planet.
dsi-runtime-container1    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://2165c0eef080:9080/ibm/ia/rest/
dsi-runtime-container1    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://2165c0eef080:9080/IBMJMXConnectorREST/
dsi-runtime-container3    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://aea79a14dc33:9080/ibm/ia/rest/
dsi-runtime-container3    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://aea79a14dc33:9080/IBMJMXConnectorREST/
dsi-runtime-outbound      | [WARNING ] CWMBD9684W: The following warning message is being suppressed. It has occurred 20 times in the last 20,074 milliseconds. Message: CWMBE2540W: The outbound queue monitor is currently unable to retrieve the list of active solutions. The grid state is "UNKNOWN".
dsi-runtime-container2    | [AUDIT   ] CWMBD9737I: Waiting for backing store to become available
dsi-runtime-container1    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://2165c0eef080:9080/ibm/insights/
dsi-runtime-container3    | [AUDIT   ] CWWKT0016I: Web application available (default_host): http://aea79a14dc33:9080/ibm/insights/
dsi-runtime-container2    | [AUDIT   ] CWMBD9738I: Backing store is available
```

Deploy the "simple" solution:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/cluster
./solution_deploy.sh $DSI_HOME
```

The command deploys the solution to all the DSI runtimes and the connectivity to the DSI inbound
server. The HTTPS port of the first DSI runtime is bound to the port 9443 of the host.

Then you can send an event using:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/cluster
./create_person.sh jeanfi
```

Finally, verify that it has created the entity, by opening a browser and entering the
URL https://localhost:9443/ibm/ia/rest/solutions/simple_solution/entity-types/simple.Person.

# Issues and contributions
For issues relating specifically to the Dockerfiles and scripts, please use the [GitHub issue tracker](../../issues).
We welcome contributions following [our guidelines](CONTRIBUTING.md).

# License
The Dockerfiles and associated scripts found in this project are licensed under the [Apache License 2.0](LICENSE).

# Notice
© Copyright IBM Corporation 2017.
