# Use Kali Linux as the base image
FROM kalilinux/kali-rolling

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND noninteractive

# Update package lists and install necessary tools
RUN apt-get update \
    && apt-get install -y \
        kali-linux-core \
        kali-linux-default \
        kali-linux-large \
        kali-tools-top10 \
        xrdp \
        sudo \
        supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up Xfce desktop environment and xrdp for remote desktop access
ENV DISPLAY=:1
RUN mkdir -p /etc/supervisor/conf.d \
    && echo "[supervisord]\nnodaemon=true\n" > /etc/supervisor/supervisord.conf \
    && echo "[program:xrdp]\npriority=10\ndirectory=/\ncommand=/etc/init.d/xrdp start\nautostart=true\nautorestart=true\nstopsignal=QUIT\nstdout_logfile=/var/log/xrdp.log\nstderr_logfile=/var/log/xrdp.err\n" > /etc/supervisor/conf.d/xrdp.conf \
    && echo "[program:xfce4]\npriority=10\ndirectory=/\ncommand=/usr/bin/startxfce4\nautostart=true\nautorestart=true\nstopsignal=QUIT\nenvironment=DISPLAY=\":1\",HOME=\"/\"\nstdout_logfile=/var/log/xfce4.log\nstderr_logfile=/var/log/xfce4.err\n" > /etc/supervisor/conf.d/xfce4.conf

# Expose port for RDP
EXPOSE 3389

# Start supervisor to manage services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
