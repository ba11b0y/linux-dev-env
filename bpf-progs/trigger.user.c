#include<stdio.h>
#include<unistd.h>

void main(){
	char buf[256];
	getcwd(buf, 256);
}