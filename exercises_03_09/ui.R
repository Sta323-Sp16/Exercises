library(shiny)

shinyUI(
  fluidPage(
    titlePanel(
      "Capture/Recapture ABC"
    ),
    sidebarPanel(
      numericInput("n_sims","Number of Simulations:", value=10000, min=100, max=1e6),
      hr(),
      h4("Data:"),
      sliderInput("n_marked", "Number marked:", value = 5, min=1, max=20),
      sliderInput("n_sampled", "Number sampled:", value = 7, min=1, max=20),
      sliderInput("n_recaptured", "Number recaptured:", value = 1, min=1, max=5),
      hr(),
      h4("Prior:"),
      selectInput("prior", "Prior for pop. total:", c("Uniform"="unif", "Poisson"="pois")),
      hr(),
      h4("Hyperparametes:"),
      conditionalPanel(
        condition = "input.prior == 'pois'",
        sliderInput("lambda",HTML("Total prior - &lambda;"), value=35, min=10, max=100)
      ),
      conditionalPanel(
        condition = "input.prior == 'unif'",
        sliderInput("unif_range","Total prior - range", value=c(10,100), min=10, max=100)
      )
    ),
    mainPanel(
      h4("Results:"),
      plotOutput("posterior_plot"),
      br(),
      textOutput("messages")
    )
  )
)
