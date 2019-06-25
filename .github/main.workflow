workflow "Build and Publish Container" {
  on = "push"
  resolves = "Publish"
}

action "Docker Build" {
  uses = "actions/docker/cli@master"
  args = "build -t user/repo ."
}

action "Docker Tag" {
  uses = "actions/docker/tag@master"
  args = "base github/base"
}

action "Docker Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}
