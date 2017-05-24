source("global.R")

dashboardPage(
  skin = "black",
  
  dashboardHeader(
    title = "EU"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("EU statistik", tabName = "eu", icon = icon("database", lib="font-awesome")
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "eu",
        
        box(width = 12,
            h3("EU"),
            "EU statistik for Odensebib.dk" 
        ),
        
        fluidRow(
          column(12,
                 box(width = 12,
                     h3("Sider + nyheder med sidevisninger publiceret det seneste år på Odense Bibliotekerne"),
                     tableOutput('table2'),
                     tableOutput('total')
                 ),
                 box(width = 12,
                     h3("Alle sider + nyheder publiceret det seneste år på Odense Bibliotekerne"),
                     tableOutput('table_data_odensebib'),
                     tableOutput('table3')
                 )
          )
        )
      )
      
    )
  )
)