# Flow
## Container
* Container starts
* WG connects with a random exit IP
  * Check if the wg interface is up
* yt-dlp runs
  * yt-dlp dies on any error
* On yt-dlp error, container stops
* Container restarts after a random delay

# Tasks
## Wireguard
* https://www.wireguard.com/ mentions setting up the VPN on the host and then
  moving it into a container's namespace
