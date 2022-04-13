# jupyterlab

*runs jupyter-lab inside a container*

> simple setup and run method *after the build*:
> * run `source jupyter_commands`
> * then go inside the directory you want to work on and run `jupyter_setup`
> * then run `jupyterlab`
> * finally copy the URL with "localhost" and open it with a browser

___

## build
    podman build -t jupyterlab:latest .

___

## first-time setup for a new project with podman
> this is all contained in `jupyter_commands`

Check the SELinux policy for that project's directory (where data is and where the notebook will be). If it is within our home directory, it should look like this:

    $ ls -Z | grep <directory>
    unconfined_u:object_r:user_home_t:s0 <directory>
    $

We need to change `user_home_t` for `container_file_t` to allow mounting the directory in the container

*add the new policy rule*

    $ sudo semanage fcontext -a -t container_file_t <full/path/to/directory>(/.*)?
    $

*in case of error ```syntax error near unexpected token `('```, use escape caracters*

    $ sudo semanage fcontext -a -t container_file_t <full/path/to/directory>\(/.*\)?
    $

*apply the new policy rule*

    $ sudo restorecon -R -v <full/path/to/directory>
    Relabeled <full/path/to/directory> from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0
    Relabeled <full/path/to/directory>/<file1> from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0
    [...]
    Relabeled <full/path/to/directory>/<fileN> from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0
    $

*example*

    $ sudo semanage fcontext -a -t container_file_t /home/rboisnard/data\(/.*\)?
    $ sudo restorecon -R -v /home/rboisnard/data
    Relabeled /home/rboisnard/data from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0
    Relabeled /home/rboisnard/data/dataset.csv from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0
    Relabeled /home/rboisnard/data/analysis.ipynb from unconfined_u:object_r:user_home_t:s0 to unconfined_u:object_r:container_file_t:s0

(alternatively, mounting a directory labelled with `user_home_t` could be allowed globally with SELinux booleans)

___

## run
> this is all contained in `jupyter_commands`

Launch the container with podman

    $ podman run --rm -v <full/path/to/directory>:/data -p 8888:8888 --net host --name jupyterlab jupyterlab:latest
    [...]
        To access the server, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/jpserver-1-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=3ec33603dd33e732dac3ee9a7e531c87ce4dcb386796d72c
     or http://127.0.0.1:8888/lab?token=3ec33603dd33e732dac3ee9a7e531c87ce4dcb386796d72c

**copy the URL with "localhost" and open it with a browser**