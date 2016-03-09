n_sims = 100000

n_marked = 5
n_sampled = 7
n_recaptured = 3

unif_min = 10
unif_max = 100
unif_prior = sample(unif_min:unif_max, n_sims, replace=TRUE)

lambda = 35
pois_prior = rpois(n_sims, lambda)

generative_model = function(n_total)
{
  marked = rep(1, n_marked)
  unmarked = rep(0, n_total-n_marked)
  
  pop = c(marked, unmarked)
  sum(sample(pop, n_sampled, replace=FALSE))
}

sim_unif = sapply(unif_prior, generative_model)
sim_pois = sapply(pois_prior, generative_model)

post_unif = unif_prior[sim_unif == n_recaptured]
post_pois = pois_prior[sim_pois == n_recaptured]


par(mfrow=c(1,2))

plot(density(post_unif), main = "Posterior (Unif)")
abline(v=mean(post_unif),col='red')
abline(v=median(post_unif),col='blue')

x = unif_min:unif_max
y = rep(1/(unif_max-unif_min), length(x))
lines(x,y, lty=2,col='grey')


plot(density(post_pois), main = "Posterior (Pois)")
abline(v=mean(post_pois),col='red')
abline(v=median(post_pois),col='blue')

x = unif_min:unif_max
y = dpois(x, lambda)
lines(x,y, lty=2,col='grey')

