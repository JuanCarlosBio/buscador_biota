#!/usr/bin/env Rscript

#setwd("C:\\Users\\jcge9\\Documents\\buscador_biota")

library(tidyverse)
library(shiny)
library(bslib)
library(glue)
library(htmltools)

link_biota <- "https://www.biodiversidadcanarias.es/biota/especie/"

# Cargar datos
biota_data <- read_tsv("data/processed/biota_data_processed.tsv") %>%
  mutate(id_biota = glue("<br><a href={link_biota}{id_biota}>{id_biota}</a>") %>% lapply(HTML))
  
  # Agregar opción "Todos" a cada filtro
opciones_scientific_name <- c("Todos", unique(biota_data$scientific_name))
opciones_family <- c("Todos", unique(biota_data$family))
opciones_order <- c("Todos", unique(biota_data$order))
opciones_class <- c("Todos", unique(biota_data$class))
opciones_subdivision <- c("Todos", unique(biota_data$subdivision))
opciones_division <- c("Todos", unique(biota_data$division))
opciones_phylo <- c("Todos", unique(biota_data$phylo))
opciones_domain <- c("Todos", unique(biota_data$domain))

# Definir UI
ui <- page_sidebar(
  title = "TABLA PARA BUSCAR ESPECIES EN BIOTA FÁCIL",
  sidebar = sidebar(
    "Filtros",
    selectInput("domain", "Selecciona un Reino:", opciones_domain, selected = "Todos"),
    selectInput("phylo", "Selecciona un Filo:", opciones_phylo, selected = "Todos"),
    selectInput("division", "Selecciona una División:", opciones_division, selected = "Todos"),
    selectInput("subdivision", "Selecciona una Subdivisión:", opciones_subdivision, selected = "Todos"),
    selectInput("class", "Selecciona una Clase:", opciones_class, selected = "Todos"),
    selectInput("order", "Selecciona un orden:", opciones_order, selected = "Todos"),
    selectInput("family", "Selecciona una familia:", opciones_family, selected = "Todos"),
    selectInput("scientific_name", "Selecciona un nombre científico:", opciones_scientific_name, selected = "Todos")
  ),  
  "Especies de Biota, pertenecientes BIOCAN, Gobierno de Canarias",
  card(
    dataTableOutput("tabla_especies")
  )
)

# Definir servidor
server <- function(input, output) {
  filtered_data <- reactive({
    data <- biota_data  # Usamos la base de datos original
    
    # Aplicar los filtros solo si el usuario ha seleccionado una opción diferente de "Todos"
    if (input$domain != "Todos") data <- data %>% filter(domain == input$domain)
    if (input$phylo != "Todos") data <- data %>% filter(phylo == input$phylo)
    if (input$division != "Todos") data <- data %>% filter(division == input$division)
    if (input$subdivision != "Todos") data <- data %>% filter(subdivision == input$subdivision)
    if (input$class != "Todos") data <- data %>% filter(class == input$class)
    if (input$order != "Todos") data <- data %>% filter(order == input$order)
    if (input$family != "Todos") data <- data %>% filter(family == input$family)
    if (input$scientific_name != "Todos") data <- data %>% filter(scientific_name == input$scientific_name)
    
    return(data)  # Devolvemos la tabla filtrada
  })
  
  output$tabla_especies <- renderDataTable({
    filtered_data()
  })
}


shinyApp(ui = ui, server = server)
