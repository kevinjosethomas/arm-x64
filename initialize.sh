#!/bin/bash

set -e

echo "Cloning submodules..."
git submodule update --init --recursive


echo "Creating conda environment..."
conda create -y -n lerobot python=3.10

echo "Activating conda environment..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate lerobot

echo "Installing ffmpeg..."
conda install -y ffmpeg=7.1.1 -c conda-forge

echo "Installing lerobot..."
pip install "lerobot[all]"

echo "Initialization complete!"

