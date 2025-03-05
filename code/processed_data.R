#!/usr/bin/env Rscript

df_biota <- readr::read_delim("data/raw/biota_species.csv", delim = ";", 
                              locale=readr::locale(encoding="latin1")) |> 
    dplyr::select(
        "id_biota" = `Código`,
        scientific_name = Especie,
        "name"=`Nombre común/vulgar`,
        "family" = Familia,
        "order" = Orden ,
        "class" = Clase,
        "subdivision" = `Subdivisión`,
        "division" = `División`,
        "phylo" = Filo,
        "domain" = Reino,
        "endemicity" = Endemicidad,
        "presence" = Presencia 
    ) |>
    readr::write_tsv("data/processed/biota_data_processed.tsv")