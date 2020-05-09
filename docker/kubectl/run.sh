docker build . -t hminh0407/kubectl

docker run --name kubectl -it --rm --entrypoint="/bin/sh" hminh0407/kubectl:latest
