initial=[1,-1,1,-1]
t,n=1,1000

w = Array.new(4)
4.times do |i|
  w[i] = Array.new(4,0)
  4.times do |j|
    if j > i
      w[i][j] = (rand 101) / 100.0 * (-1) ** (rand 2)
    else
      w[i][j]=w[j][i]
    end
  end
end

u=Array.new(4)
4.times do |i|
  u[i] = (rand 101) / 100.0 * (-1) ** (rand 2)
end



def p(tt,mm)
  1.0/(1+Math.exp( -tt/mm ))
end

while n>0.01
select=rand 4
hi=0
  4.times do |j|
    hi+=w[select][j]*initial[j]
  end
hi-=u[select]
if hi>0
  initial[select]=1
else
  a=p(hi,n)
  
  if n>10
    b=(rand 700)/1000.0
  else
    b=0.5+(rand 200)/1000.0
  end

  if a > b
    initial[select]=1
  else
    initial[select]=-1
  end
end
n=1000/(1+t)
t+=1
end

total=0
4.times do |i|
  4.times do |j|
    total+=-0.5*w[i][j]*initial[i]*initial[j]
  end
  total+=u[i]*initial[i]
end
puts initial.join("\t")+"\t\t"+total.to_s
puts "\n"

target = Array.new(16)
16.times do |i|
  target[i] = Array.new(4)
  
  if i == 0
    target[0] = [-1,-1,-1,-1]
    next
  end
  if i > 0
    4.times do |k|
      t = target[i-1][k]
      target[i][k] = t
    end
    4.times do |j|
      ttt = target[i-1][3-j]
      if ttt == -1
        target[i][3-j] = 1
        break
      else
        target[i][3-j] = -1
      end
    end
  end
end

16.times do |k|
  energy = 0
  4.times do |i|
    4.times do |j|
      energy += -0.5*w[i][j]*target[k][i]*target[k][j]
    end
    energy+=u[i]*target[k][i]
  end
  puts target[k].join(" ") +"\t\t"+ energy.to_s
end

16.times do |i|
  tem = ""
   puts "\n"
  4.times do |k|
    tem += target[i][k].to_s + " "
  end
  puts tem
  tem = ""
  total = 0
 
  30.times do |j|
    total = 0
    4.times do |k|
      kk = target[i][k]
      if kk == 1
        total += 2 ** (3-k)
      end
    end
    if total/10 == 1
      tem += total.to_s + "  "
    else
      tem += " " + total.to_s + " "
    end
    
    total=0
    rRound = rand 4
    4.times do |k|
      total += w[rRound][k] * target[i][k]
    end
    if total-u[rRound] >= 0
    target[i][rRound] = 1
    else
      target[i][rRound] = -1
    end
  end
    
  total = 0
  4.times do |j|
    4.times do |k|
      total += -0.5 * w[j][k] * target[i][j] * target[i][k]
    end
    total += u[j] * target[i][j]
  end
  tem += "   " + total.to_s
  puts tem
end