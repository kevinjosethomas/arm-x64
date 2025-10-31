# arm-x64

A monorepo for all scripts, configs, and policies for my Lerobot SO101 arms so it's easier to manage processes across my Macbook (inference), PC (training+inference), phone (camera), and Runpod GPUs (training+inference).

## devices

1. Macbook Air (M2, 15-inch)
2. Desktop (RTX 2070 Super, Ubuntu 24.04)
3. Runpod GPUs

## components

1. arm (follower arm)
2. x64 (leader arm)
3. iphone 14 camera

## setup

### runpod setup

```bash
./setup_runpod.sh
```

This will clone submodules, create a conda environment, and install dependencies.

## scripts

Device-specific configs are in `configs/mac.conf`, `configs/pc.conf`, and `configs/runpod.conf` (robot ports, camera paths, etc).

### teleoperation

```bash
./robot.sh mac teleop
./robot.sh pc teleop
```

### record dataset

```bash
./robot.sh mac record \
    --dataset.repo_id=kevinjosethomas/so101-orange-plate \
    --dataset.num_episodes=50 \
    --dataset.single_task="Pick up the orange and place it on the plate" \
    --dataset.reset_time=10

./robot.sh pc record \
    --dataset.repo_id=kevinjosethomas/so101-orange-plate \
    --dataset.num_episodes=50 \
    --dataset.single_task="Pick up the orange and place it on the plate" \
    --dataset.reset_time=10
```

### inference

#### sync

```bash
./robot.sh pc inference \
    --dataset.repo_id=kevinjosethomas/eval_smolvla_orange_plate \
    --dataset.single_task="Pick up the orange and place it on the plate" \
    --policy.path=kevinjosethomas/smolvla_orange_plate
```

#### async

```bash
# start server
./robot.sh async-server

# start client (mac -> pc)
./robot.sh mac async-client pc \
    --task="Pick up the orange and place it on the plate" \
    --policy_type=smolvla \
    --pretrained_name_or_path=kevinjosethomas/smolvla_orange_plate \
    --actions_per_chunk=50 \
    --chunk_size_threshold=0.5

# or (mac -> runpod gpu)
./robot.sh mac async-client runpod_ip_address:8080 \
    --task="Pick up the orange and place it on the plate" \
    --policy_type=smolvla \
    --pretrained_name_or_path=kevinjosethomas/smolvla_orange_plate \
    --actions_per_chunk=50 \
    --chunk_size_threshold=0.5

# or (pc -> pc)
./robot.sh pc async-client 127.0.0.1:8080 \
    --task="Pick up the orange and place it on the plate" \
    --policy_type=smolvla \
    --pretrained_name_or_path=kevinjosethomas/smolvla_orange_plate \
    --actions_per_chunk=50 \
    --chunk_size_threshold=0.5

# or (pc -> runpod gpu)
./robot.sh pc async-client runpod_ip_address:8080 \
    --task="Pick up the orange and place it on the plate" \
    --policy_type=smolvla \
    --pretrained_name_or_path=kevinjosethomas/smolvla_orange_plate \
    --actions_per_chunk=50 \
    --chunk_size_threshold=0.5
```
