FROM hashicorp/terraform

WORKDIR "/root"

# RUN echo $' providers { \n \
# terraform-aws-provider = "/root/terraform-provider-aws" \n \
# }' > /root/.terraformrc


RUN wget https://github.com/StuartLox/terraform-provider-aws/releases/download/v1.60.1/terraform-provider-aws

RUN chmod +x terraform-provider-aws
RUN mkdir -p .terraform.d/plugins/linux_amd64/
RUN  mv terraform-provider-aws ~/.terraform.d/plugins/linux_amd64/terraform-provider-aws
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.16.11/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt
ENTRYPOINT ["/usr/local/bin/terragrunt"]