# Run ODM DSI Runtime on Docker


## Prerequisites

All steps of the following document were tested with:
* Ubuntu 16.04 LTS 64-bit
* IBM ODM Insights V8.9.0
* Docker 1.12.6
* curl 7.47.0
* docker-compose 1.8.0

The creation of the Docker image requires to have an installation of IBM ODM
Insights.

## Build the Docker image

### Installation of the scripts

The source for this tutorial is available on Github in this
GIT repository: https://github.com/ODMDev/odm-dsi-docker.

To get the source:

``
git clone https://github.com/ODMDev/odm-dsi-docker.git
``

In the following document:
 * `DSI_DOCKER_GIT` designates the directory containing the working copy of
   this GIT repository.
 * `DSI_HOME` designates the directory containing the installation of ODM Insights.

### Creation of the Docker image

The Docker image can be produced by running the script 'build.sh' and
requires to pass the path of the ODM installation directory as the first
argument. For example:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime
./build.sh $DSI_HOME
```

The output should end with:

```
The docker image dsi-runtime has been created.
```

It means that the Docker image `dsi-runtime` has been produced.
The command `docker images` can be used to verify that the image is now listed in the local registry of Docker.

### MacOs

On MacOs the build of the image will use the IBM JDK from the 'ibmjava' image
which might be different than the one officially supported by DSI Runtime.

To use an officially supported JDK, the DSI runtime image must be build from a Linux installation directory.

## Run a single DSI runtime with Docker

To run a Docker container with the image build previously:
```sh
docker run -p9443:9443 --name dsi-runtime dsi-runtime
```

The name of the Docker container will be `dsi-runtime` and the port `9443` of
the DSI web api will be bind to the port `9443` of the host.

When DSI is started, the output will be similar to:
```
[AUDIT   ] CWWKF0011I: The server dsi-runtime is ready to run a smarter planet.
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/debug/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/gateway/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/IBMJMXConnectorREST/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/ia/rest/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://58de6092c19c:9080/ibm/insights/
```

## Test a DSI Runtime running in Docker

### Start a DSI Runtime

Start a DSI Runtime server:

```sh
docker run -p9443:9443 --name dsi-runtime dsi-runtime
```

### Deploy a solution

To deploy a solution and the connectivity configuration,
the usual command line tools `solutionManager` and `connectivityManager` can be used.

The script example `solution_deploy.sh` can be used to deploy a simple test solution and its connectivity configuration:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/simple
./solution_deploy.sh $DSI_HOME localhost
```

The first argument is the path to the installation directory of DSI.
The second argument is the hostname of the DSI runtime.

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

In the DSI runtime console it should display:
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

Open the URL https://localhost:9443/ibm/ia/rest/solutions/simple_solution/, the content should be similar to:

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

In order to create an entity `simple.Person`, an event `simple.CreatePerson`
can be sent by using the Web API of the DSI runtime.

The script `create_person.sh` can be used:
```sh
cd $DSI_DOCKER_GIT/samples/simple
./create_person.sh localhost
```

The first argument is the hostname of the DSI runtime.

### View the created entity

The event sent previously will create an entity 'simple.Person'.

Open the URL https://localhost:9443/ibm/ia/rest/solutions/simple_solution/entity-types/simple.Person, the content should be similar to:

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

### Keep deployed solutions

When a solution is deployed, it is stored by the DSI runtime on the file system.
The Docker containers are stateless so in case of a restart, the solution has to
be deployed again.

The preferable way to persist data in docker is to use the volumes (<https://docs.docker.com/engine/admin/volumes/volumes/>).
In order to avoid doing a redeployment of the solution, it can can be used to
store the solutions.

First, create a volume:
```sh
docker volume create --name dsi-runtime-vol
```

Run a Docker container using this volume for storing the DSI files:
```sh
docker run -p9443:9443 -v dsi-runtime-vol:/opt/dsi/runtime/wlp --name dsi-runtime dsi-runtime
```

### Change the default configuration of DSI

Depending on the usage, it might be required to use another configuration than
the default one.

It is possible to add multiple DSI configurations in the same Docker image.
Each configuration has to be added in a separate sub-directory
 in the directory `<DSI_DOCKER_GIT>/templates/servers`.

To add a new DSI configuration in the Docker image:
 * Copy the files in `<DSI_DOCKER_GIT>/templates/servers/dsi-runtime`
   to for example `<DSI_DOCKER_GIT>/templates/servers/my-dsi-template`
 * Edit the files in `<DSI_DOCKER_GIT>/templates/servers/my-dsi-template`.
 * Rebuild the Docker image using the script `<DSI_DOCKER_GIT>/builds.sh`.

When running the DSI Docker container, the name of the DSI configuration must
be passed as the first argument of the startup script:

```sh
docker run -p9443:9443 --name my-dsi-runtime /root/start.sh my-dsi-template
```

### Deploy a DSI cluster

The directory `samples/cluster` contains an example of DSI cluster based on
docker-compose. Used with Docker Swarm, it can be hosted on multiple servers.

To start the DSI cluster:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/cluster
docker-compose up
```

The topology of this cluster is using 1 catalog, 3 DSI runtimes, 1 inbound and 1
outbound servers. It can be easily modified by changing the file `docker-compose.yaml`.

Wait until the cluster is ready, the log should end with:
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

It will deploy the solution to all DSI runtimes and the connectivity to the DSI inbound
server. The HTTPS port of the first DSI runtime is bound to the port 9443 of the
host.

Then you can send an event using:
```sh
cd $DSI_DOCKER_GIT/dsi-runtime/samples/cluster
./create_person.sh jeanfi
```

And finally, verify that it has created the entity, by opening with a browser the
URL `https://localhost:9443/ibm/ia/rest/solutions/simple_solution/entity-types/simple.Person`.

# Issues and contributions
For issues relating specifically to the Dockerfiles and scripts, please use the [GitHub issue tracker](../../issues).
We welcome contributions following [our guidelines](CONTRIBUTING.md).

# License
The Dockerfiles and associated scripts found in this project are licensed under the [Apache License 2.0](LICENSE).

# Notice
© Copyright IBM Corporation 2017.
