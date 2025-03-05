## Instrucciones básicas para un Makefile
# Rule
# target: prerequisites/depencies
# 	command 

## Descargar los datos de BIOTA
data/raw/biota_species.csv: code/download_data.sh
	bash code/download_data.sh

## Procesar los datos de BIOTA 
data/processed/biota_data_processed.tsv: code/processed_data.R data/raw/biota_species.csv
	Rscript code/processed_data.R