FROM golang:alpine

ENV GOPATH /go

ENV GOLANG_VERSION 1.11.5
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 0573a8df33168977185aa44173305e5a0450f55213600e94541604b75d46dc06

ENV TERRAFORM_VERSION 0.11.11
ENV TERRAFORM_AWS_VERSION 1.60.0

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# RUN set -ex \
# 	&& apk update \
# 	&& apk add --no-cache ca-certificates  \
# 	&& apk add --no-cache --virtual .build-deps \
# 	&& apk add bash gcc musl-dev openssl zip make bash git go curl \
# 	&& curl -s https://raw.githubusercontent.com/docker-library/golang/221ee92559f2963c1fe55646d3516f5b8f4c91a4/1.9/alpine3.7/no-pic.patch -o /no-pic.patch \
# 	&& cat /no-pic.patch \
# 	&& export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
# 	&& wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
# 	&& echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
# 	&& tar -C /usr/local -xzf golang.tar.gz \
# 	&& rm golang.tar.gz \
# 	&& cd /usr/local/go/src \
# 	&& patch -p2 -i /no-pic.patch \
# 	&& ./make.bash \
#     && rm -rf /*.patch \
# 	&& apk del .build-deps

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH/bin

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN chmod +x terraform

RUN rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR "/root"

RUN echo $' providers { \n \
aws = "/go/bin/terraform-provider-aws_v${TERRAFORM_AWS_VERSION}" \n \
}' > /root/.terraformrc

WORKDIR $GOPATH/bin

RUN wget https://github.com/StuartLox/terraform-provider-aws/releases/download/v1.60.0/darwin_amd64.zip

RUN unzip darwin_amd64.zip
RUN mv darwin_amd64/terraform_provider_aws_v1.60.0 .
RUN chmod +x terraform_provider_aws_*

RUN rm -rf darwin_amd64.zip

ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.16.11/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt
ENTRYPOINT ["/usr/local/bin/terragrunt"]