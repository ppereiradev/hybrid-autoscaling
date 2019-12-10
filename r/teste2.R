library(fpp)
library(stringr)
library(forecast)


forecasting <- function(){  
  dados <- read.table("/home/paulinho/log.txt", header=TRUE, sep = " ", dec=".", skipNul = TRUE, blank.lines.skip = TRUE)
  nrow(dados)
  if(nrow(dados) >= 50){
    
    dados <- tail(dados, 50)
    
    #dados <- na.omit(dados)
    #dados[,1] <- sub("%", " ", dados[,1])
    
    base <- ts(dados, frequency = 1)
    
    
   # acf(base)
  #  pacf(base)
    
    fit_arima <- auto.arima(base)
    m_arima <- forecast(fit_arima, h = 5)
    
    #arimaorder(fit)
    
    
    plot(m_arima, col="red", main = "Método ARIMA", type="l")
    lines(m_arima$fitted, col="red")
    lines(base, col="blue")
    
    
    fit_ets <- ets(base)
    m_exponential <- forecast(fit_ets, h = 5)
    
    plot(m_exponential, col="red", main = "Método Exponential", type="l")
    lines(m_exponential$fitted, col="red")
    lines(base, col="blue")
    
    #accuracy(m_arima)
    #accuracy(m_exponential)
    acuracia_mae <- c(100, 100)
    acuracia_mae[1] <- accuracy(m_arima)[3]
    acuracia_mae[2] <- accuracy(m_exponential)[3]
    
    
    if(acuracia_mae[1] < acuracia_mae[2]){
      #fit_arima <- auto.arima(base)
      fit_arima <- arima(base, order = c(4,2,3))
      m_arima <- forecast(fit_arima, h = 10)
      
      plot(m_arima, col="red", main = "Método ARIMA", type="l")
      lines(m_arima$fitted, col="red")
      lines(base, col="blue")
      #abline(h=60)
      abline(h=20)
      print("ARIMA MELHOR")
      
      s <- m_arima$mean <= 60
      i <- m_arima$mean <= 20
      
      intersect_s <- which(diff(s)!=0)[1]
      intersect_i <- which(diff(i)!=0)[1]
      if(!is.na(intersect_s)){
        limiar_s <- time(m_arima$mean)[(intersect_s + 1)]
        cat(paste(as.numeric(limiar_s-length(base)), "s"))
      }else if(!is.na(intersect_i)){
        limiar_i <- time(m_arima$mean)[(intersect_i + 1)]
        cat(paste(as.numeric(limiar_i-length(base)), "i"))
        
      }else {
        print("nao atingiu o threshold")
      }
      
      
    }else {
      fit_ets <- ets(base)
      m_exponential <- forecast(fit_ets, h = 5)
      
      plot(m_exponential, col="red", main = "Método Exponential", type="l")
      lines(m_exponential$fitted, col="red")
      lines(base, col="blue")
      print("EXPONENTIAL MELHOR")
    }
    
    #plot(dados[,1], type="l")
    
  }else{
    print("dados insuficientes")
    
  }
}

forecasting()