using Seismic, PyCall
@pyimport matplotlib.pyplot as plt


nt = 256; 
nx = convert(Int64,128);
h = Array(Header,nx);
for ix = 1:nx
  h[ix] = Seismic.InitSeisHeader();
  h[ix].tracenum = ix;
  h[ix].d1 = 0.004;
  h[ix].n1 = nt;
  h[ix].imx = ix;
  h[ix].imy = 0;
  h[ix].ihx = 0;
  h[ix].ihy = 0;
end

dt=0.004;
dx=25;
f_niquest=Int(floor(1/dt))
param=["dt"=>dt, "dx"=>dx]

data=rand(nt,nx)

f1 = plt.figure(1)
plt.imshow(data[1:nt,:],cmap="PuOr",aspect="auto",vmin=-1,vmax=1)
println("1")
plt.title("data before fk filter")
println("1")
plt.xlabel("X (m)")
println("1")
plt.ylabel("T (s)")
println("1")
plt.show()
println("1")


m=fft(data,1)/sqrt(size(data,1));
m=fft(m,2)/sqrt(size(data,2))
m=fftshift(m)

m=m[Int(floor(f_niquest/2)):f_niquest,:]

println("2")

f11 = plt.figure(11)
plt.imshow(abs(m),cmap="PuOr",aspect="auto",vmin=-1,vmax=1)
plt.title("fk spectrum before filter")
plt.xlabel("K (1/m)")
plt.ylabel("W (1/s)")
plt.show()

println("3")

# apply FK filter
data_fk,fk_spec,h = SeisFKFilter(data,h,param)

println("4")

f2 = plt.figure(2)
plt.imshow(data_fk[1:nt,:],cmap="PuOr",aspect="auto",vmin=-1,vmax=1)
plt.title("data after fk filter")
plt.xlabel("X (m)")
plt.ylabel("T (s)")
plt.show()

println("5")

f21 = plt.figure(21)
plt.imshow(fk_spec,cmap="PuOr",aspect="auto",vmin=-1,vmax=1)
plt.title("fk spectrum after filter")
plt.xlabel("K (1/m)")
plt.ylabel("W (1/s)")
plt.show()
