BASE_PROJ ?= $(shell pwd)
LINUX ?= ${BASE_PROJ}/linux
SSH_PORT ?= "52222"
NET_PORT ?= "52223"
GDB_PORT ?= "50001"
.ALWAYS:

all: vmlinux 

docker: .ALWAYS
	docker buildx build --network=host --progress=plain -t rahul-ifc .

qemu-run: 
	docker run --privileged --rm \
	--device=/dev/kvm:/dev/kvm \
	-v ${BASE_PROJ}:/linux-dev-env -v ${LINUX}:/linux \
	-w /linux \
	-p 127.0.0.1:${SSH_PORT}:52222 \
	-p 127.0.0.1:${NET_PORT}:52223 \
	-p 127.0.0.1:${GDB_PORT}:1234 \
	-it rahul-ifc:latest \
	/linux-dev-env/q-script/yifei-q -s

# connect running qemu by ssh
qemu-ssh:
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -t root@127.0.0.1 -p ${SSH_PORT}

qemu-scp:
	scp -P 52222 -O -o "StrictHostKeyChecking=no" root@127.0.0.1:/linux-dev-env/bpf-progs/demo.kern.ll .

vmlinux: 
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc  make -j`nproc` bzImage 

headers-install: 
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc  make -j`nproc` headers_install 

modules-install: 
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc  make -j`nproc` modules
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc  make -j`nproc` modules_install

kernel:
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc  make -j`nproc` 

linux-clean:
	docker run --rm -v ${LINUX}:/linux -w /linux rahul-ifc make distclean

enter-docker:
	docker run --rm -v ${BASE_PROJ}:/linux-dev-env -w /linux-dev-env -it rahul-ifc /bin/bash

