FROM golang:1.11.5-alpine

ENV GOPATH /go

ENV GOLANG_VERSION 1.11.5
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 0573a8df33168977185aa44173305e5a0450f55213600e94541604b75d46dc06

ENV TERRAFORM_VERSION 0.11.11
ENV TERRAFORM_AWS_VERSION 1.60.0

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH/bin

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN chmod +x terraform
RUN rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR "/root"

RUN echo $' providers { \n \
aws = "/go/bin/terraform-provider-aws" \n \
}' > /root/.terraformrc

WORKDIR $GOPATH/bin

RUN wget https://github.com/StuartLox/terraform-provider-aws/releases/download/v1.60.1/terraform-provider-aws

RUN chmod +x terraform-provider-aws
RUN ./terraform-provider-aws

RUN rm -rf darwin_amd64.zip

ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.16.11/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt
ENTRYPOINT ["/usr/local/bin/terragrunt"]