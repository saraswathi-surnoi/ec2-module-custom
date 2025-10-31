#!/bin/bash
set -e

# ========================
# System Preparation
# ========================
echo "Updating system packages..."
apt update -y
apt upgrade -y

echo "Installing basic dependencies..."
apt install -y git wget curl unzip apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# ========================
# Install Java 21
# ========================
echo "Installing Java 21..."
apt install -y openjdk-21-jdk
java -version

# ========================
# Install Maven 3.9.8
# ========================
echo "Installing Maven..."
wget -q https://archive.apache.org/dist/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz -P /tmp
tar xf /tmp/apache-maven-3.9.8-bin.tar.gz -C /opt
ln -s /opt/apache-maven-3.9.8 /opt/maven
cat <<EOF >/etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export PATH=\$PATH:/opt/maven/bin
EOF
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version

# ========================
# Install Docker
# ========================
echo "Installing Docker..."
apt remove -y docker docker-engine docker.io containerd runc || true
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Allow ubuntu user to use Docker without sudo
usermod -aG docker ubuntu

echo "Setup complete."
