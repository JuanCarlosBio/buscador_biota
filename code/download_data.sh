#!/usr/bin/env bash

## URL de Biota
biota_link="https://www.biodiversidadcanarias.es/biota/especies/export?pagina=1&tipoBusqueda=NOMBRE&searchSpeciesTabs=fastSearchTab&orderBy=nombreCientifico&orderForm=true"

## Descargar los datos de Biota
wget -P data/ -O data/raw/biota_species.csv $biota_link -N -q
