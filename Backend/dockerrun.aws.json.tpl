{
    "AWSEBDockerrunVersion": "1",
    "Image": {
      "Name": "${aws_repo}",
      "Update": "true"
    },
    "Ports": [
      {
        "ContainerPort": 8080,
        "HostPort": 8080
      }
    ]
  }