{
    "AWSEBDockerrunVersion": "1",
    "Image": {
      "Name": "${aws_repo}",
      "Update": "true"
    },
    "Ports": [
      {
        "ContainerPort": 80,
        "HostPort": 80
      }
    ]
  }