#!/usr/bin/env bash
set -e

if [[ -z "${PIP_INSTALL}" ]]; then
    PIP_INSTALL='install'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

python_name="$(basename "${src_dir}" | sed -e 's/-//' | sed -e 's/-/_/g')"
cpu_arch="$(uname -m)"

# -----------------------------------------------------------------------------

venv="${src_dir}/.venv"
download="${src_dir}/download"

# -----------------------------------------------------------------------------

: "${PYTHON=python3}"

# Create virtual environment
echo "Creating virtual environment at ${venv}"
rm -rf "${venv}"
"${PYTHON}" -m venv "${venv}"
source "${venv}/bin/activate"

# Install Python dependencies
echo "Installing Python dependencies"
pip3 ${PIP_INSTALL} --upgrade pip
pip3 ${PIP_INSTALL} --upgrade wheel setuptools

# Install Mycroft Precise
precise_file="${download}/precise-engine_0.3.0_${cpu_arch}.tar.gz"
if [[ ! -s "${precise_file}" ]]; then
    wget -O "${precise_file}" "https://github.com/MycroftAI/mycroft-precise/releases/download/v0.3.0/precise-engine_0.3.0_${cpu_arch}.tar.gz"
fi

# Extract to virtual environment
"${src_dir}/scripts/install-precise.sh" \
    "${precise_file}" "${venv}"

# Install local Rhasspy dependencies if available
grep '^rhasspy-' "${src_dir}/requirements.txt" | \
    xargs pip3 ${PIP_INSTALL} -f "${download}"

pip3 ${PIP_INSTALL} -r requirements.txt

# Optional development requirements
pip3 ${PIP_INSTALL} -r requirements_dev.txt || \
    echo "Failed to install development requirements"

# -----------------------------------------------------------------------------

echo "OK"
