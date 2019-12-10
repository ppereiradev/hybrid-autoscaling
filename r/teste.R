# library(fpp)
# library(stringr)
# library(forecast)
# 
# #dados <- read.table("/home/paulinho/Downloads/data/paper_01/paper_01-processo-clc.txt", header=TRUE, dec=",") #user says
# dados <- read.table("/home/paulinho/Downloads/DOWNLOAD/data/paper_03/paper_03-foursquared.txt", header=TRUE, dec=",") #user says
# 
# metodo_principal <- function(coluna, limite_recurso, frequencia, start_ts, end_ts, horizonte, drift, r_linear, 
#                              s_exponential, holt, hw, arima, width_n, height_n, x_label, y_label){
#   
#   if(is.null(start_ts) & is.null(end_ts)){
#     base <- ts(dados[,as.numeric(coluna)], start = 0, frequency = as.numeric(frequencia)) #user says
#   }else if(!is.null(start_ts) & is.null(end_ts)){
#     base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia), 
#                frequency = as.numeric(frequencia)) #user says
#   }else if(is.null(start_ts) & !is.null(end_ts)){
#     base <- ts(dados[,as.numeric(coluna)], end = as.numeric(end_ts/frequencia), 
#                frequency = as.numeric(frequencia)) #user says
#   }else if(!is.null(start_ts) & !is.null(end_ts)){
#     base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia),
#                end = as.numeric(end_ts/frequencia), frequency = as.numeric(frequencia)) #user says
#   }
#   
#   
#   min_time <- min(time(base))
#   max_time <- max(time(base))
#   
#   treino <- window(base, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
#   teste <- window(base, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)
#   
#   #numero_linhas <- nrow(dados)
#   #min_y <- min(dados[,as.numeric(coluna)],na.rm=TRUE)
#   #max_y <- max(dados[,as.numeric(coluna)],na.rm=TRUE)
#   
#   #plot(base)
#   acuracia_mape <- c(100, 100, 100, 100, 100, 100)
#   acuracia_mae <- c(100, 100, 100, 100, 100, 100)
#   
#   #drift
#   if(drift){
#     fc3 <- rwf(treino, drift = TRUE, h=horizonte)
#     
#     acuracia_mape[1] <- accuracy(fc3)[5]
#     acuracia_mae[1] <- accuracy(fc3)[3]
#     
#   }
#   
#   
#   
#   
#   
#   
#   #regressao linear
#   if(r_linear){
#     fc7 <- forecast(tslm(treino ~ trend + season), h = horizonte)
#     
#     acuracia_mape[2] <- accuracy(fc7)[5]
#     acuracia_mae[2] <- accuracy(fc7)[3]
#   }
#   
#   
#   
#   
#   
#   #simple exponential
#   if(s_exponential){
#     fit <- ets(treino, model = "ANN", damped = FALSE)
#     fc5 <- forecast(fit, h = horizonte)
#     
#     acuracia_mape[3] <- accuracy(fc5)[5]
#     acuracia_mae[3] <- accuracy(fc5)[3]
#     
#   }
#   
#   
#   
#   
#   #holt
#   if(holt){
#     fit <- ets(treino, model = "AAN", damped = FALSE)
#     fc6 <- forecast(fit, h = horizonte)
#     
#     acuracia_mape[4] <- accuracy(fc6)[5]
#     acuracia_mae[4] <- accuracy(fc6)[3]
#     
#   }
#   
#   
#   
#   
#   
#   
#   #holt-winters
#   if(hw){
#     fit <- ets(treino, model = "AAA", damped = FALSE)
#     fc <- forecast(fit, h = horizonte)
#     
#     acuracia_mape[5] <- accuracy(fc)[5]
#     acuracia_mae[5] <- accuracy(fc)[3]
#   
#   }
#   
#   
#   
#   
#   
#   
#   #arima
#   if(arima){
#     fit <- auto.arima(treino)
#     m_arima <- forecast(fit, h = horizonte)
#     
#     acuracia_mape[6] <- accuracy(m_arima)[5]
#     acuracia_mae[6] <- accuracy(m_arima)[3]
#   
#   }
#   
#   
#   
#   
#   if((which.min(acuracia_mape) == 1 | which.min(acuracia_mae) == 1) & drift == TRUE){
#     fc3 <- rwf(base, drift = TRUE, h=horizonte)
#     
#     
#     if(!is.null(limite_recurso)){
#       p <- fc3$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(fc3$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#     
#   }
#   
#   if((which.min(acuracia_mape) == 2 | which.min(acuracia_mae) == 2) & r_linear == TRUE){
#     fc7 <- forecast(tslm(base ~ trend + season), h = horizonte)
#     
#     
#     if(!is.null(limite_recurso)){
#       p <- fc7$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(fc7$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#     
#     
#   }
#   
#   if((which.min(acuracia_mape) == 3 | which.min(acuracia_mae) == 3) & s_exponential == TRUE){
#     fit <- ets(base, model = "ANN", damped = FALSE)
#     fc5 <- forecast(fit, h = horizonte)
#     
#     if(!is.null(limite_recurso)){
#       p <- fc5$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(fc5$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#     
#     
#   }
#   
#   if((which.min(acuracia_mape) == 4 | which.min(acuracia_mae) == 4) & holt == TRUE){
#     fit <- ets(base, model = "AAN", damped = FALSE)
#     fc6 <- forecast(fit, h = horizonte)
#     
#     
#     if(!is.null(limite_recurso)){
#       p <- fc6$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(fc6$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#     
#     
#   }
#   
#   if((which.min(acuracia_mape) == 5 | which.min(acuracia_mae) == 5) & hw == TRUE){
#     fit <- ets(base, model = "AAA", damped = FALSE)
#     fc <- forecast(fit, h = horizonte)
#     
#     
#     if(!is.null(limite_recurso)){
#       p <- fc$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(fc$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#     
#     
#   }
#   
#   if((which.min(acuracia_mape) == 6 | which.min(acuracia_mae) == 6) & arima == TRUE){
#     fit <- auto.arima(base)
#     m_arima <- forecast(fit, h = horizonte)
#     
#     if(!is.null(limite_recurso)){
#       p <- m_arima$mean <= limite_recurso
#       intersect <- which(diff(p)!=0)
#       limiar <- time(m_arima$mean)[(intersect + 1)]
#       
#       print(limiar)
#     }
#    
#   }
#   
#   #print(acuracia_mape)
#   #print(acuracia_mae)
#   
#   #return(which.min(acuracia_mae))
# }
# 
# 
# 
# metodo_principal(4, 224484, 6, NULL, NULL, 42, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, 800, 600, "TEMPO", NULL)


library(fpp)
library(stringr)
library(forecast)

#dados <- read.table("/home/paulinho/Downloads/data/paper_01/paper_01-processo-clc.txt", header=TRUE, dec=",") #user says
dados <- read.table("/home/paulinho/Downloads/DOWNLOAD/data/paper_03/paper_03-foursquared.txt", header=TRUE, dec=",") #user says

metodo_principal <- function(coluna, limite_recurso, frequencia, start_ts, end_ts, horizonte, drift, r_linear, 
                             s_exponential, holt, hw, arima, width_n, height_n, x_label, y_label){
  
  if(is.null(start_ts) & is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = 0, frequency = as.numeric(frequencia)) #user says
  }else if(!is.null(start_ts) & is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia), 
               frequency = as.numeric(frequencia)) #user says
  }else if(is.null(start_ts) & !is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], end = as.numeric(end_ts/frequencia), 
               frequency = as.numeric(frequencia)) #user says
  }else if(!is.null(start_ts) & !is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia),
               end = as.numeric(end_ts/frequencia), frequency = as.numeric(frequencia)) #user says
  }
  
  
  
  min_time <- min(time(base))
  max_time <- max(time(base))
  
  treino <- window(base, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
  teste <- window(base, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)
  
  #numero_linhas <- nrow(dados)
  #min_y <- min(dados[,as.numeric(coluna)],na.rm=TRUE)
  #max_y <- max(dados[,as.numeric(coluna)],na.rm=TRUE)
  
  #plot(base)
  acuracia_mape <- c(100, 100, 100, 100, 100, 100)
  acuracia_mae <- c(100, 100, 100, 100, 100, 100)
  acuracia_rmse <- c(0, 0, 0, 0, 0, 0)
  
  
  
  #drift
  if(drift){
    fc3 <- rwf(treino, drift = TRUE, h=horizonte)
    
    acuracia_mape[1] <- accuracy(fc3)[5]
    acuracia_mae[1] <- accuracy(fc3)[3]
    acuracia_rmse[1] <- accuracy(fc3)[2]
    

    png(filename = 'drift', width = width_n, height = height_n, units = 'px')
    
    plot(fc3, col="blue", xlab = x_label, ylab = y_label,
         main = "Método Drift", xlim=c(0, 35))
    
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","Drift"))
    options(scipen = 1000)
    
    dev.off()
    
    
  }
  
  
  
  
  
  
  #regressao linear
  if(r_linear){
    fc7 <- forecast(tslm(treino ~ trend + season), h = horizonte)
    
    acuracia_mape[2] <- accuracy(fc7)[5]
    acuracia_mae[2] <- accuracy(fc7)[3]
    acuracia_rmse[2] <- accuracy(fc7)[2]
    
    png(filename = 'r_linear', width = width_n, height = height_n, units = 'px')
    
    plot(fc7, col="blue", xlab = x_label, ylab = y_label,
         main = "Método RL", xlim=c(0, 35))
    
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","RL"))
    options(scipen = 1000)
    
    dev.off()
  }
  
  
  
  
  
  #simple exponential
  if(s_exponential){
    fit <- ets(treino, model = "ANN", damped = FALSE)
    fc5 <- forecast(fit, h = horizonte)
    
    acuracia_mape[3] <- accuracy(fc5)[5]
    acuracia_mae[3] <- accuracy(fc5)[3]
    acuracia_rmse[3] <- accuracy(fc5)[2]
    
    png(filename = 'ses', width = width_n, height = height_n, units = 'px')
    
    plot(fc5, col="blue", xlab = x_label, ylab = y_label,
         main = "Método SES", xlim=c(0, 35))
    
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","SES"))
    options(scipen = 1000)
    
    dev.off()
  }
  
  
  
  
  #holt
  if(holt){
    fit <- ets(treino, model = "AAN", damped = FALSE)
    fc6 <- forecast(fit, h = horizonte)
    
    acuracia_mape[4] <- accuracy(fc6)[5]
    acuracia_mae[4] <- accuracy(fc6)[3]
    acuracia_rmse[4] <- accuracy(fc6)[2]
    
    png(filename = 'holt', width = width_n, height = height_n, units = 'px')
    
    plot(fc6, col="blue", xlab = x_label, ylab = y_label,
         main = "Método Holt", xlim=c(0, 35))
    
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","Holt"))
    options(scipen = 1000)
    
    dev.off()
  }
  
  
  
  
  
  
  #holt-winters
  if(hw){
    fit <- ets(treino, model = "AAA", damped = FALSE)
    fc <- forecast(fit, h = horizonte)
    
    acuracia_mape[5] <- accuracy(fc)[5]
    acuracia_mae[5] <- accuracy(fc)[3]
    acuracia_rmse[5] <- accuracy(fc)[2]
    
    png(filename = 'hw', width = width_n, height = height_n, units = 'px')
    
    plot(fc, col="blue", xlab = x_label, ylab = y_label,
         main = "Método HW", xlim=c(0, 35))
  
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","HW"))
    options(scipen = 1000)
    
    dev.off()
  
    
  }
  
  
  
  
  
  
  #arima
  if(arima){
    fit <- auto.arima(treino)
    m_arima <- forecast(fit, h = horizonte)
    
    acuracia_mape[6] <- accuracy(m_arima)[5]
    acuracia_mae[6] <- accuracy(m_arima)[3]
    acuracia_rmse[6] <- accuracy(m_arima)[2]
    
    png(filename = 'arima', width = width_n, height = height_n, units = 'px')
    
    plot(m_arima, col="blue", xlab = x_label, ylab = y_label,
         main = "Método ARIMA", xlim=c(0, 35))
    
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Treino","Teste","ARIMA"))
    options(scipen = 1000)
    
  dev.off()
  }
  
  
  
  
  #if((which.min(acuracia_mape) == 1 | which.min(acuracia_mae) == 1) & drift == TRUE){
  if((which.min(acuracia_rmse) == 1 & acuracia_rmse[1] != 0) & drift == TRUE){
    fc3 <- rwf(base, drift = TRUE, h=horizonte)
    
    
    if(!is.null(limite_recurso)){
      p <- fc3$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc3$mean)[(intersect + 1)]
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
  }
  
  #if((which.min(acuracia_mape) == 2 | which.min(acuracia_mae) == 2) & r_linear == TRUE){
  if((which.min(acuracia_rmse) == 2 & acuracia_rmse[2] != 0) & r_linear == TRUE){
  
    fc7 <- forecast(tslm(base ~ trend + season), h = horizonte)
    
    
    if(!is.null(limite_recurso)){
      p <- fc7$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc7$mean)[(intersect + 1)]
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
    
  }
  
  #if((which.min(acuracia_mape) == 3 | which.min(acuracia_mae) == 3) & s_exponential == TRUE){
  if((which.min(acuracia_rmse) == 3 & acuracia_rmse[3] != 0) & s_exponential == TRUE){
   fit <- ets(base, model = "ANN", damped = FALSE)
    fc5 <- forecast(fit, h = horizonte)
    
    if(!is.null(limite_recurso)){
      p <- fc5$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc5$mean)[(intersect + 1)]
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
    
  }
  
  #if((which.min(acuracia_mape) == 4 | which.min(acuracia_mae) == 4) & holt == TRUE){
  if((which.min(acuracia_rmse) == 4 & acuracia_rmse[4] != 0) & holt == TRUE){ 
   fit <- ets(base, model = "AAN", damped = FALSE)
    fc6 <- forecast(fit, h = horizonte)
    
    
    if(!is.null(limite_recurso)){
      p <- fc6$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc6$mean)[(intersect + 1)]
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
    
  }
  
  #if((which.min(acuracia_mape) == 5 | which.min(acuracia_mae) == 5) & hw == TRUE){
  if((which.min(acuracia_rmse) == 5 & acuracia_rmse[5] != 0) & hw == TRUE){ 
    fit <- ets(base, model = "AAA", damped = FALSE)
    fc <- forecast(fit, h = horizonte)
    
    png(filename = 'melhor', width = width_n, height = height_n, units = 'px')
    
    plot(fc, col="blue", xlab = x_label, ylab = y_label, main = "Maior Acurácia: Holt-Winters")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Base de Dados", "H.-Winters"))
    
    if(!is.null(limite_recurso)){
      p <- fc$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc$mean)[(intersect + 1)]
      
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
      
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
    dev.off()
    
  }
  
  #if((which.min(acuracia_mape) == 6 | which.min(acuracia_mae) == 6) & arima == TRUE){
  if((which.min(acuracia_rmse) == 6 & acuracia_rmse[6] != 0) & arima == TRUE){ 
    fit <- auto.arima(base)
    m_arima <- forecast(fit, h = horizonte)
    
    if(!is.null(limite_recurso)){
      p <- m_arima$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(m_arima$mean)[(intersect + 1)]
      
      #print(limiar)
      print(limiar - (length(base)/frequencia))
    }
    
  }
  
 # print(acuracia_mape)
#  print(acuracia_mae)
 # print(acuracia_rmse)
  
  #return(which.min(acuracia_mae))
  
  
 
}



metodo_principal(4, 224484, 6, NULL, NULL, 42, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 800, 600, "TEMPO", NULL)