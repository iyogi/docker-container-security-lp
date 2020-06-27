#### Make commands
* `make lint` - Performs static analysis of Dockerfile using hadolint (assumes hadolint is available in classpath)
* `make build` - creates a new image
* `make run` - creates container from above image and runs it
    * `make run -e CONF_SRC=/absolute/path/to/docker-container-security-lp/orgdocs` - Uses CONF_SRC env variable to pass absolute path to hugo config source 
* `make push` - pushes container to docker registry