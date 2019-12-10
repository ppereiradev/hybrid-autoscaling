library(forecast)
library(tseries)

args <- commandArgs(TRUE)

forecasting <- function(){
  dados <- read.table("/home/paulinho/Development/C/log_segundos.txt", header=FALSE, sep = "", dec=".", skipNul = TRUE, blank.lines.skip = TRUE)
  if(nrow(dados) >= 30){
    
    
    base <- ts(tail(dados[,1], 30), frequency = 2)
    
    min_time <- min(time(base))
    max_time <- max(time(base))
    
    treino <- window(base, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
    teste <- window(base, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)
    
    
    m_arima <- forecast(auto.arima(treino), h = 10)
    m_drift <- rwf(treino, drift = TRUE, h = 10)
    #m_ses <- forecast(ets(treino, model = "ANN", damped = FALSE), h = 10)
    m_holt <- forecast(ets(treino, model = "AAN", damped = FALSE), h = 10)
    m_hw <- forecast(ets(treino, model = "AAA", damped = FALSE), h = 10)
    
    
    acuracia_mape <- c(0,0,0,0)
    acuracia_mape[1] <- accuracy(m_arima, teste)[5]
    acuracia_mape[2] <- accuracy(m_drift, teste)[5]
    #acuracia_mape[3] <- accuracy(m_ses, teste)[5]
    acuracia_mape[3] <- accuracy(m_holt, teste)[5]
    acuracia_mape[4] <- accuracy(m_hw, teste)[5]
    
    #caso o threshold nao tenha sido cruzado pela predicao, entao testa se foi pelas amostras
    aux = 0
    if(which.min(acuracia_mape) == 1){
      aux2 = 0
      aux3 = as.numeric(args[1])
      m_arima <- forecast(auto.arima(base), h = 10)
      
      if(m_arima$mean[length(m_arima$mean)] >= 80){
        cat(paste(m_arima$mean[length(m_arima$mean)], "s"))
        aux = 1
        aux2 = 1
        aux3 = 3
      }else if(m_arima$mean[length(m_arima$mean)] <= 20){
        cat(paste(m_arima$mean[length(m_arima$mean)], "i"))
        aux = 1
        aux2 = 1
      }
      
      if(aux2 > 0 && as.numeric(aux3) > 2){
        invisible(setwd("/home"))
        
        invisible(write.table(acuracia_mape, "/home/accuracy_value.txt", sep="\t", append = TRUE, col.names = FALSE))
        invisible(pdf(file=paste(Sys.time(),"_arima", ".pdf", sep=""))) 
        invisible(plot(m_arima, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
        invisible(lines(base, type = "l"))
        invisible(abline(h=80, col="red"))
        invisible(abline(h=20, col="red"))
        invisible(dev.off())
      }
      
    }else if(which.min(acuracia_mape) == 2){
      aux2 = 0
      aux3 = as.numeric(args[1])
      m_drift <- rwf(base, drift = TRUE, h = 10)
      
      if(m_drift$mean[length(m_drift$mean)] >= 80){
        cat(paste(m_drift$mean[length(m_drift$mean)], "s"))
        aux = 1
        aux2 = 1
        aux3 = 3
      }else if(m_drift$mean[length(m_drift$mean)] <= 20){
        cat(paste(m_drift$mean[length(m_drift$mean)], "i"))
        aux = 1
        aux2 = 1
      }       
      
      if(aux2 > 0 && as.numeric(aux3) > 2){
        invisible(setwd("/home"))
        
        invisible(write.table(acuracia_mape, "/home/accuracy_value.txt", sep="\t", append = TRUE, col.names = FALSE))
        invisible(pdf(file=paste(Sys.time(), "_drift", ".pdf", sep=""))) 
        invisible(plot(m_drift, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
        invisible(lines(base, type = "l"))
        invisible(abline(h=80, col="red"))
        invisible(abline(h=20, col="red"))
        invisible(dev.off())
      }
      
    }
    # else if(which.min(acuracia_mape) == 3){
    #   m_ses <- forecast(ets(base, model = "ANN", damped = FALSE), h = 10)
    #   
    #   s <- m_ses$mean <= 80
    #   i <- m_ses$mean <= 20
    #   
    #   intersect_s <- which(diff(s)!=0)[1]
    #   intersect_i <- which(diff(i)!=0)[1]
    #   if(!is.na(intersect_s)){
    #     limiar_s <- time(m_ses$mean)[(intersect_s + 1)]
    #     cat(paste(limiar_s, "s"))
    #   }else if(!is.na(intersect_i)){
    #     limiar_i <- time(m_ses$mean)[(intersect_i + 1)]
    #     cat(paste(limiar_i, "i"))
    #   }       
    #  
    #   if(!is.na(intersect_s) || !is.na(intersect_i)){
    #     invisible(write.table(acuracia_mape, "/home/accuracy_value.txt", sep="\t", append = TRUE, col.names = FALSE))
    #     
    #     invisible(setwd("/home"))
    #     
    #     invisible(pdf(file=paste("ses_",Sys.time(), ".pdf", sep=""))) 
    #     invisible(plot(m_hw, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
    #     invisible(lines(base, type = "l"))
    #     invisible(abline(h=80, col="red"))
    #     invisible(abline(h=20, col="red"))
    #     invisible(dev.off())
    #   }
    #   
    # }
    else if(which.min(acuracia_mape) == 3){
      aux2 = 0
      aux3 = as.numeric(args[1])
      m_holt <- forecast(ets(base, model = "AAN", damped = FALSE), h = 10)
      
      if(m_holt$mean[length(m_holt$mean)] >= 80){
        cat(paste(m_holt$mean[length(m_holt$mean)], "s"))
        aux = 1
        aux2 = 1
        aux3 = 3
      }else if(m_holt$mean[length(m_holt$mean)] <= 20){
        cat(paste(m_holt$mean[length(m_holt$mean)], "i"))
        aux = 1
        aux2 = 1
      }
      
      if(aux2 > 0 && as.numeric(aux3) > 2){
        invisible(setwd("/home/paulinho/Development/resultados"))
        
        invisible(write.table(acuracia_mape, "/home/accuracy_value.txt", sep="\t", append = TRUE, col.names = FALSE))
        invisible(pdf(file=paste(Sys.time(), "_holt", ".pdf", sep=""))) 
        invisible(plot(m_holt, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
        invisible(lines(base, type = "l"))
        invisible(abline(h=80, col="red"))
        invisible(abline(h=20, col="red"))
        invisible(dev.off())
      }
      
    }else if(which.min(acuracia_mape) == 4){
      aux2 = 0
      aux3 = as.numeric(args[1])
      m_hw <- forecast(ets(base, model = "AAA", damped = FALSE), h = 10)
      
      if(m_hw$mean[length(m_hw$mean)] >= 80){
        cat(paste(m_hw$mean[length(m_hw$mean)], "s"))
        aux = 1
        aux2 = 1
        aux3 = 3
      }else if(m_hw$mean[length(m_hw$mean)] <= 20){
        cat(paste(m_hw$mean[length(m_hw$mean)], "i"))
        aux = 1
        aux2 = 1
      }
      
      if(aux2 > 0 && as.numeric(aux3) > 2){
        invisible(setwd("/home"))
        
        invisible(write.table(acuracia_mape, "/home/accuracy_value.txt", sep="\t", append = TRUE, col.names = FALSE))
        invisible(pdf(file=paste(Sys.time(), "_hw", ".pdf", sep=""))) 
        invisible(plot(m_hw, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
        invisible(lines(base, type = "l"))
        invisible(abline(h=80, col="red"))
        invisible(abline(h=20, col="red"))
        invisible(dev.off())
      }
      
    }
    
    if(aux == 0){
      current_sample <- tail(base, n=1)
      aux2 = 0 
      aux3 = as.numeric(args[1])
      if(current_sample >= 80){
        cat(paste(current_sample, "s"))
        aux2 = 1
        aux3 = 3
      }else if(current_sample <= 20){
        cat(paste(current_sample, "i"))
        aux2 = 1
      }
      
      if(aux2 > 0 && as.numeric(aux3) > 2){
        invisible(setwd("/home"))
        
        invisible(pdf(file=paste(Sys.time(), "_base", ".pdf", sep=""))) 
        invisible(plot(base, type = "l", ylim = c(0,100), xlab = "minutes", ylab = "CPU USAGE"))
        invisible(abline(h=80, col="red"))
        invisible(abline(h=20, col="red"))
        invisible(dev.off())
      }
      
      
      
    }
    
  }else{
    print("dados insuficientes")
    
  }
}

forecasting()

