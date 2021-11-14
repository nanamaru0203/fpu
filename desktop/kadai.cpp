#include <mpi.h>
#include <iostream>
#include <algorithm>
#include <random>
using namespace std;

int main(int argc,char** argv){
    int myid;
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    int n=4400000;
    int *a;
    int *b;
    int *c;
    a=(int *)malloc(n*sizeof(int));
    b=(int *)malloc(n*sizeof(int));
    c=(int *)malloc(n*sizeof(int));
    if(myid==0){
        for(int i=0;i<n;i++){
            a[i]=rand();
        }
    }
    //分配
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Scatter(a,n/8,MPI_INT,b,n/8,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    double t1=MPI_Wtime();
    //merge sort
    sort(b,b+n/8);
    MPI_Barrier(MPI_COMM_WORLD);
    //a,bをcに
    if(myid%2==0){
        MPI_Recv(a,n/8,MPI_INT,myid+1,0,MPI_COMM_WORLD,NULL);
        int ai=0;
        int bi=0;
        for(int i=0;i<n/4;i++){
            if(ai==n/8){
                c[i]=b[bi];
                bi++;
            }
            else if(bi==n/8){
                c[i]=a[ai];
                ai++;
            }
            else{
                if(a[ai]<=b[bi]){
                    c[i]=a[ai];
                    ai++;
                }
                else{
                    c[i]=b[bi];
                    bi++;
                }
            }
        }
    }
    else{
        MPI_Send(b,n/8,MPI_INT,myid-1,0,MPI_COMM_WORLD);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    //b,c->a
    if(myid%4==0){
        MPI_Recv(b,n/4,MPI_INT,myid+2,0,MPI_COMM_WORLD,NULL);
        int ci=0;
        int bi=0;
        for(int i=0;i<n/2;i++){
            if(ci==n/4){
                a[i]=b[bi];
                bi++;
            }
            else if(bi==n/4){
                a[i]=c[ci];
                ci++;
            }
            else{
                if(c[ci]<=b[bi]){
                    a[i]=c[ci];
                    ci++;
                }
                else{
                    a[i]=b[bi];
                    bi++;
                }
            }
        }
    }
    else if(myid%4==2){
        MPI_Send(c,n/4,MPI_INT,myid-2,0,MPI_COMM_WORLD);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    //a,b->c
    if(myid==0){
        MPI_Recv(b,n/2,MPI_INT,myid+4,0,MPI_COMM_WORLD,NULL);
        int ai=0;
        int bi=0;
        for(int i=0;i<n;i++){
            if(ai==n/2){
                c[i]=b[bi];
                bi++;
            }
            else if(bi==n/2){
                c[i]=a[ai];
                ai++;
            }
            else{
                if(a[ai]<=b[bi]){
                    c[i]=a[ai];
                    ai++;
                }
                else{
                    c[i]=b[bi];
                    bi++;
                }
            }
        }
    }
    else if(myid==4){
        MPI_Send(a,n/2,MPI_INT,myid-4,0,MPI_COMM_WORLD);
    }
    MPI_Barrier(MPI_COMM_WORLD);
    /*if(myid==0){
      for(int i=0;i<n;i++)
	cout<<c[i]<<endl;
	}*/
    MPI_Scatter(c,n/8,MPI_INT,a,n/8,MPI_INT,0,MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    double t2=MPI_Wtime();
    if(myid==0)
      cout<<t2-t1<<" s"<<endl;
    MPI_Finalize();
    return 0;
}
