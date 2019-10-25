library(rJava) # load and attach 'rJava' now

# install.packages("tabulizerjars")
# install.packages("tabulizer")

library(tabulizer)
library(tabulizerjars)
library(dplyr)
require("utf8")

Sys.setlocale("LC_ALL")
#options(encoding="utf-8")

setwd("G:/Mi unidad/Sede_Talcahuano/Proyectos/CMGA_Reporte")

## Esta funcion es para eliminar columnas sin datos
col_selector <- function(x) {
  return(!(all(is.na(x)) | all(x == "")))
}
####################################################

readtable <- function(pdf, clase="", ...)
{
  ## Aqui hay que indicar en que tabla esta la tabla, de otra forma se toma mucho tiempo en leer todo!
  tab <- extract_tables(pdf)
  
  #### Se deben reescribir los nombres!
  
  temp <- tab[[1]][1,]
  
  data2 <- as.data.frame(tab[[1]][-1,]) %>%
    select_if(col_selector) 
  names(data2) <- c("Licencia", "Distintivo", "Nombre", "Region", "Comuna", "Fecha_Otorgacion", "Fecha_Vencimiento")
  
  
  data2$Clase <- clase
  return(data2)
}

aspirantes <- readtable(pdf="Dintintivos/tablas/Informes_RA_01_10_2019_Aspirantes.pdf", clase="Aspirante")
otros <- readtable(pdf="Dintintivos/tablas/Informes_RA_01_10_2019_Novicio_General_Superior.pdf")
instituciones <- readtable(pdf="Dintintivos/tablas/Informes_RA_01_10_2019_Instituciones.pdf")

temp <- rbind(aspirantes, otros)
temp <- rbind(temp, instituciones)

write.csv(temp, file="distintivos.csv")
