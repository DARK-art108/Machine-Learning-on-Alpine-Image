# Machine Learning on Alpine Machine Image

This repository holds a Dockerfile and Docker Compose for running Machine Learning Workloads on Alpine Docker Image.The Machine Learning Project is Bank Note Authetication you can get to know to about the project from [Bank Note Authentication](https://github.com/DARK-art108/Bank-Note-Authentication).

The repository contains `Dockerfile`, `docker compose` and a `notebook\` folder, in this project we are utilizing the container created by `petronetto`, the Dockerfile contains a whole configuration of creating the container and docker compose is used to startup the container process and services.

## How to run the project?

**STEP 1:** Perform `git clone https://github.com/DARK-art108/Machine-Learning-on-Alpine-ML-Image`

**STEP 2:** `cd Machine-Learning-on-Alpine-ML-Image/`

**STEP 3:** Run: `docker-composer up` and open your browser in `http://<public_ip>:8888`

**STEP 4:** Now you can run your notebook `http://<public_ip>:8888` and please wait for sometime until the kernel is ready.

## **References:**

> petronetto/machine-learning-alpine
