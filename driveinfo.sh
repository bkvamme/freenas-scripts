#!/bin/sh
# For drives that only have a single partition (no swap space)
singlepartdrives="ada0 ada1 ada2 ada3 ada4 ada5 ada6 ada7 da1 da2 da3 da4 da5 "
# For drives that have two partitions (with swapspace, default)
dualpartdrives="da0 da6 da7 da8 da9 da10 da11 da12 da13"
# Due to naming conventions in BSD for NVMe drives, the nvd convention is used for drives, and nvme is used for the controller.
# To use in this script, just use the number associated. Example: nvme0 = nvd0 = 0
nvmedrives="0 1"

echo ""
echo "+========+============================================+======================+===========================+==========+======+===========+"
echo "| Device | GPTID                                      | Serial               | Model                     | Capacity | Bay | Tray | Purchased |"
echo "+========+============================================+======================+===========================+==========+=====+======+===========+"
for drive in $singlepartdrives
do
    gptid=`glabel status -s "${drive}p1" | awk '{print $1}'`
    serial=`smartctl -i /dev/${drive} | grep "Serial Number" | awk '{print $3}'`
        model=`smartctl -i /dev/${drive} | grep "Device Model" | awk '{print $3 $4}'`
        capacity=`smartctl -i /dev/${drive} | grep "Capacity" | awk '{print $5 $6}' | tr -d "[]"`
    printf "| %-6s | %-42s | %-20s | %-25s | %-8s | %-3s | %-4s | %-9s |\n" "$drive" "$gptid" "$serial" "$model" "$capacity"
    echo "+--------+--------------------------------------------+----------------------+---------------------------+----------+-----+------+-----------+"
done
for drive in $dualpartdrives
do
    gptid=`glabel status -s "${drive}p2" | awk '{print $1}'`
    serial=`smartctl -i /dev/${drive} | grep "Serial Number" | awk '{print $3}'`
        model=`smartctl -i /dev/${drive} | grep "Device Model" | awk '{print $3 $4}'`
        capacity=`smartctl -i /dev/${drive} | grep "Capacity" | awk '{print $5 $6}' | tr -d "[]"`
    printf "| %-6s | %-42s | %-20s | %-25s | %-8s | %-3s | %-4s | %-9s |\n" "$drive" "$gptid" "$serial" "$model" "$capacity"
    echo "+--------+--------------------------------------------+----------------------+---------------------------+----------+-----+------+-----------+"
done
for drive in $nvmedrives
do
    gptid=`glabel status -s "nvd${drive}p2" | awk '{print $1}'`
    serial=`smartctl -i /dev/nvme${drive} | grep "Serial Number" | awk '{print $3}'`
    model=`smartctl -i /dev/nvme${drive} | grep "Model Number" | awk '{print $3 $4}'`
    capacity=`smartctl -i /dev/nvme${drive} | grep "Capacity" | awk '{print $5 $6}' | tr -d "[]"`
    printf "| %-6s | %-42s | %-20s | %-25s | %-8s | %-3s | %-4s | %-9s |\n" "nvme$drive" "$gptid" "$serial" "$model" "$capacity"
    echo "+--------+--------------------------------------------+----------------------+---------------------------+----------+-----+------+-----------+"
done
echo ""
