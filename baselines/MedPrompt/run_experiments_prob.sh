#!/bin/bash
#SBATCH --job-name=medagents_experiments
#SBATCH --output=logs/medagents_experiments.log
#SBATCH --error=logs/medagents_experiments.err
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --partition=scavenge

LOGS_DIR=logs
DATA_DIR=../../data

for model in Qwen/QwQ-32B; do
    {
        for dataset in 'medqa' 'pubmedqa' 'medmcqa' 'medbullets' 'mmlu' 'mmlu-pro' 'medexqa' 'medxpertqa-r' 'medxpertqa-u'; do
        mkdir -p $LOGS_DIR/$dataset 
            for split in test; do
                echo "Running $model on $dataset $split"
                model_filename=$(echo $model | tr '/' '_')
                log_file=$LOGS_DIR/$dataset/${model_filename}_${dataset}_${split}.log
                error_file=$LOGS_DIR/$dataset/${model_filename}_${dataset}_${split}.err
                python prob.py --dataset_name $dataset --dataset_dir $DATA_DIR/$dataset/ --split $split --model $model --output_files_folder ../../output/ --num_processes 4 > $log_file 2> $error_file
            done
        done
    } &
done
wait