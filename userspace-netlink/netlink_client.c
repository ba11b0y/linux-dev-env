// compile using gcc netlink_client.c -o netlink_client -g
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <string.h>
#include <asm/types.h>
#include <linux/netlink.h>
#include <linux/socket.h>
#include <errno.h>

#define NETLINK_BPF_USER 23 // same customized protocol as in my kernel module
#define MAX_PAYLOAD 1024 // maximum payload size

struct sockaddr_nl src_addr, dest_addr;
struct nlmsghdr *nlh = NULL;
struct nlmsghdr *nlh2 = NULL;
struct msghdr msg, resp;  // famous struct msghdr, it includes "struct iovec *   msg_iov;"
struct iovec iov, iov2;
int sock_fd;

int main(int args, char *argv[])
{
	//int socket(int domain, int type, int protocol);
	sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_BPF_USER); //NETLINK_KOBJECT_UEVENT  

	if(sock_fd < 0)
	return -1;

	memset(&src_addr, 0, sizeof(src_addr));
	src_addr.nl_family = AF_NETLINK;
	src_addr.nl_pid = getpid(); /* self pid */

	//int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	if(bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr))){
	perror("bind() error\n");
	close(sock_fd);
	return -1;
	}

	memset(&dest_addr, 0, sizeof(dest_addr));
	dest_addr.nl_family = AF_NETLINK;
	dest_addr.nl_pid = 0;       /* For Linux Kernel */
	dest_addr.nl_groups = 0;    /* unicast */

	//nlh: contains "Hello" msg
	nlh = (struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
	memset(nlh, 0, NLMSG_SPACE(MAX_PAYLOAD));
	nlh->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
	nlh->nlmsg_pid = getpid();  //self pid
	nlh->nlmsg_flags = 0; 

	//nlh2: contains received msg
	nlh2 = (struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
	memset(nlh2, 0, NLMSG_SPACE(MAX_PAYLOAD));
	nlh2->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
	nlh2->nlmsg_pid = getpid();  //self pid
	nlh2->nlmsg_flags = 0; 

	strcpy(NLMSG_DATA(nlh), "PING from userspace");   //put "Hello" msg into nlh

	iov.iov_base = (void *)nlh;         //iov -> nlh
	iov.iov_len = nlh->nlmsg_len;
	msg.msg_name = (void *)&dest_addr;  //msg_name is Socket name: dest
	msg.msg_namelen = sizeof(dest_addr);
	msg.msg_iov = &iov;                 //msg -> iov
	msg.msg_iovlen = 1;

	iov2.iov_base = (void *)nlh2;         //iov -> nlh2
	iov2.iov_len = nlh2->nlmsg_len;
	resp.msg_name = (void *)&dest_addr;  //msg_name is Socket name: dest
	resp.msg_namelen = sizeof(dest_addr);
	resp.msg_iov = &iov2;                 //resp -> iov
	resp.msg_iovlen = 1;



	printf("Sending message to kernel\n");

	int ret = sendmsg(sock_fd, &msg, 0);   
	printf("send ret: %d\n", ret); 



	char usermsg[MAX_PAYLOAD];
	while (1) {
		printf("Waiting for message from kernel\n");
		recvmsg(sock_fd, &resp, 0);  //msg is also receiver for read
		printf("Received verifier id: %s\n", (char *) NLMSG_DATA(nlh2)); 
	}
	close(sock_fd);

	return 0;
}