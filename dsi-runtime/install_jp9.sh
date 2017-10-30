#!/bin/bash

if [ -z "$1" ]; then
        echo "Missing container name"
        exit 1
fi


docker exec -ti "$1" bash -c "wget http://download-keycdn.ej-technologies.com/jprofiler/jprofiler_linux_9_2.tar.gz -P /tmp/"
docker exec -ti "$1" bash -c "tar -xzf /tmp/jprofiler_linux_9_2.tar.gz -C /usr/local"
docker exec -ti "$1" bash -c "/usr/local/jprofiler9/bin/jpenable --gui --port=8849"
