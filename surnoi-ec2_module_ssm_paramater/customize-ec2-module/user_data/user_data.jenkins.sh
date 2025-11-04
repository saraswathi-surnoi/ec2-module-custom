#!/bin/bash
set -euo pipefail

# ==============================
# Jenkins Master Setup Script
# ==============================

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[36m"
RESET="\e[0m"

LOG_FILE="/var/log/jenkins_master_setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo -e "${BLUE}==============================================="
echo " Jenkins Master Setup Script - Starting "
echo -e "===============================================${RESET}"

# -------------------------------------------------------
# Detect OS
# -------------------------------------------------------
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo -e "${RED} Cannot detect OS. Exiting...${RESET}"
  exit 1
fi

echo -e "${YELLOW}Detected OS:${RESET} $OS"

# -------------------------------------------------------
# Install Java 21
# -------------------------------------------------------
install_java() {
  echo -e "${BLUE}[*] Installing Java 21...${RESET}"
  if command -v java >/dev/null 2>&1; then
    echo -e "${GREEN}Java already installed: $(java -version 2>&1 | head -n 1)${RESET}"
    return
  fi

  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get update -y
    if ! sudo apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
      echo "Adding OpenJDK 21 repository..."
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

  JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
  echo "export JAVA_HOME=${JAVA_HOME}" | sudo tee /etc/profile.d/java.sh >/dev/null
  echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/java.sh >/dev/null
  sudo chmod +x /etc/profile.d/java.sh
  source /etc/profile.d/java.sh

  echo -e "${GREEN}✅ Java installed successfully: $(java -version 2>&1 | head -n 1)${RESET}"
}

# -------------------------------------------------------
# Install Maven
# -------------------------------------------------------
install_maven() {
  MAVEN_VERSION="3.8.9"
  MAVEN_DIR="/opt/apache-maven-${MAVEN_VERSION}"
  MAVEN_TAR="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  MAVEN_URL="https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR}"

  echo -e "${BLUE}[*] Installing Apache Maven ${MAVEN_VERSION}...${RESET}"

  if command -v mvn >/dev/null 2>&1; then
    echo -e "${GREEN}Maven already installed: $(mvn -v | head -n 1)${RESET}"
    return
  fi

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

  echo -e "${GREEN}✅ Maven installed successfully: $(mvn -v | head -n 1)${RESET}"
}

# -------------------------------------------------------
# Install AWS CLI
# -------------------------------------------------------
install_aws_cli() {
  echo -e "${BLUE}[*] Installing AWS CLI v2...${RESET}"
  if command -v aws >/dev/null 2>&1; then
    echo -e "${GREEN}AWS CLI already installed: $(aws --version)${RESET}"
    return
  fi
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo apt-get install -y unzip || sudo yum install -y unzip
  unzip -q awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
  echo -e "${GREEN}✅ AWS CLI installed: $(aws --version)${RESET}"
}

# -------------------------------------------------------
# Jenkins Installation
# -------------------------------------------------------
install_jenkins() {
  echo -e "${BLUE}[*] Installing Jenkins...${RESET}"

  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null
    sudo apt-get update -y
    sudo apt-get install -y jenkins
  else
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y jenkins
    else
      sudo yum install -y jenkins
    fi
  fi

  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  echo -e "${GREEN}✅ Jenkins installed and started successfully.${RESET}"
}

# -------------------------------------------------------
# Install Docker & Git
# -------------------------------------------------------
install_docker_git() {
  echo -e "${BLUE}[*] Installing Docker and Git...${RESET}"
  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt-get install -y docker.io git
  else
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y docker git
    else
      sudo yum install -y docker git
    fi
  fi

  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker jenkins
  echo -e "${GREEN}✅ Docker & Git installed.${RESET}"
}

# -------------------------------------------------------
# Main Execution
# -------------------------------------------------------
install_java
install_maven
install_aws_cli
install_docker_git
install_jenkins

echo -e "${GREEN}==============================================="
echo " Jenkins Master Setup Completed Successfully!"
echo "===============================================${RESET}"
echo " Jenkins is running on: http://<Public-IP>:8080"
echo
echo " Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Jenkins still initializing..."
