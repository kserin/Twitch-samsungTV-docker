FROM ubuntu:18.04

EXPOSE 26099

# Install needed components
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq install wget libwebkitgtk-1.0-0 rpm2cpio cpio expect python2.7 ruby libcanberra-gtk-module libcanberra-gtk3-module gettext software-properties-common pciutils libcurl3-gnutls make libxcb-icccm4 libxcb-render-util0 libxcb-image0 acl libsdl1.2debian libxcb-randr0 bridge-utils openvpn libssl1.0.0 gnome-keyring && \
  add-apt-repository ppa:openjdk-r/ppa -y && \
  apt-get update && \
  apt-get install -yq openjdk-8-jdk && \
  wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb && \
  dpkg -i libpng12-0_1.2.54-1ubuntu1_amd64.deb

# Install tizen 
RUN adduser --shell /bin/bash --home /home/tizen --system tizen
USER tizen
WORKDIR /home/tizen
RUN wget --quiet http://download.tizen.org/sdk/Installer/tizen-studio_3.7/web-cli_Tizen_Studio_3.7_ubuntu-64.bin && \
  chmod +x web-cli_Tizen_Studio_3.7_ubuntu-64.bin && \
  ./web-cli_Tizen_Studio_3.7_ubuntu-64.bin --accept-license /home/tizen/tizen-studio && \
  /home/tizen/tizen-studio/package-manager/package-manager-cli.bin install --accept-license Baseline-SDK TOOLS TV-SAMSUNG-Public TV-SAMSUNG-Extension-Tools cert-add-on

# Install script
COPY --chown=tizen:root install.sh /home/tizen/
# Need dbus session for keyring
ENTRYPOINT [ "dbus-run-session", "--", "bash", "/home/tizen/install.sh" ]
