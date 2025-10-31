#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

DEVICE=$1
OPERATION=$2
shift 2

CONFIG_FILE="$CONFIG_DIR/${DEVICE}.conf"
source "$CONFIG_FILE"

case $OPERATION in
    teleop)
        lerobot-teleoperate \
            --robot.type="$ROBOT_TYPE" \
            --robot.port="$ROBOT_PORT" \
            --robot.id="$ROBOT_ID" \
            --robot.cameras="$ROBOT_CAMERAS" \
            --teleop.type="$TELEOP_TYPE" \
            --teleop.port="$TELEOP_PORT" \
            --teleop.id="$TELEOP_ID" \
            "$@"
        ;;
    
    record)
        lerobot-record \
            --robot.type="$ROBOT_TYPE" \
            --robot.port="$ROBOT_PORT" \
            --robot.id="$ROBOT_ID" \
            --robot.cameras="$ROBOT_CAMERAS" \
            --teleop.type="$TELEOP_TYPE" \
            --teleop.port="$TELEOP_PORT" \
            --teleop.id="$TELEOP_ID" \
            --display_data=true \
            "$@"
        ;;
    
    async-server)
        python -m lerobot.async_inference.policy_server \
            --host=0.0.0.0 \
            --port=8080 \
            "$@"
        ;;
    
    async-client)
        SERVER_ARG=$1
        shift
        if [ "$SERVER_ARG" = "pc" ]; then
            SERVER_ADDRESS="$PC_ADDRESS"
        else
            SERVER_ADDRESS="$SERVER_ARG"
        fi
        python3 -m lerobot.async_inference.robot_client \
            --server_address="$SERVER_ADDRESS" \
            --robot.type="$ROBOT_TYPE" \
            --robot.port="$ROBOT_PORT" \
            --robot.id="$ROBOT_ID" \
            --robot.cameras="$ROBOT_CAMERAS" \
            --policy_device=cuda \
            --aggregate_fn_name=weighted_average \
            --debug_visualize_queue_size=True \
            "$@"
        ;;
    
    inference)
        lerobot-record \
            --robot.type="$ROBOT_TYPE" \
            --robot.port="$ROBOT_PORT" \
            --robot.cameras="$ROBOT_CAMERAS" \
            --robot.id="$ROBOT_ID" \
            --display_data=false \
            --teleop.type="$TELEOP_TYPE" \
            --teleop.port="$TELEOP_PORT" \
            --teleop.id="$TELEOP_ID" \
            "$@"
        ;;
    
    calibrate)
        lerobot-calibrate \
            --robot.type="$ROBOT_TYPE" \
            --robot.port="$ROBOT_PORT" \
            --robot.id="$ROBOT_ID" \
            "$@"
        ;;
    
esac
