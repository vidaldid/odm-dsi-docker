# How to use JProfiler9 to profile a DSI Runtime container

Build a DSI runtime image containing the OpenJDK:

```bash
export DSI_USEOPENJDK=1
./build.sh $DSI_HOME
```

Note: The openjdk is not officially supported by DSI Runtime.

Run a DSI Runtime container using the OpenJDK:

```bash
docker run -p9080:9080 -p9443:9443 -p8849 -e JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 -ti --name my-dsi-runtime dsi-runtime
```

Installation of the JProfiler agent:

```bash
./install_jp9.sh my-dsi-runtime
```

It will download the agent, install it and run it on the default profiling port 8849.

Finally, open JProfiler and attach a profiling session to localhost:8849.
