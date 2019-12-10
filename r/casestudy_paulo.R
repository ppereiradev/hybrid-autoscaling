library(fpp)

dados <- read.table("/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_4.txt")


dados.ts <- ts(dados, frequency = (2))



#min_time <- min(time(dados.ts))
#max_time <- max(time(dados.ts))

#dados.treino <- window(dados.ts, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
#dados.teste <- window(dados.ts, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)

dados.treino <- window(dados.ts, end = 30)
dados.teste <- window(dados.ts, start = 31)




plot(dados.ts)
length(dados.ts)

#write.table(dados.ts, "/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_4.txt")

plot(decompose(dados.ts))
plot(aggregate(dados.ts, FUN = mean))

if(length(dados.ts) < 50){
  m_drift <- rwf(dados.ts,drift=TRUE,h=10)
  plot(m_drift)
  lines(m_drift$fitted, col="red")
  
  p <- m_drift$mean <= 90
  intersect <- which(diff(p)!=0)[1]
  limiar <- time(m_drift$mean)[(intersect + 1)]
  abline(h = 90, v = limiar, col="red")
  options(scipen = 1000)
  axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  
  
  
}else {
  #dados.ts <- tail(dados.treino, 50)
  aux <- window(dados.treino, start=5.5)
  
  
    
  m_drift <- rwf(aux,drift=TRUE,h=10)
  rmse_drift <- accuracy(m_drift$mean, dados.teste)[2]
  
  plot(m_drift)
  lines(dados.teste, col="red")
  
  #lines(fit$fitted, col="red")
  
  
  
  

  fit <- auto.arima(aux)
  m_arima <- forecast(fit, h=10)
  rmse_arima <- accuracy(m_arima$mean, dados.teste)[2]
  
  plot(m_arima)
  #lines(fit$fitted, col="red")
  lines(dados.teste, col="red")
  
  aux <- window(dados.ts, start=11)
  
  
  if(rmse_drift < rmse_arima){
    
    
    m_drift <- rwf(aux,drift=TRUE,h=10)
  
    plot(m_drift)
    #lines(fit$fitted, col="red")
    
    p <- m_drift$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    limiar <- time(m_drift$mean)[(intersect + 1)]
    abline(h = 90, v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    
  }else {
    
    fit <- auto.arima(aux)
    m_arima <- forecast(fit, h=10)
    
    plot(m_arima)
    #lines(fit$fitted, col="red")
    
    p <- m_arima$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    limiar <- time(m_arima$mean)[(intersect + 1)]
    abline(h = 90, v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    
  }
    
  
  
  
  
  # accuracy(m_drift)
  #accuracy(m_arima, dados.teste)
  
  
  
  
  
}

#acf(dados.ts)
#pacf(dados.ts)
#boxplot(dados.ts)


#nnetar.fit <- nnetar(dados.ts, p=10, size=10)
#plot(forecast(nnetar.fit, h=5))
#lines(nnetar.fit$fitted, col="red")












dados <- read.table("/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_4.txt")


dados.ts <- ts(dados, frequency = (2))



#min_time <- min(time(dados.ts))
#max_time <- max(time(dados.ts))

#dados.treino <- window(dados.ts, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
#dados.teste <- window(dados.ts, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)

dados.treino <- window(dados.ts, end = 30)
dados.teste <- window(dados.ts, start = 31)




plot(dados.ts)
#length(dados.ts)

#write.table(dados.ts, "/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_4.txt")

#plot(decompose(dados.ts))
#plot(aggregate(dados.ts, FUN = mean))

if(length(dados.ts) < 50){
  m_drift <- rwf(dados.ts,drift=TRUE,h=10)
  plot(m_drift)
  lines(m_drift$fitted, col="red")
  
  p <- m_drift$mean <= 90
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_drift$mean)[(intersect + 1)]
    abline(h = 90, v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }
  
  
}else {
  #dados.ts <- tail(dados.treino, 50)
  #aux <- window(dados.treino, start=5.5)
  
  
  
  m_drift <- rwf(dados.treino,drift=TRUE,h=10)
  rmse_drift <- accuracy(m_drift$mean, dados.teste)[2]
  
  plot(m_drift)
  lines(dados.teste, col="red")
  
  #lines(fit$fitted, col="red")
  
  
  
  
  
  fit <- auto.arima(dados.treino)
  m_arima <- forecast(fit, h=10)
  rmse_arima <- accuracy(m_arima$mean, dados.teste)[2]
  
  plot(m_arima)
  #lines(fit$fitted, col="red")
  lines(dados.teste, col="red")
  
  #aux <- window(dados.ts, start=11)
  
  
  if(rmse_drift < rmse_arima){
    
    
    m_drift <- rwf(dados.ts,drift=TRUE,h=10)
    
    plot(m_drift)
    #lines(fit$fitted, col="red")
    
    p <- m_drift$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_drift$mean)[(intersect + 1)]
      abline(h = 90, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }  
  }else {
    
    fit <- auto.arima(dados.ts)
    m_arima <- forecast(fit, h=10)
    
    plot(m_arima)
    #lines(fit$fitted, col="red")
    
    p <- m_arima$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_arima$mean)[(intersect + 1)]
      abline(h = 90, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }
  
  
  
  
  # accuracy(m_drift)
  #accuracy(m_arima, dados.teste)
  
  
  
  
  
}

#acf(dados.ts)
#pacf(dados.ts)
#boxplot(dados.ts)


#nnetar.fit <- nnetar(dados.ts, p=10, size=10)
#plot(forecast(nnetar.fit, h=5))
#lines(nnetar.fit$fitted, col="red")


#library(prophet)



#dados.ts <- ts(AirPassengers, st=c(1949), end=c(1960), frequency = 12)

#m <- prophet(dados.ts)
#future <- make_future_dataframe(m, periods = 10)
#forecast <- predict(m, future)
#plot(forecast)




#case 1 - window size 70, using 60 training, 10 test, using 70 to predict, forecasting horizon 10 (5 min)

dados <- read.table("/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_2.txt")
#for(i in 131:133){  
#  dados.ts <- ts(dados[131:(137+69),], frequency = (2))
#  plot(dados.ts)
#  abline(h = 90, col="red")
  
#  p <- dados.ts <= 90
#  intersect <- which(diff(p)!=0)[1]
  
#    limiar <- time(dados.ts)[(intersect)]
#    abline(v = limiar, col="red")
#    options(scipen = 1000)
#    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  
  
#}
for(i in 128:131){


  dados.ts <- ts(dados[i:(i+69),], frequency = (2))
  dados.treino <- window(dados.ts, end = 30)
  dados.teste <- window(dados.ts, start = 31)
  
  #Drift
  m_drift <- rwf(dados.treino,drift=TRUE,h=10)
  rmse_drift <- accuracy(m_drift$mean, dados.teste)[2]
  
  plot(m_drift,  main = paste("Treinamento: Drift", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Simple Exponential Smoothing
  fit_ses <- ets(dados.treino, model = "ANN", damped = FALSE)
  m_ses <- forecast(fit_ses, h = 10)
  rmse_ses <- accuracy(m_ses$mean, dados.teste)[2]
  
  plot(m_ses,  main = paste("Treinamento: SES", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Holt
  fit_holt <- ets(dados.treino, model = "AAN", damped = FALSE)
  m_holt <- forecast(fit_holt, h = 10)
  rmse_holt <- accuracy(m_holt$mean, dados.teste)[2]
  
  plot(m_holt,  main = paste("Treinamento: Holt", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Holt-Winter
  fit_hw <- ets(dados.treino, model = "MAM", damped = FALSE)
  m_hw <- forecast(fit_hw, h = 10)
  rmse_hw <- accuracy(m_hw$mean, dados.teste)[2]
  
  plot(m_hw,  main = paste("Treinamento: Holt-Winters", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  

  #Arima
  fit_arima <- auto.arima(dados.treino)
  m_arima <- forecast(fit_arima, h=10)
  rmse_arima <- accuracy(m_arima$mean, dados.teste)[2]
  
  plot(m_arima,  main = paste("Treinamento: ARIMA", (i - 127), sep = " "))
  #lines(fit$fitted, col="red")
  lines(dados.teste, col="red")
  
  if(rmse_drift < rmse_ses & rmse_drift < rmse_holt & rmse_drift < rmse_hw & rmse_drift < rmse_arima){
    
    
    m_drift <- rwf(dados.ts,drift=TRUE,h=10)
    
    plot(m_drift,  main = paste("Melhor: Drift", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_drift$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_drift$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }  
  }else if(rmse_ses < rmse_drift & rmse_ses < rmse_holt & rmse_ses < rmse_hw & rmse_ses < rmse_arima){
    
    fit_ses <- ets(dados.ts, model = "ANN", damped = FALSE)
    m_ses <- forecast(fit_ses, h=10)
    
    plot(m_ses,  main = paste("Melhor: SES", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_ses$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_ses$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_holt < rmse_drift & rmse_holt < rmse_ses & rmse_holt < rmse_hw & rmse_holt < rmse_arima){
    
    fit_holt <- ets(dados.ts, model = "AAN", damped = FALSE)
    m_holt <- forecast(fit_holt, h=10)
    
    plot(m_holt,  main = paste("Melhor: Holt", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_holt$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_holt$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_hw < rmse_drift & rmse_hw < rmse_ses & rmse_hw < rmse_holt & rmse_hw < rmse_arima){
    
    fit_hw <- ets(dados.ts, model = "MAM", damped = FALSE)
    m_hw <- forecast(fit_hw, h=10)
    
    plot(m_hw,  main = paste("Melhor: Holt-Winters", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_hw$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_hw$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_arima < rmse_drift & rmse_arima < rmse_ses & rmse_arima < rmse_holt & rmse_arima < rmse_hw){
    
    fit_arima <- auto.arima(dados.ts)
    m_arima <- forecast(fit_arima, h=10)
    
    plot(m_arima,  main = paste("Melhor: ARIMA", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_arima$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_arima$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }
  
  print(paste("Drift:",rmse_drift, sep = " "))
  print(paste("SES:",rmse_ses, sep = " "))
  print(paste("Holt:",rmse_holt, sep = " "))
  print(paste("H-W:",rmse_hw, sep = " "))
  print(paste("ARIMA:",rmse_arima, sep = " "))
}
















#case 2 - window size 70, using 30 training, 10 test, using 40 to predict, forecasting horizon 10 (5 min)

dados <- read.table("/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_2.txt")
#for(i in 131:133){  
#  dados.ts <- ts(dados[131:(137+69),], frequency = (2))
#  plot(dados.ts)
#  abline(h = 90, col="red")

#  p <- dados.ts <= 90
#  intersect <- which(diff(p)!=0)[1]

#    limiar <- time(dados.ts)[(intersect)]
#    abline(v = limiar, col="red")
#    options(scipen = 1000)
#    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))


#}
for(i in 128:130){
  
  
  dados.ts <- ts(dados[i:(i+69),], frequency = (2))
  dados.treino <- window(dados.ts, start = 15, end = 30)
  dados.teste <- window(dados.ts, start = 31)
  
  #Drift
  m_drift <- rwf(dados.treino,drift=TRUE,h=10)
  rmse_drift <- accuracy(m_drift$mean, dados.teste)[2]
  
  plot(m_drift,  main = paste("Treinamento: Drift", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Simple Exponential Smoothing
  fit_ses <- ets(dados.treino, model = "ANN", damped = FALSE)
  m_ses <- forecast(fit_ses, h = 10)
  rmse_ses <- accuracy(m_ses$mean, dados.teste)[2]
  
  plot(m_ses,  main = paste("Treinamento: SES", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Holt
  fit_holt <- ets(dados.treino, model = "AAN", damped = FALSE)
  m_holt <- forecast(fit_holt, h = 10)
  rmse_holt <- accuracy(m_holt$mean, dados.teste)[2]
  
  plot(m_holt,  main = paste("Treinamento: Holt", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Holt-Winter
  fit_hw <- ets(dados.treino, model = "MAM", damped = FALSE)
  m_hw <- forecast(fit_hw, h = 10)
  rmse_hw <- accuracy(m_hw$mean, dados.teste)[2]
  
  plot(m_hw,  main = paste("Treinamento: Holt-Winters", (i - 127), sep = " "))
  lines(dados.teste, col="red")
  
  
  #Arima
  fit_arima <- auto.arima(dados.treino)
  m_arima <- forecast(fit_arima, h=10)
  rmse_arima <- accuracy(m_arima$mean, dados.teste)[2]
  
  plot(m_arima,  main = paste("Treinamento: ARIMA", (i - 127), sep = " "))
  #lines(fit$fitted, col="red")
  lines(dados.teste, col="red")
  
  dados.ts <- window(dados.ts, start=15)
  
  if(rmse_drift < rmse_ses & rmse_drift < rmse_holt & rmse_drift < rmse_hw & rmse_drift < rmse_arima){
    
    
    m_drift <- rwf(dados.ts,drift=TRUE,h=10)
    
    plot(m_drift,  main = paste("Melhor: Drift", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_drift$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_drift$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }  
  }else if(rmse_ses < rmse_drift & rmse_ses < rmse_holt & rmse_ses < rmse_hw & rmse_ses < rmse_arima){
    
    fit_ses <- ets(dados.ts, model = "ANN", damped = FALSE)
    m_ses <- forecast(fit_ses, h=10)
    
    plot(m_ses,  main = paste("Melhor: SES", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_ses$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_ses$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_holt < rmse_drift & rmse_holt < rmse_ses & rmse_holt < rmse_hw & rmse_holt < rmse_arima){
    
    fit_holt <- ets(dados.ts, model = "AAN", damped = FALSE)
    m_holt <- forecast(fit_holt, h=10)
    
    plot(m_holt,  main = paste("Melhor: Holt", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_holt$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_holt$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_hw < rmse_drift & rmse_hw < rmse_ses & rmse_hw < rmse_holt & rmse_hw < rmse_arima){
    
    fit_hw <- ets(dados.ts, model = "MAM", damped = FALSE)
    m_hw <- forecast(fit_hw, h=10)
    
    plot(m_hw,  main = paste("Melhor: Holt-Winters", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_hw$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_hw$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }else if(rmse_arima < rmse_drift & rmse_arima < rmse_ses & rmse_arima < rmse_holt & rmse_arima < rmse_hw){
    
    fit_arima <- auto.arima(dados.ts)
    m_arima <- forecast(fit_arima, h=10)
    
    plot(m_arima,  main = paste("Melhor: ARIMA", (i - 127), sep = " "))
    #lines(fit$fitted, col="red")
    abline(h = 90, col="red")
    
    p <- m_arima$mean <= 90
    intersect <- which(diff(p)!=0)[1]
    if(!is.na(intersect)){
      limiar <- time(m_arima$mean)[(intersect + 1)]
      abline(v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    
  }
  
  print(paste("Drift:",rmse_drift, sep = " "))
  print(paste("SES:",rmse_ses, sep = " "))
  print(paste("Holt:",rmse_holt, sep = " "))
  print(paste("H-W:",rmse_hw, sep = " "))
  print(paste("ARIMA:",rmse_arima, sep = " "))
}











#case 3 - window size 70, using 30 training, 10 test, using 40 to predict, forecasting horizon 10 (5 min)

dados <- read.table("/home/paulinho/Dropbox/MESTRADO/pesquisa_autoscaling/vm1_2_2.txt")
dados.ts <- ts(dados, frequency = (2))
plot(dados.ts)

#dados.ts <- ts(dados, frequency = (2))
dados.treino <- window(dados.ts, end = 20)
dados.teste <- window(dados.ts, start = 21)

#Drift
m_drift <- rwf(dados.treino,drift=TRUE,h=10)
rmse_drift <- accuracy(m_drift$mean, dados.teste)[2]

plot(m_drift,  main = "Treinamento: Drift")
lines(dados.teste, col="red")


#Simple Exponential Smoothing
fit_ses <- ets(dados.treino, model = "ANN", damped = FALSE)
m_ses <- forecast(fit_ses, h = 10)
rmse_ses <- accuracy(m_ses$mean, dados.teste)[2]

plot(m_ses,  main = "Treinamento: SES")
lines(dados.teste, col="red")


#Holt
fit_holt <- ets(dados.treino, model = "AAN", damped = FALSE)
m_holt <- forecast(fit_holt, h = 10)
rmse_holt <- accuracy(m_holt$mean, dados.teste)[2]

plot(m_holt,  main = "Treinamento: Holt")
lines(dados.teste, col="red")


#Holt-Winter
fit_hw <- ets(dados.treino, model = "MAM", damped = FALSE)
m_hw <- forecast(fit_hw, h = 10)
rmse_hw <- accuracy(m_hw$mean, dados.teste)[2]

plot(m_hw,  main = "Treinamento: Holt-Winters")
lines(dados.teste, col="red")


#Arima
fit_arima <- auto.arima(dados.treino)
m_arima <- forecast(fit_arima, h=10)
rmse_arima <- accuracy(m_arima$mean, dados.teste)[2]

plot(m_arima,  main = "Treinamento: ARIMA")
#lines(fit$fitted, col="red")
lines(dados.teste, col="red")

#dados.ts <- window(dados.ts, start=15)

if(rmse_drift < rmse_ses & rmse_drift < rmse_holt & rmse_drift < rmse_hw & rmse_drift < rmse_arima){
  
  
  m_drift <- rwf(dados.ts,drift=TRUE,h=10)
  
  plot(m_drift,  main = "Melhor: Drift")
  #lines(fit$fitted, col="red")
  abline(h = 20, col="red")
  
  p <- m_drift$mean <= 20
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_drift$mean)[(intersect + 1)]
    abline(v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }  
}else if(rmse_ses < rmse_drift & rmse_ses < rmse_holt & rmse_ses < rmse_hw & rmse_ses < rmse_arima){
  
  fit_ses <- ets(dados.ts, model = "ANN", damped = FALSE)
  m_ses <- forecast(fit_ses, h=10)
  
  plot(m_ses,  main = "Melhor: SES")
  #lines(fit$fitted, col="red")
  abline(h = 20, col="red")
  
  p <- m_ses$mean <= 20
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_ses$mean)[(intersect + 1)]
    abline(v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }
  
}else if(rmse_holt < rmse_drift & rmse_holt < rmse_ses & rmse_holt < rmse_hw & rmse_holt < rmse_arima){
  
  fit_holt <- ets(dados.ts, model = "AAN", damped = FALSE)
  m_holt <- forecast(fit_holt, h=10)
  
  plot(m_holt,  main = "Melhor: Holt")
  #lines(fit$fitted, col="red")
  abline(h = 20, col="red")
  
  p <- m_holt$mean <= 20
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_holt$mean)[(intersect + 1)]
    abline(v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }
  
}else if(rmse_hw < rmse_drift & rmse_hw < rmse_ses & rmse_hw < rmse_holt & rmse_hw < rmse_arima){
  
  fit_hw <- ets(dados.ts, model = "MAM", damped = FALSE)
  m_hw <- forecast(fit_hw, h=10)
  
  plot(m_hw,  main = "Melhor: Holt-Winters")
  #lines(fit$fitted, col="red")
  abline(h = 20, col="red")
  
  p <- m_hw$mean <= 20
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_hw$mean)[(intersect + 1)]
    abline(v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }
  
}else if(rmse_arima < rmse_drift & rmse_arima < rmse_ses & rmse_arima < rmse_holt & rmse_arima < rmse_hw){
  
  fit_arima <- auto.arima(dados.ts)
  m_arima <- forecast(fit_arima, h=10)
  
  plot(m_arima,  main = "Melhor: ARIMA")
  #lines(fit$fitted, col="red")
  abline(h = 20, col="black")
  
  p <- m_arima$mean <= 20
  intersect <- which(diff(p)!=0)[1]
  if(!is.na(intersect)){
    limiar <- time(m_arima$mean)[(intersect + 1)]
    abline(v = limiar, col="red")
    options(scipen = 1000)
    axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
  }
  
}

print(paste("Drift:",rmse_drift, sep = " "))
print(paste("SES:",rmse_ses, sep = " "))
print(paste("Holt:",rmse_holt, sep = " "))
print(paste("H-W:",rmse_hw, sep = " "))
print(paste("ARIMA:",rmse_arima, sep = " "))

