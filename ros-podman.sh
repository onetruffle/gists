#!/usr/bin/env sh

## pull docker image
# podman pull docker.io/ros:noetic
podman pull docker.io/osrf/ros:noetic-desktop-full

## list images
podman image ls -a

## build image in the dockerfile directory
## https://github.com/onetruffle/ros-dockerfile
podman build --rm -t my-ros .

## run image as container
# podman run -it ros:noetic-desktop-full
podman run -it image1

## run image with gui and networking, remove after exiting
## https://major.io/2021/10/17/run-xorg-applications-with-podman/
podman run -it -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix image1
## --net=host breaks the network config, gives same hostname as host
## --rm for single use

## x access for all users
xhost +  ## unblock
xhost - ## block

## x access for non-network local users
xhost +"local:"  ## unblock
xhost -"local:" ## block

## x access for podman
xhost +"local:podman@"  ## unblock
xhost -"local:podman@" ## block

## list containers (including the stopped ones)
podman container list --all

## single shell
podman container start -ail
podman container stop -l

## multiple shell sessions
podman container restart -l
podman container exec -til -w /root bash
podman container stop -l

################################
## optional, not necessary

## pause container (
## doesn't work for us, simply freezes the terminal, 
## container is destroyed anyway when the terminal 
## is killed)
podman container pause _TAB_container-name

## checkpoint and restore container
podman container checkpoint _TAB_container-name
podman container restore _TAB_container-name

## save container as image (not necessary)
podman container commit _TAB_container-name

##############################
## on the container

## source the ros setup script for every new shell
.  /opt/ros/noetic/setup.bash

## set the catkin workspace only once
cd ## pushd only works here in zsh, not bash
mkdir -p catkin_ws/src
pushd catkin_ws
catkin_make
popd

## once for every shell
.  ~/catkin_ws/devel/setup.bash

## optionally append the setup scripts to ~/.bashrc
echo "
.  /opt/ros/noetic/setup.bash
.  ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
