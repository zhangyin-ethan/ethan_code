#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h> 
#include <libgen.h>
#define LENGTH_INT (8)

unsigned int hash(char *name)
{
	unsigned int h = 0, g = 0;

	while (*name) {
		h = (h << 4) + *name++;
		if (g = h & 0xf0000000)
			h ^= g >> 24;
		h &= ~g;
	}
	return h;
} 

int main(int argc, char* argv[], char* envp[])
{
	int fd_original, fd_encrypt;
	struct stat stat;
	if(argc < 3)	{
		printf("please input like this: ./decode <input_file>  <decode_key>, please retry\n");
		exit(EXIT_FAILURE);
	}
	//printf("elf  file is: %s\n", argv[0]);
	printf("input  file  is: %s\n", argv[1]);
	printf("decode  key  is: %s\n", argv[2]);

	//open the original file
	if ((fd_original = open(argv[1], O_RDONLY)) < 0)	{
		printf("read file:%s error, exit\n", argv[1]);
		exit(EXIT_FAILURE);
	}
	int size_original;
	size_original = (fstat(fd_original, &stat) < 0) ? 0 : stat.st_size;
	if (size_original <= 0){
		printf("original file size:%d wrong, exit!!\n", size_original);
		close(fd_original);
		exit(EXIT_FAILURE);
	}

	//creat the encrypt file
	
	char name_encrypt[256];
	char name_buf[256];
	char *str;
	char *tmp;
	strcpy((char *)name_buf, argv[1]);
	str = dirname(name_buf);
	strcpy(name_encrypt, str);
	strcat(name_encrypt, "/restored_file");
	printf("decoded file is: %s\n", name_encrypt);
	if (!access(name_encrypt, R_OK)){
		//printf("file:%s exit, delete first!!\n", name_encrypt);
		remove(name_encrypt);
	}

	if ((fd_encrypt = open(name_encrypt, O_RDWR|O_CREAT, 0644)) < 0){
		printf("open encrypt file:%s error, exit!!\n", name_encrypt);
		close(fd_original);
		exit(EXIT_FAILURE);
	}

	//the mian loop

	unsigned char buf_read[2];
	unsigned char buf_write[2];
	unsigned int n;
	unsigned int length_key;
	unsigned int value_file = 0;
	char * hash_str;
	unsigned int magic_num = 0;
	length_key =  strlen(argv[2]);
	//printf("random key length: 0x%x\n", length_key);

	hash_str = malloc(length_key + LENGTH_INT + 1);
	strcpy(hash_str, argv[2]);




	for(n = 0; n < size_original; n += 2) {
		//if ((read(fd_original, &buf_read[0], 1))  != 1) {
		if ((read(fd_original, &buf_read[0], 2))  != 2) {
			goto error_encrypt;		
		}
		sprintf(&hash_str[length_key], "%08x", value_file);
		magic_num =  hash(hash_str);
		magic_num = ((magic_num >> 16) + (magic_num & 0x0000ffff)) >> 1; //this is for 16 byte restore;
		//printf("hash_str: %s , magic:0x%x\n", hash_str, magic_num ); 

		//buf_write[0] = magic_num + buf_read[0];
		//buf_write[1] = (magic_num + buf_read[0]) >> 8;
		buf_write[0] = (buf_read[1] << 8) + buf_read[0] - magic_num;
		if ((write(fd_encrypt, &buf_write[0], 1)) != 1)	 {
			goto error_encrypt;		
		}

		//hash_str[length_key  + (m % LENGTH_FILE)] = buf_write[0];
		value_file += buf_write[0];
	}


	//close the original file
	goto  success_return;


error_encrypt:
	printf("error_encrypt, exit!!\n");
	free(hash_str);
	close(fd_original);
	close(fd_encrypt);
	remove(name_encrypt);
	exit(EXIT_FAILURE); 

success_return:
	free(hash_str);
	close(fd_original);
	close(fd_encrypt);
	exit(EXIT_SUCCESS);
}
