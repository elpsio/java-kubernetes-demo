# Sample kubernetes cluster using kustomize

The demo allows you to play with kubernetes versioning, namespaces
and [kustomization](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/). Kustomization is shipped
with kubectl which comes with minikube. As application we use a simple containerized Java Spring Boot application.

## Prerequisite

- Installed [minikube](https://kubernetes.io/de/docs/setup/minikube/)
- Installed [Docker](https://www.docker.com/)
- Installed JDK

## Start the local cluster (local namespace)

1. Apply the namespace, deployment and service yaml's:

```
kubectl apply -k k8s\local\
```

2. Open the default page to access the application (append `/messages` to hit the controller):

```
minikube service backend-demo-service -n local
```

The screen should display ``Hello from Docker v2!``.

3. Now you can overwrite values with kustomization. In the default we will overwrite the specified tag `v1` in the
   local [deployment.yaml](./k8s/local/backend-demo-deployment.yaml) by adding the following snippet
   to [kustomization.yaml](./k8s/local/kustomization.yaml) (already done in the default).

````yaml
images:
  - name: backend-demo
    newTag: v2
````

Additional info:

v1 - Prints ``Hello from Docker v1!``

v2 - Prints ``Hello from Docker v2!``

v2 - Prints ``Hello from Docker v3!`` and all system properties (project will use environment variables soon).

___

## [Optional] Use your own docker hub repository and own images:

1. Create a private or public docker repository under https://hub.docker.com/ (or use my images as default).


2. Build the jars:

```
mvn clean package
```

3. Build a docker image with version ``v1`` from the Dockerfile:

```
docker build --tag=backend-demo:v1 .
```

4. Go to [DockerMessageController](./src/main/java/com/example/backenddemo/DockerMessageController.java) and replace the
   version in the message returned:

```
Hello from Docker v2!
```

5. Build the jars:

```
mvn clean package
```

6. Build a docker image with version ``v2`` from the Dockerfile:

```
docker build --tag=elpit/backend-demo:v3 .
```

7. Push the tagged images to your repository:
```
docker push {REPOSITORY NAME}/backend-demo:v1
docker push {REPOSITORY NAME}/backend-demo:v2
```

8. Replace the repository name `elpit` from the image declaration in
    the [local](./k8s/local/backend-demo-deployment.yaml)
    and [integ](./k8s/integ/backend-demo-deployment.yaml) files:

````yaml
    spec:
      containers:
        - name: backend-demo
          image: elpit/backend-demo:v1
          ports:
            - containerPort: 80
````

````yaml
      spec:
      containers:
        - name: backend-demo
          image: elpit/backend-demo:v2
          ports:
            - containerPort: 80
````




