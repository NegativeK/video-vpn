Wireguard and yt-dlp in a container for IP address cycling.

# Warning
This is not for privacy. It will leak information through DNS and
through VPN failure. It's intended to cycle IP addresses on error conditions.

Due to the data leakage, the host running the container may connect directly to
the target service.

# Resources
Information on Wireguard configuration: https://github.com/pirate/wireguard-docs
