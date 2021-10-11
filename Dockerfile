FROM alpine

LABEL version="1.0.0"
LABEL name="k8s-toolkit"
LABEL repository="http://github.com/bwvolleyball/k8s-toolkit"
LABEL homepage="http://github.com/bwvolleyball/k8s-toolkit"

LABEL maintainer="Brandon Ward <@bwvolleyball>"
LABEL com.github.actions.name="Kubernetes Toolkit"
LABEL com.github.actions.description="Configures a kubernetes toolkit. The kube config must be provided. Includes kubernetes cli and helm."
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

RUN apk add --no-cache curl

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
