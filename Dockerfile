FROM hashicorp/terraform:0.11.11
MAINTAINER Stuart Loxton <stuart.loxton@xinja.com.au>

ENV TERRAGRUNT_VERSION=v0.17.4
ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /bin/terragrunt
RUN chmod +x /bin/terragrunt

ENV TERRAFORM_PROVIDER_VERSION=v1.60.1
ADD https://github.com/StuartLox/terraform-provider-aws/releases/download/${TERRAFORM_PROVIDER_VERSION}/terraform-provider-aws /bin/terraform-provider-aws
RUN chmod +x /bin/terraform-provider-aws

RUN mkdir -p /root/.terraform.d/plugins/linux_amd64/
RUN cp bin/terraform-provider-aws /root/.terraform.d/plugins/linux_amd64/terraform-provider-aws
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"