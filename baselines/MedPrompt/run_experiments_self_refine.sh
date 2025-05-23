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

for RUN_NUMBER in 1 2; do
    for model in gpt-4o-mini gpt-4o; do
    {
        for dataset in medqa pubmedqa medmcqa medbullets mmlu mmlu-pro medexqa medxpertqa-r medxpertqa-u; do
            mkdir -p $LOGS_DIR/run-${RUN_NUMBER}/$dataset 
            for split in test_hard; do
                echo "Running $model on $dataset $split"
                model_filename=$(echo $model | tr '/' '_')
                log_file=$LOGS_DIR/run-${RUN_NUMBER}/$dataset/${model_filename}_${dataset}_${split}.log
                error_file=$LOGS_DIR/run-${RUN_NUMBER}/$dataset/${model_filename}_${dataset}_${split}.err
                python self_refine.py --dataset_name $dataset --dataset_dir $DATA_DIR/$dataset/ --split $split --model $model --output_files_folder ../../output/run-${RUN_NUMBER}/ --num_processes 4 --num_rounds 3 > $log_file 2> $error_file
            done
        done
    } &
    done
    wait
done