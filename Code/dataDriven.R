source('completeTies.R')
source('permute.R')

dataDriven <- function(elements, dimension){
  # Step 1: Define the embedding dimension D, that lead to the all possible permutation patterns 
  symbols <- define.symbols(dimension)
  
  #Step 2: Map all the vectors and their implementation pattern
  #Step 5: Repeat the step 3, bat do not eliminate the vectors with repeated values
  mypatterns <- formationPatternElements(elements, dimension)
  
  #Step 3: If there any ties in vectors, eliminate the vector
  #Step 4: Calculate the permutation patterns probabilities
  prob <- completeTies(elements, mypatterns)
  
  #Step 6: If the vector has not equal components, map it to pattern with weigth = 1
  weigth = rep(0, dim(symbols)[1])
  
  for(i in 1:dim(elements)[1]){
    sumProb = 0
    aux = duplicated(elements[i, order(elements[i,])])
    isDuplicated = length(aux[aux==TRUE])
    if(isDuplicated != 0){ #Step 7: If the vector has equal components, break the ties add small pertubations 
      init = which(aux==TRUE)[1] - 1
      end = init + isDuplicated
      myresult = myPermute(mypatterns[i,],init,end)
      index = rep(0,dim(myresult)[1])
      pertubation = 1/dim(myresult)[1]
      for(j in 1:dim(myresult)[1]){
        for(k in 1:factorial(dimension)){
          if(all(myresult[j,] == symbols[k,])){ 
            index[j] = k 
            break
          }
        }   
      }
      sumProb = sum(prob[index])
      soma = 0
      for(j in 1:dim(myresult)[1]){
        if(sumProb != 0){
          weigth[j] = weigth[j] + (prob[index[j]]/sumProb)
          soma = soma + (prob[index[j]]/sumProb)
        }
      }
    }else{
      for(k in 1:factorial(dimension)){ 
        if(all(mypatterns[i,] == symbols[k,])){ 
          weigth[k] = weigth[k] + 1
          break
        }
      }  
    }
  }
  p = weigth/dim(elements)[1]
  if(sum(p)!=1){
    r = (1 - sum(p))/factorial(dimension)
    p = p + r
  }
  p
}