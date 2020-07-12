#### Make commands
* `make lint` - Performs static analysis of Dockerfile using hadolint (assumes hadolint is available in classpath)
* `make build` - creates a new image
* `make run` - creates container from above image and runs it
    * `make run -e CONF_SRC=$PWD/orgdocs` - Uses CONF_SRC env variable to pass absolute path to hugo config source 
* `make push` - pushes container to docker registry

#### Generate Tern SPDX report
* `local:~$ cd /path/to/cloned/tern/repo/vagrant`
* `local:~$ vagrant up`
* `local:~$ vagrant ssh`
* `vagrant@ubuntu-bionic:~$ tern report -f spdxtagvalue -i iyogi/hugo-builder:latest -o output.txt`