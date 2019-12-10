library(forecast)
library(tseries)


forecasting <- function(){
  
  
  dados <- read.table("/home/paulinho/log.txt", header=FALSE, sep = "", dec=".", skipNul = TRUE, blank.lines.skip = TRUE)
  if(nrow(dados) >= 60){
    
    
    base <- ts(tail(dados[,1], 60), frequency = 2)
    fit <- auto.arima(base)
    #fit <- Arima(base, order = c(10,2,10))
    m_arima <- forecast(fit, h = 10)
    
    #arimaorder(fit)
    
    
    plot(m_arima, col="red", main = "Método ARIMA", type="l")
    lines(m_arima$fitted, col="red")
    lines(base, col="blue")
    
    
    fit <- ets(base)
    m_exponential <- forecast(fit, h = 10)
    
    #plot(m_exponential, col="red", main = "Método Exponential", type="l")
    #lines(m_exponential$fitted, col="red")
    #lines(base, col="blue")
    
    #accuracy(m_arima)
    #accuracy(m_exponential)
    acuracia_mae <- c(100, 100)
    acuracia_mae[1] <- accuracy(m_arima)[3]
    acuracia_mae[2] <- accuracy(m_exponential)[3]
    
    
    if(acuracia_mae[1] < acuracia_mae[2]){
      fit <- auto.arima(base)
      #fit <- Arima(base, order = c(10,2,10))
      m_arima <- forecast(fit, h = 10)
      
      plot(m_arima, col="red", main = "Método ARIMA", type="l")
      lines(m_arima$fitted, col="red")
      lines(base, col="blue")
      abline(h = 80)
      abline(h = 20)
      #print("ARIMA MELHOR")
      
      s <- m_arima$mean <= 80
      i <- m_arima$mean <= 20
      
      intersect_s <- which(diff(s)!=0)[1]
      intersect_i <- which(diff(i)!=0)[1]
      if(!is.na(intersect_s)){
        limiar_s <- time(m_arima$mean)[(intersect_s + 1)]
        cat(paste(limiar_s, "s"))
      }else if(!is.na(intersect_i)){
        limiar_i <- time(m_arima$mean)[(intersect_i + 1)]
        cat(paste(limiar_i, "i"))
      }else {
        #print("nao atingiu o threshold")
      }
      
      #print(paste(paste("ARIMA: ", acuracia_mae[1], sep=" "),paste("EXPONENTIAL: ", acuracia_mae[2], sep=" "), sep=" "))
      
    }else {
      fit <- ets(base)
      m_exponential <- forecast(fit, h = 10)
      
      plot(m_exponential, col="red", main = "Método Exponential", type="l")
      lines(m_exponential$fitted, col="red")
      lines(base, col="blue")
      abline(h = 80)
      abline(h = 20)
      #print("EXPONENTIAL MELHOR")
      
      s <- m_exponential$mean <= 80
      i <- m_exponential$mean <= 20
      
      intersect_s <- which(diff(s)!=0)[1]
      intersect_i <- which(diff(i)!=0)[1]
      if(!is.na(intersect_s)){
        limiar_s <- time(m_exponential$mean)[(intersect_s + 1)]
        cat(paste(limiar_s, "s"))
      }else if(!is.na(intersect_i)){
        limiar_i <- time(m_exponential$mean)[(intersect_i + 1)]
        cat(paste(limiar_i, "i"))
      }else {
        #print("nao atingiu o threshold")
      }
      
      #print(paste(paste("ARIMA: ", acuracia_mae[1], sep=" "),paste("EXPONENTIAL: ", acuracia_mae[2], sep=" "), sep=" "))
      
      
      
      
    }
    
    #plot(dados[,1], type="l")
  }else{
    print("dados insuficientes")
    
  }
}

forecasting()

