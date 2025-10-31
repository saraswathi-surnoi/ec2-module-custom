#!/bin/bash
set -e

# ========================
# System Preparation
# ========================
echo "🔹 Updating system packages..."
apt update -y
apt upgrade -y

echo "🔹 Installing required dependencies..."
apt install -y git wget curl unzip apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# ========================
# Install Java 21
# ========================
echo "🔹 Installing Java 21..."
apt install -y openjdk-21-jdk
java -version

# ========================
# Install Maven 3.9.8
# ========================
echo "🔹 Installing Maven..."
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
echo "🔹 Installing Docker..."
apt remove -y docker docker-engine docker.io containerd runc || true
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Allow default user (ubuntu) to use Docker
if id "ubuntu" &>/dev/null; then
  usermod -aG docker ubuntu
  echo "Added 'ubuntu' to docker group"
fi

# ========================
# Install Jenkins
# ========================
echo "🔹 Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install -y fontconfig jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# ========================
# Verify installations
# ========================
echo "------ Versions ------"
java -version
mvn -version
git --version
docker --version
systemctl status jenkins | head -10

echo "✅ Jenkins setup completed successfully!"