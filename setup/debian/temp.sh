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
