#!/bin/bash
# docker run -it --cap-add ipc_lock <container_name>

TV_IP="$1"
SDB='/home/tizen/tizen-studio/tools/sdb'
TIZEN='/home/tizen/tizen-studio/tools/ide/bin/tizen'
RELEASE='https://github.com/fgl27/smarttv-twitch/releases/download/4.0.1_V5/release_4_0_1_V5.zip'
KEYRING_PASSWORD='PASSWORD'

# Enable keyring
echo "${KEYRING_PASSWORD}" | gnome-keyring-daemon --unlock

# Download project
project_dir='/home/tizen/twitch-app'
wget "${RELEASE}"
filename=$(echo "${RELEASE##*/}")
mkdir -p "${project_dir}"
unzip "${filename}" -d "${project_dir}"

# Generate certificate
certificate_dir='/home/tizen/certificate'
mkdir -p "${certificate_dir}"
random_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
name='twitch-certificate'
${TIZEN} certificate --alias "${name}" --name "${name}" --filename "${name}" --password "${random_password}" -- "${certificate_dir}"
${TIZEN} security-profiles add --name "${name}" --author "${certificate_dir}/${name}.p12" --password "${random_password}"

# Build project
output_dir="${project_dir}/output"
${TIZEN} build-web --output "${output_dir}" -- "${project_dir}"
${TIZEN} package --type wgt --sign ${name} -- "${output_dir}"

# Install app on remote TV
${SDB} start-server
${SDB} connect "${TV_IP}"
${TIZEN} install -n "${output_dir}/SmartTV.wgt"
