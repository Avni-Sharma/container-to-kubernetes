# simple-go-server

The example considered here helps us to understand how we can migrate from using containers to the kubernetes ways of managing containers.

Some concepts to read about before we dive into implementing the examples.

[Podman](https://podman.io/) - Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux System.

[Kubernetes](https://kubernetes.io/ - Kubernetes (K8s) is an open-source system for automating deployment, scaling, and management of containerized applications.


## Implementing examples

### Case 1

Build the container image with podman by running-

`podman build -t quay.io/<username>/server-demo:v1 .`

VOILA!! we don't need sudo ;)

Check the availability of images with `podman images`

Here, by default, the Dockerfile would be taken into consideration. The Dockerfile does not have an entry point so we will have to run the container and ssh into it to be able to start our server. The command to do is `podman run -it --rm <image-name> sh`

`podman ps` to check running containers then exec into it with `podman exec -it <image name> sh`

Run `go run <app name>` from within the container and curl it within the container.
For our example we can do `curl http://localhost:8080` and `curl http://localhost:8080/kubernetes`

### Case 2

For `curl`ing from the host machine you will have to expose the container port and publish the container port to the host port on the host machine. `EXPOSE` allow communication between the container and other containers in the same network. But it does not allow communication with the host machine, or containers in another network! In order to permit that, you need to publish the port, with `-p` option.

run `docker build -t quay.io/<username>/server-demo:v1 -f ./Dockerfile.expose`

Note- In this Dockerfile.expose I have added the `EXPOSE` and `ENTRYPOINT` . When I give the entrypoint I do not need to exec into the container and start the server. The container now has an entrypoint to run with.

Now run `podman run <image-name> -p 8081:8080`

You can curl from your host machine for `curl http://localhost:8080` and `curl http://localhost:8080/kubernetes` or access the same end point from the browser.

Now login to a conatiner registry for pushing your images there. I will login to quay.io container registry

`podman login quay.io`
You would be prompted to enter your username and password 

Now push your images to the registry- `podman push <image-name>`

WOOT!! Your container is now ready to be shipped.

### Case 3 (Ahoy Kubernetes!!)

We surely have containers now, but what if my container dies? We can't keep monitoring it. What if we need more replicas? Who would watch of the `current state` of the containers and get it to the `desired states`? Who would `Orchestrate` them in harmony. Now let us do it the Kubernetes way. 

Prerequisites- `[Install minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)` or `[crc](https://cloud.redhat.com/openshift/install/crc/installer-provisioned)` a single node cluster for local development purposes.

`[Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)` Kubernetes command-line tool 

`minikube start` to start the kubernetes single node cluster.

Apply the pod.yaml `kubectl apply -f pod.yaml`

Applying a deployment is better `kubectl apply -f deployment.yaml`

Check whether the deployment is deployed - `kubectl get deployments -n=<specified namespace>`

To expose your service to the world run `kubectl apply -f service.yaml`

Find your minikube ip - `minikube ip`

Now `curl http://<minikubue ip>:<NodePort>`

Now if you try to delete the deployment, the deployment controller would watch for terminating pods and get up the desired number of pods again depending upon the `replicas` field in the `deployment.yaml`. Isnt't it EEZY PEEZZY. Now you can relax on your ship where you are the pseudo captain ;) and BON VOYAGE :)





 

