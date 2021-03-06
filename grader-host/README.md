# Grading host(s) deployment

The grading machines can be independently deployed and scaled without disturbing the web app deployment. However, there is a piece of software that has to glue both components together. This component is called the *backend*

![Alt text](architecture.PNG?raw=true "Title")

As you can see in the diagram, *backend* is the piece of software that makes possible the interaction between the frontend and the grading hosts.

## Important

Due to design decisions The backend does not need to know the hostnames of the grading hosts. However, the grading hosts DO need to know the hostname of the backend and the port that it is listening to.

*That means that you need to provide in each and every grading host the hostname of the backend*

Each agent registers itself to the backend and then the backend delegates the responsibility of grading submissions to them using a load balancing algorithm.

*If the backend dies, the registered agents don't have a way to know that they are not going to receive more work to do. You need to put backend up again and restart the agent services.*

## Steps to deploy a grading host (agent)

0. Have a machine with CentOS 7 and git
1. Clone the deployment repo `git clone https://github.com/JuezUN/Deployment.git`
3. Inside the Deployment folder, make the .sh files runnable
    
    `chmod +x *.sh`

4. Disable selinux
    
    `sudo ./disable_selinux.sh`

    *Running this command will cause the server to restart automatically so that the changes are applied*

2. Go to the grader-host folder `cd ./Deployment/grader-host`
3. Make the .sh files executable `chmod +x *.sh`
3. Install the agent prerequisites with `./agent_prerequisites.sh`

    *In this step, you'll be requested to provide a password for the agent user, this user is the one who is going to own the grading service*

4. *Logout and login again* so that you can use docker without sudo
5. Install the grading containers `sudo ../deployment_scripts/build_all_containers.sh`
5. Add `X.X.X.X backendhost` to your `/etc/hosts` file where `X.X.X.X` is the ip address of the backend, for example 

    ```
    $ cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain
    ::1         localhost localhost.localdomain
    10.142.0.3 backendhost
    ```


5. Install the agent services with `sudo ./install_services.sh`
6. Make sure the BACKEND is running and you can see the its host
7. Run the services `sudo systemctl start docker_agent && sudo systemctl start mcq_agent`

8. To verify that the deployment was successful, check the logs on the backend machine service and verify that it registered the agents you just deployed. It should look something like the following. It indicates that the agents said 'hello' to the backend and that everything is ready to use.

```
$ journalctl -b -u backend | grep hello

2018-09-17 23:26:32,626 - inginious.backend - INFO - Agent b'\x00k\x8bEi' () said hello
2018-09-17 23:26:33,305 - inginious.backend - INFO - Agent b'\x00k\x8bEj' () said hello
```

8. Go to [sshfs](../sshfs.md) documentation to setup a shared tasks folder with the webapp machine.
