The goal of this file is to verify that the system is properly configured for the application to run. It checks for necessary dependencies, environment variables, and configuration files, ensuring that everything is set up correctly before the application starts. It generates the following shell scripts setup/env-setup.sh that exports required environment variables based on the configuration found in lasso-conf.json and inc/lasso-configuration.py, setup/dependencies-check.sh that checks for required dependencies and installs any that are missing, setup/system-check.sh that creates installation folders, copies the files into those folders, places a symbolic link to our app in the users path, and generates a lasso.desktop file for easy access from the applications menu. finally it creates setup/install.sh that runs all the previous scripts in order to fully configure the system for the application to run.
#!/bin/bash

# Path to the configuration file
CONFIG_FILE="lasso-conf.json"   
# Path to the output environment setup script
ENV_SETUP_SCRIPT="setup/env-setup.sh"
# Path to the dependencies check script
DEPENDENCIES_CHECK_SCRIPT="setup/dependencies-check.sh"
# Path to the system check script
SYSTEM_CHECK_SCRIPT="setup/system-check.sh"
# Path to the install script
INSTALL_SCRIPT="setup/install.sh"   
# Function to generate env-setup.sh
generate_env_setup_script() {
    echo "#!/bin/bash" > $ENV_SETUP_SCRIPT
    echo "" >> $ENV_SETUP_SCRIPT
    echo "# Load configuration from $CONFIG_FILE" >> $ENV_SETUP_SCRIPT
    echo "CONFIG_FILE=\"$CONFIG_FILE\"" >> $ENV_SETUP_SCRIPT
    echo "" >> $ENV_SETUP_SCRIPT
    echo "if [ -f \$CONFIG_FILE ]; then" >> $ENV_SETUP_SCRIPT
    echo "    while IFS= read -r line; do" >> $ENV_SETUP_SCRIPT
    echo "        if [[ \$line == *\":\"* ]]; then" >> $ENV_SETUP_SCRIPT
    echo "            key=\$(echo \$line | cut -d':' -f1 | tr -d ' \"')" >> $ENV_SETUP_SCRIPT
    echo "            value=\$(echo \$line | cut -d':' -f2- | tr -d ' \",\"')" >> $ENV_SETUP_SCRIPT
    echo "            export \$key=\"\$value\"" >> $ENV_SETUP_SCRIPT
    echo "        fi" >> $ENV_SETUP_SCRIPT
    echo "    done < <(grep '\"paths\"' -A 10 \$CONFIG_FILE | grep -E '\"[a-zA-Z_]+\":')" >> $ENV_SETUP_SCRIPT
    echo "else" >> $ENV_SETUP_SCRIPT
    echo "    echo \"Configuration file \$CONFIG_FILE not found!\"" >> $ENV_SETUP_SCRIPT
    echo "fi" >> $ENV_SETUP_SCRIPT
    chmod +x $ENV_SETUP_SCRIPT
    echo "Generated $ENV_SETUP_SCRIPT"
}   
# Function to generate dependencies-check.sh
generate_dependencies_check_script() {
    echo "#!/bin/bash" > $DEPENDENCIES_CHECK_SCRIPT
    echo "" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "# List of required dependencies" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "REQUIRED_DEPENDENCIES=(\"python3\" \"pip3\" \"git\" \"curl\")" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "for DEP in \"\${REQUIRED_DEPENDENCIES[@]}\"; do" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "    if ! command -v \$DEP &> /dev/null; then" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "        echo \"\$DEP could not be found. Installing...\"" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "        sudo apt-get install -y \$DEP" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "    else" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "        echo \"\$DEP is already installed.\"" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "    fi" >> $DEPENDENCIES_CHECK_SCRIPT
    echo "done" >> $DEPENDENCIES_CHECK_SCRIPT
    chmod +x $DEPENDENCIES_CHECK_SCRIPT
    echo "Generated $DEPENDENCIES_CHECK_SCRIPT"
}   
# Function to generate system-check.sh
generate_system_check_script() {
    echo "#!/bin/bash" > $SYSTEM_CHECK_SCRIPT
    echo "" >> $SYSTEM_CHECK_SCRIPT
    echo "# Create installation directories" >> $SYSTEM_CHECK_SCRIPT
    echo "INSTALL_DIR=\"\$HOME/.lasso\"" >> $SYSTEM_CHECK_SCRIPT
    echo "mkdir -p \$INSTALL_DIR" >> $SYSTEM_CHECK_SCRIPT
    echo "" >> $SYSTEM_CHECK_SCRIPT
    echo "# Copy application files to installation directory" >> $SYSTEM_CHECK_SCRIPT
    echo "cp -r * \$INSTALL_DIR" >> $SYSTEM_CHECK_SCRIPT
    echo "" >> $SYSTEM_CHECK_SCRIPT
    echo "# Create symbolic link to application in /usr/local/bin" >> $SYSTEM_CHECK_SCRIPT
    echo "sudo ln -s \$INSTALL_DIR/lasso.py /usr/local/bin/lasso" >> $SYSTEM_CHECK_SCRIPT
    echo "" >> $SYSTEM_CHECK_SCRIPT
    echo "# Create desktop entry for easy access" >> $SYSTEM_CHECK_SCRIPT
    echo "DESKTOP_FILE=\"/usr/share/applications/lasso.desktop\"" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"[Desktop Entry]\" > \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"Name=Lasso\" >> \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"Exec=/usr/local/bin/lasso\" >> \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"Icon=\$INSTALL_DIR/icon.png\" >> \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"Type=Application\" >> \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    echo "echo \"Categories=Utility;\" >> \$DESKTOP_FILE" >> $SYSTEM_CHECK_SCRIPT
    chmod +x $SYSTEM_CHECK_SCRIPT
    echo "Generated $SYSTEM_CHECK_SCRIPT"
}   
# Function to generate install.sh
generate_install_script() {
    echo "#!/bin/bash" > $INSTALL_SCRIPT
    echo "" >> $INSTALL_SCRIPT
    echo "# Run environment setup" >> $INSTALL_SCRIPT
    echo "bash $ENV_SETUP_SCRIPT" >> $INSTALL_SCRIPT
    echo "" >> $INSTALL_SCRIPT
    echo "# Run dependencies check" >> $INSTALL_SCRIPT
    echo "bash $DEPENDENCIES_CHECK_SCRIPT" >> $INSTALL_SCRIPT
    echo "" >> $INSTALL_SCRIPT
    echo "# Run system check" >> $INSTALL_SCRIPT
    echo "bash $SYSTEM_CHECK_SCRIPT" >> $INSTALL_SCRIPT
    chmod +x $INSTALL_SCRIPT
    echo "Generated $INSTALL_SCRIPT"
}   
# Generate all scripts
generate_env_setup_script
generate_dependencies_check_script
generate_system_check_script
generate_install_script
echo "Setup configuration scripts generated successfully."
