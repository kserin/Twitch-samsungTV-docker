# Twitch-samsungTV-docker

Docker image to easily install [Twitch TV app](https://github.com/fgl27/smarttv-twitch) on Samsung Smart TV.

## Installation procedure

1. Get the local IP address of your computer and your TV.
2. Put your TV in [developer mode](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/tv-device.html#connecting-the-tv-and-sdk) (you may need to enter the IP of your computer during this step to allow install application remotely)
3. Pull docker image:
`docker pull <TODO>`
4. Compile and install app on your TV with the docker image: `docker run --rm --cap-add ipc_lock <TODO> <your-tv-ip>`
