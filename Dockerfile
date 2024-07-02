# Use Kali Linux as the base image
FROM kalilinux/kali-rolling

LABEL maintainer="Your Name <your.email@example.com>"

# Update package list and install necessary tools
RUN apt-get update && \
    apt-get install -y kali-linux-full metasploit-framework tightvncserver sudo apache2 fakeroot

# Set up a VNC password for user 'Fondness' (replace 'Bugz' with your desired password)
RUN mkdir -p /home/Fondness/.vnc && \
    echo "Bugz" | vncpasswd -f > /home/Fondness/.vnc/passwd && \
    chmod 600 /home/Fondness/.vnc/passwd && \
    chown -R Fondness:Fondness /home/Fondness/.vnc

# Configure VNC server startup script for user 'Fondness'
RUN echo "#!/bin/bash\n\
    su - Fondness -c 'vncserver :1 -localhost no -geometry 1280x800 -depth 24'\n\
    tail -F /home/Fondness/.vnc/*.log" > /home/Fondness/.vnc/xstartup && \
    chmod +x /home/Fondness/.vnc/xstartup && \
    chown -R Fondness:Fondness /home/Fondness/.vnc

# Expose ports for VNC and Apache
EXPOSE 5901 80

# Start Apache web server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
