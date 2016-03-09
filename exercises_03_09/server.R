library(shiny)

shinyServer(
  function(input, output, session) 
  {
    prior_samps = reactive(
      {
        n_total = numeric()
        if (input$prior == "unif")
        {
          n_total = sample(input$unif_range[1]:input$unif_range[2], 
                           input$n_sims, replace=TRUE)
        } else {
          n_total = rpois(input$n_sims, input$lambda)
        }
        
        return(n_total)
      }
    )
    
    sims = reactive(
      {
        generative_model = function(n_total)
        {
          marked = rep(1, n_marked)
          unmarked = rep(0, n_total-n_marked)
          
          pop = c(marked, unmarked)
          sum(sample(pop, n_sampled, replace=FALSE))
        }
        
        sapply(prior_samps(), generative_model)
      }
    )
    
    posterior = reactive(
      {
        prior_samps()[sims() == input$n_recaptured]
      }
    )
    
    output$posterior_plot = renderPlot(
      {
        plot(density(posterior()), main = "Posterior")
        abline(v=mean(posterior()),col='red')
        abline(v=median(posterior()),col='blue')
        
        if (input$prior == "unif")
        {
          x = input$unif_range[1]:input$unif_range[2]
          y = rep(1/(input$unif_range[2]-input$unif_range[1]), length(x))
          lines(x,y, lty=2,col='grey')
        } else {
          x = 10:100
          y = dpois(x, input$lambda)
          lines(x,y, lty=2,col='grey')
        }
      }
    )
  }
)
