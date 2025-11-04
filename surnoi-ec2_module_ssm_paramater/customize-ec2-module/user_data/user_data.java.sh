#!/bin/bash
set -euo pipefail

GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
RESET="\e[0m"

echo -e "${BLUE}==============================================="
echo " Jenkins Agent Setup Script - Starting "
echo -e "===============================================${RESET}"

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "Cannot detect OS"
  exit 1
fi

JENKINS_USER="jenkins"
DEVOPS_USER="devops"

# ------------------------
# Install Java 21
# ------------------------
echo "[*] Installing Java 21..."
if command -v java >/dev/null 2>&1; then
  echo -e "${GREEN}Java already installed: $(java -version 2>&1 | head -n 1)${RESET}"
else
  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get update -y
    if ! sudo apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
      sudo apt-get install -y software-properties-common
      sudo add-apt-repository -y ppa:openjdk-r/ppa
      sudo apt-get update -y
    fi
    sudo apt-get install -y openjdk-21-jdk
  else
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y java-21-openjdk
    else
      sudo yum install -y java-21-openjdk
    fi
  fi
fi

JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
echo "export JAVA_HOME=${JAVA_HOME}" | sudo tee /etc/profile.d/java.sh >/dev/null
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/java.sh >/dev/null
sudo chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh

echo -e "${GREEN}✅ Java installed successfully${RESET}"

# ------------------------
# Install Docker, Git, Maven
# ------------------------
echo "[*] Installing Docker, Git, Maven..."

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
  sudo apt-get install -y docker.io git curl wget
else
  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y docker git curl wget
  else
    sudo yum install -y docker git curl wget
  fi
fi

sudo systemctl enable docker
sudo systemctl start docker

MAVEN_VERSION="3.8.9"
MAVEN_DIR="/opt/apache-maven-${MAVEN_VERSION}"
MAVEN_TAR="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_URL="https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR}"

cd /tmp
curl -fsSLO "${MAVEN_URL}"
sudo tar -xzf "${MAVEN_TAR}" -C /opt/
rm -f "${MAVEN_TAR}"

sudo tee /etc/profile.d/maven.sh >/dev/null <<EOF
export MAVEN_HOME=${MAVEN_DIR}
export PATH=\$PATH:\$MAVEN_HOME/bin
EOF
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
sudo ln -sf ${MAVEN_DIR}/bin/mvn /usr/bin/mvn

echo -e "${GREEN}✅ Maven installed successfully${RESET}"

# ------------------------
# Create Jenkins user and permissions
# ------------------------
if ! id "$JENKINS_USER" &>/dev/null; then
  sudo useradd -m -s /bin/bash "$JENKINS_USER"
fi
sudo usermod -aG docker "$JENKINS_USER"
sudo usermod -aG docker "$DEVOPS_USER" || true
sudo systemctl restart docker

echo -e "${GREEN}==============================================="
echo " Jenkins Agent Setup Completed Successfully!"
echo "===============================================${RESET}"
java -version
mvn -v
docker --version
