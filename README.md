# arm-x64

A monorepo for all scripts, configs, and policies for my Lerobot SO101 arms so it's easier to manage processes across my Macbook (inference), PC (training+inference), phone (camera), and Runpod GPUs (training+inference).

## setup

```bash
./initialize.sh
```

- On Mac, I use Continuity Camera to stream the iPhone camera, which serves as the top-down view.
- On PC, I use DroidCam and OBS to stream the phone camera, which you can setup by following the instructions [here](https://huggingface.co/docs/lerobot/en/cameras?use+phone=Linux#use-your-phone).

## scripts

Device-specific configs are in `configs/mac.conf`, `configs/pc.conf`, and `configs/runpod.conf` (robot ports, camera paths, etc).

### calibration

```bash
./robot.sh mac calibrate
./robot.sh pc calibrate
```

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

### training

```bash
lerobot-train \
    --dataset.repo_id=kevinjosethomas/so101-orange-plate \
    --policy.type=smolvla \
    --output_dir=outputs/train/smolvla_orange_plate \
    --job_name=smolvla_orange_plate \
    --policy.device=cuda \
    --wandb.enable=true \
    --policy.repo_id=kevinjosethomas/smolvla_orange_plate
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
