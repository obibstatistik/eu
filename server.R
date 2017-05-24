source("global.R")

shinyServer(function(input, output) {

source("~/.postpass")

json_data_odensebib <- GET("https://www.odensebib.dk/feeds/eudirect")
json_data_odensebib <- content(json_data_odensebib, "text")

data_odensebib_part1 <- json_data_odensebib %>%
  enter_object("nodes") %>%
  gather_array %>%
  enter_object("node") %>%
  spread_values(title = jstring("title"),dato = jstring("Oprettelsesdato"),sti = jstring("Sti") ) %>%
  mutate(type = 'Nyhed') %>%
  select(title,dato,sti,type) %>%
  arrange(dato)
data_odensebib_part2 <- data.frame(
  title = c('Europa Direct Odense','Nyttige EU-links'), 
  dato = c(toString(Sys.Date()),toString(Sys.Date())), 
  sti = c('/page/eu-taettere','/page/udlaengsel-rejser-job-eu'),
  type = c('Side','Side'))
data_odensebib <- rbind(data_odensebib_part1, data_odensebib_part2)
data_odensebib <- data_odensebib %>%
  na.omit() %>%
  filter(dato > (Sys.Date() - 365)) %>%
  rename(titel = title) 

table_data_odensebib <- data_odensebib %>%
  rename(Type = type, Publiceringsdato = dato, Titel = titel, Sti = sti) %>%
  select(Type, Publiceringsdato, Titel, Sti) %>%
  arrange(desc(Type), Publiceringsdato)

output$table_data_odensebib <- renderTable(table_data_odensebib, width = "100%")

webdata <- read.csv("rapport.csv", quote = "") 

webdata2 <- webdata %>%
  mutate(sti = gsub("http://www.odensebib.dk", "", Pages...Index)) %>%
  arrange(desc(Time.Period))  

data <- merge(data_odensebib, webdata2, by = "sti") %>%
  select(type, dato, titel, sti, Time.Period, Page.Views) %>%
  spread(Time.Period, Page.Views) %>%
  rename(Type = type, Publiceringsdato = dato, Titel = titel, Sti = sti) %>%
  select(1,2,3,4,12,13,14,15,16,17,18,6,7,8,9,10,11,5)

#total <- numcolwise(sum)(data)
#total <- sapply(data, typeof)

output$table2 <- renderTable(data, width = "100%")
#output$total <- renderTable(total, width = "100%")
})