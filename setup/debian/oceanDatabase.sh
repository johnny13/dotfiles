#!/usr/bin/env bash
#| Version 0.1.1

##
## Libraries & Globals
## -------------------------
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "${BASEDIR}" || exit

source ../../.run/ansi

echoMiniHeader()
{
    clear
    ansi::color 11
    cat "../../.run/bg_sm.txt"
    echo ""
    ansi::resetForeground
}

# Call the function after its definition
echoMiniHeader

# Update package list and upgrade system
ansi::color 10
echo "Updating package list and upgrading system..."
ansi::resetForeground
sudo apt update && sudo apt upgrade -y

# Install PostgreSQL
ansi::color 10
echo "Installing PostgreSQL..."
ansi::resetForeground
sudo apt install -y postgresql postgresql-contrib

# Enable and start PostgreSQL service
ansi::color 10
echo "Enabling and starting PostgreSQL service..."
ansi::resetForeground
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Install pgAdmin4
ansi::color 10
echo "Installing pgAdmin4..."
ansi::resetForeground
sudo apt install -y curl gnupg
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/pgadmin.gpg
echo "deb [signed-by=/usr/share/keyrings/pgadmin.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list
sudo apt update
sudo apt install -y pgadmin4

# Configure pgAdmin4
ansi::color 10
echo "Configuring pgAdmin4..."
ansi::resetForeground
sudo /usr/pgadmin4/bin/setup-web.sh

# Completion message
ansi::color 10
echo "PostgreSQL and pgAdmin4 installation completed!"
ansi::resetForeground

# Install PostGIS extension
ansi::color 10
echo "Installing PostGIS extension..."
ansi::resetForeground
sudo apt install -y postgis postgresql-$(psql -V | awk '{print $3}' | cut -d. -f1,2)-postgis-3

# Verify PostGIS installation
ansi::color 10
echo "Verifying PostGIS installation..."
ansi::resetForeground
sudo -u postgres psql -c "CREATE EXTENSION IF NOT EXISTS postgis;"
sudo -u postgres psql -c "SELECT PostGIS_Full_Version();"

# Completion message for PostGIS
ansi::color 10
echo "PostGIS installation and configuration completed!"
ansi::resetForeground
