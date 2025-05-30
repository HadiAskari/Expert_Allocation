#!/bin/bash

# Set the root data path
root_data_path="/nas02/Hadi/Model-Selection-IF/alphalora"

# Define data paths using the root path
data_paths=(
  # "$root_data_path/datasets/glue_rte_all.hf/"
  "$root_data_path/datasets/glue_mrpc_all.hf/"
  "$root_data_path/datasets/glue_cola_all.hf/"
  "$root_data_path/datasets/qa_text_scienceq_all.hf/"
  "$root_data_path/datasets/qa_commonq_all.hf/"
  "$root_data_path/datasets/qa_openbook_all.hf/"
)

# Loop through data paths and run experiments
for data_path in "${data_paths[@]}"; do
  # Extract filename from data path
  filename=$(basename "$data_path")
  # Remove trailing slash if present
  filename=${filename%/}
  filename=${filename%.hf}
  echo $filename
  
#"Qwen/Qwen2.5-3B"  \     #"mistralai/Mistral-7B-v0.1"

mkdir -p "$root_data_path/gemma_160_$filename"

  # Run experiment
    CUDA_VISIBLE_DEVICES=0,1,2,3 python mola_training_gemma.py \
  --base_model "google/gemma-7b" \
  --data_path "$data_path" \
  --output_dir "$root_data_path/gemma_160_$filename" \
  --batch_size 128 \
  --micro_batch_size 8 \
  --num_epochs 3 \
  --learning_rate 3e-4 \
  --cutoff_len 256 \
  --val_set_size 1 \
  --lora_r "8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8" \
  --lora_alpha 16 \
  --lora_dropout 0.05 \
  --lora_target_modules "q_proj,v_proj,k_proj,o_proj,gate_proj,down_proj,up_proj" \
  --number_experts "2,4,7,8,8,7,6,5,7,6,7,4,5,4,3,3,4,6,4,5,7,8,7,9,6,7,6,5" \
  --top_k "2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" \
  --train_on_inputs \
  --group_by_length \
  --add_eos_token \
  --wandb_run_name "gemma_160_$filename"
done

#alphalora
#1,3,5,4,5,5,4,4,3,4,3,2,2,3,3,4,9,4,7,7,7,7,7,7,9,7,6,8,6,7,4,3
#--number_experts "1,1,3,3,4,4,6,6,5,6,6,6,6,6,6,6,5,6,6,5,5,6,5,6,6,7,5,5,4,5,5,4" \



#mrpc 2.5 negative
#"1,4,6,3,4,7,8,11,5,12,10,12,7,9,7,5,8,5,4,1,6,6,1,1,6,3,1,3,1,1,1,1" \
#"1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,1,1,2,2,1,2,1,1,1,1


#cola 2.5 negative
# 1,9,10,8,9,12,10,7,9,9,9,8,6,9,6,4,7,3,2,1,3,4,2,1,4,1,1,1,1,1,1,1
# 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,1,2,1,1,1,1,1,1,1

#text_science_q 2.5 negative
# "1,1,1,1,2,2,4,6,4,6,6,6,6,6,7,7,7,7,6,3,7,6,6,5,5,6,7,6,5,6,7,5" 
# "1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"


#commonq 2.5 negative
# 1,8,6,9,7,6,10,7,7,9,8,10,7,9,7,3,7,6,5,2,6,5,2,1,1,3,1,2,1,1,2,1
# 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,1,2,1,1,2,1


#openbook 2.5 negative
#1,5,4,8,8,5,8,7,8,6,7,7,7,6,6,6,6,6,7,5,7,5,3,2,2,4,3,4,2,2,2,1
#"1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1"


#rte 2.5 negative
# 1,1,3,5,4,5,8,8,8,9,9,8,8,7,7,7,6,7,6,4,4,7,4,3,6,4,2,3,1,3,1,1
# 1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1


#rte 1.5
  # --number_experts "1,1,4,5,5,5,7,7,7,4,8,7,7,7,6,7,6,6,6,5,5,6,5,4,6,5,3,4,2,4,3,2" \
  # --top_k "1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" \


#mrpc 1.5
  # --number_experts "1,5,6,4,5,7,7,9,7,9,9,9,7,8,7,5,7,5,5,2,6,6,3,1,6,4,2,4,1,1,1,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1" \


#cola 1.5
  # --number_experts "1,7,9,7,8,9,9,7,8,8,8,7,6,8,6,5,7,4,4,3,4,5,3,2,5,2,1,2,1,2,1,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,2,1,1"


#openbook 1.5
  # --number_experts "1,5,5,7,7,5,7,6,7,6,7,6,6,6,6,6,6,6,6,5,6,5,4,3,3,4,4,4,3,3,3,2" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" \


#commonq 1.5
  # --number_experts "3,7,6,7,6,6,8,6,9,8,7,8,6,7,7,4,7,6,5,4,6,5,3,1,2,4,2,3,1,2,3,1" \
  # --top_k "2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,1" \




#text_science_q 1.5

  # --number_experts "1,2,3,1,3,3,4,6,4,6,6,6,6,6,6,6,6,6,6,5,6,6,6,5,5,6,6,6,5,6,6,5" \
  # --top_k "1,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" \






#rte

#1,1,3,5,4,5,8,8,8,8,9,8,8,7,7,7,6,7,6,4,4,7,4,3,6,4,2,3,1,3,2,1
#"1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,1,2,2,1"


#mrpc
  # --number_experts "1,4,6,3,4,7,8,11,5,12,10,12,7,9,7,5,8,5,4,1,6,6,1,1,6,3,1,3,1,1,1,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,1,1,2,2,1,2,1,1,1,1"


#cola
  # --number_experts "1,9,10,8,9,12,10,7,9,9,9,8,6,9,6,4,7,3,2,1,3,4,2,1,4,1,1,1,1,1,1,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,1,2,1,1,1,1,1,1,1" \

#openbook

  # --number_experts "1,5,5,8,7,5,8,7,8,5,7,7,7,6,6,6,6,6,7,5,7,5,3,2,2,4,3,4,2,2,3,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,2,2,2,1" \

#commonq

  # --number_experts "1,8,6,8,7,6,10,6,11,9,8,9,7,8,7,3,7,6,5,2,6,5,2,1,1,3,1,2,1,1,2,1" \
  # --top_k "1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,2,1,2,1,1,2,1" \

#textScienceQ

  # --number_experts "1,1,2,1,2,2,4,6,4,6,6,6,6,6,7,6,7,7,6,3,7,6,6,5,5,6,7,6,5,6,7,5" \
  # --top_k "1,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2" \