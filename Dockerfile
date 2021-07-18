FROM nvidia/vulkan:1.1.121-cuda-10.1-beta.1-ubuntu18.04
  
# install vulkan
RUN rm /etc/apt/sources.list.d/* && apt-get update && apt-get install -y --no-install-recommends \
    wget sudo

RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add - \
    && sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.2.182-bionic.list https://packages.lunarg.com/vulkan/1.2.182/lunarg-vulkan-1.2.182-bionic.list \
    && sudo apt update \
    && sudo apt install -y --no-install-recommends vulkan-sdk

# install ssh server
RUN apt install -y --no-install-recommends openssh-server

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

CMD ["/usr/sbin/sshd", "-D"]