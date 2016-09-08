#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <fcntl.h>
#include <memory.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <signal.h>
#include <semaphore.h>



sem_t sem1, sem2;
int i=0;  
int total_num = 1000000;
float f1 = 1.23456;
float f2 = 2.34567;	

void thread1(void)  
{  
	unsigned int n;
    do  
    {  
        sem_wait(&sem1);//等待sem1信号量   
		for( n = 0; n < 10000; n++){
			f2 *= f1;
		}

    	printf("thread1--f2:%f\n", f2);  
        sem_post(&sem2);//增加sem2信号量，使得thread2能够执行   
				
    }while(i<=total_num);  
		
    pthread_exit(NULL);  
		
}  
		
void thread2(void)  
{  
	unsigned int n;		
    do  
    {  
				
        sem_wait(&sem2);  
		for( n = 0; n < 10000; n++){
			f2 /= f1;
		}

    	printf("thread2--f2:%f\n", f2);  
				
        sem_post(&sem1);  
				
    }while(i<=total_num);  
		
    pthread_exit(NULL);  
		
}  
		
  
		
int main(int argc, char **argv)  
				
{  
				
    int ret;  
				
    pthread_t a,b;  
				
    sem_init(&sem1,0,1);//初始化sem1为1，使thread1先执行   
				
    sem_init(&sem2,0,0);  
				
    ret=pthread_create(&a,NULL,(void *)thread1,NULL);  
				
    if(ret!=0)  
				
    {  
				
        printf ("Create pthread error!\n");  
				
        exit (1);  
				
    }  
				
    ret=pthread_create(&b,NULL,(void *)thread2,NULL);//返回值为0，创建成功   
				
    if(ret!=0)  
				
    {  
				
        printf ("Create pthread error!\n");  
				
        exit (1);  
				
    }  
				
    pthread_join(a,NULL);  
				
    pthread_join(b,NULL);  
				
    sem_destroy(&sem1);  
				
    sem_destroy(&sem2);  
				
    return 0;  
				
}  

