/*include system files*/
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h> 
#include <libgen.h>
//#include <linux/list.h>  rewrite the double list function

/*include local files*/
#include "define_type.h"

//#include "rbtree.h"
//#include "file_operation.h"
//#include "file_operation.h"

/*
 * this program complete the follow functions:
 * 1. file operations
 * 2. string operations
 * 3. double_list operations
 * 4. red-black tree
 * 5. hash table
 * 6. all
 */

#define COMMAND_LEN  (16) 
#define USE_DOUBLE_LIST

#ifdef  USE_DOUBLE_LIST
#include "double_list.h"
#endif


struct student{

#ifdef  USE_DOUBLE_LIST
	struct double_list list;
#endif
 	u8 name[256];
	u32 id;
	u32 score;
};

struct file_header{
	u8 instruction[256];
	u32 number;
	f32 score_average;
};
/**
 *global data define
 **/
struct double_list student_list_global;
struct double_list *student_head = &student_list_global;

/* array command: 
 * the command length must unber COMMAD_LEN;
 */
static s32 do_nothing(u8 *str)
{
	printf("the action do noting!!\n");
	return -1;
}

static s32 do_insert(u8 *str)
{

#if 0
	printf("the action do insert!!\n");
	return -1;
#endif

#if  1
	s32 ret;
	struct student *stu;
	stu = malloc(sizeof(struct student));
	//printf("come 111111\n");
	ret = sscanf(str, "%s%u%u", stu->name, &stu->id, &stu->score);
	if (3 != ret)  {
		//printf("format error, repeat again!!\n");
		goto error;		
	}
	//printf("come 2222\n");
	double_list_add_tail(&stu->list, student_head);
	return 0;
	
error:
	free(stu);
	return -1;
#endif
}

static s32 do_deletename(u8 *str)
{
	return 0;
}

static s32 do_show(u8 *str)
{
	printf("come to do_show go next!!\n");
	struct double_list *p;
	for(p = student_head->next; p != student_head; p = p->next) {
		struct student * stu = (struct student *)p;
		printf("name:%s, id:%d, score:%d\n", stu->name, stu->id, stu->score);
	}
	printf("come to do_show go prev!!\n");
	//struct double_list *p;
	for(p = student_head->prev; p != student_head; p = p->prev) {
		struct student * stu = (struct student *)p;
		printf("name:%s, id:%d, score:%d\n", stu->name, stu->id, stu->score);
	}

	return 0;
}
static s32 do_exit(u8 *str)
{

	exit(EXIT_SUCCESS);
	return 0;
}

static s32 do_sortscore(u8 *str)
{
	printf("come to do_sortscore!!\n");
	struct double_list *p, *p0, *p1;
	struct student *stu0, *stu1;
	for(p0 = student_head->next; student_head != p0; p0 = p0->next) {
		for(p1 = p0->next; student_head != p1; p1 = p1->next){
			stu0 = (struct student *)p0;
			//printf("11name:%s, id:%d, score:%d\n", stu0->name, stu0->id, stu0->score);
			stu1 = (struct student *)p1;
			//printf("22name:%s, id:%d, score:%d\n", stu1->name, stu1->id, stu1->score);
			if (stu0->score > stu1->score) {
				//printf("name:%s, id:%d, score:%d\n", stu0->name, stu0->id, stu0->score);
				double_list_swap(p0, p1);
				p = p0;
				p0 = p1;			
				p1 = p;
			}
		}
	}
	printf("end   do_sortscore!!\n");
	return 0;
}

static s32 do_findname(u8 *str)
{
	return 0;
}


static u8 *command[] ={
	":insert--add some record\n",
	":deletename--delete some record\n",
	":show--show student record\n",
	":sortscore--sort student by core\n",
	":findname--find student by name\n",
	":exit--quit the system\n",
};
typedef s32 (*action_t)(u8 *);
struct action{
	u8 command[COMMAND_LEN];
	action_t action;
};
struct action  action_array[sizeof(command)/sizeof(u8 *)];

static void initiate_action(void)
{
	u32 n, m;
	for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
		for(m = 0; command[n][m] != '-'; m++) {
			action_array[n].command[m] = command[n][m];
		}
		action_array[n].command[m] = '\0';
		action_array[n].action = do_nothing;
	}
	printf("list all the command\n");
	for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
		printf("%s\n", action_array[n].command);
	}
	return;
}

/* function: add_action() returns
 * -1: fail ;
 * 0:  ok;
 */
static s32  add_action(u8 *cmd, action_t fn)
{
	u32 n;
	s32 ret;
	for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
		if (0 == (strcmp(action_array[n].command, cmd))) {
			action_array[n].action = fn;
			return 0;
		}
	}
	if (n  ==  sizeof(command)/sizeof(u8 *))
		return -1;
}
/* 
 * function: add_action() returns
 * -1: fail ;
 * 0 : ok;
 */
static s32  do_action(u8 *cmd, u8 *str)
{
	u32 n;
	for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
		if (0 == (strcmp(action_array[n].command, cmd))) {
			return action_array[n].action(str);
		}
	}
	return -1;
}


static void show_command(void)
{
	u32 n;
	for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
		printf("%s", command[n]);
	}
}

static s32 parse_str(u8 *str)
{
	return 0;	
}
/* function: search_command() returns
 * -2: common str ;
 * -1: wrong command ;
 * >= 0: right command ;
 */

static s32 match_command(u8 *str)
{
	u32 n, m, ret;
	if (str[0] != ':')
		return -2;
	else {
		for(n = 0; n < sizeof(command)/sizeof(u8 *); n++) {
			ret = 0;
			for (m = 0; command[n][m] != '-'; m++) {
				ret += !!(str[m] - command[n][m]);
			}
			if (!ret) 
				return n;	
		}
		if (n == sizeof(command)/sizeof(u8 *))
			return -1;
	}
}

u8 last_command[COMMAND_LEN];
static void fix_command(u32 n)
{
	u32 m;
	for(m = 0; command[n][m] != '-'; m++) {
		last_command[m] = command[n][m];
	}
	last_command[m] = '\0';
	return;
}


void initiate_student_list(void)
{
	double_list_init(student_head);
}

int main(int argc, char *argv[], char *envp[]) 
{
	u8 	file_saved[256];
	s32 fd_saved;
	s32	 ret;

	//printf("argv:%d\n", sizeof(argv));
	strcpy(file_saved, argv[0]);
	dirname(file_saved);
	strcat(file_saved, "/student_record.c");
	printf("save_file:%s\n", file_saved);
	if ((fd_saved = open(file_saved, O_RDWR|O_CREAT, 0644)) < 0){
		printf("open file:%s error, exit!!\n", file_saved);
		close(fd_saved);
		exit(EXIT_FAILURE);
	}
	initiate_action();
	if ((ret = add_action(":show", do_show)) < 0) {
		printf("add_action show fail!!\n");
	}
	if ((ret = add_action(":insert", do_insert)) < 0) {
		printf("add_action insert fail!!\n");
	}
	if ((ret = add_action(":sortscore", do_sortscore)) < 0) {
		printf("add_action sortscore fail!!\n");
	}
	if ((ret = add_action(":exit", do_exit)) < 0) {
		printf("add_action exit fail!!\n");
	}
	initiate_student_list();

#if 0
	u8 n;
	s32 num;
	char buf[256];
	for(n = 0; n < 5; n ++){
		fgets(buf, 256, stdin);
		num = strlen(buf);
		printf("record num:%d\n", num);
		printf("record str:%s\n", buf);
	}
#endif
#if 1
	u32 n, num;
	char buf[256];
	show_command();
	//for(n = 0; n < 5; n ++){
	while(1) {
		fgets(buf, 256, stdin);
		ret = match_command(buf);
		if (ret >= 0) {
			fix_command(ret);
			do_action(last_command, buf);
			//printf("last_command %s\n", last_command);
		}
		else if(ret == -2){
			printf("last_command %s\n", last_command);
			do_action(last_command, buf);
		}
		else{
			printf("command input error!!\n");
			show_command();
		}
	}
#endif

	//strcpy(home_dir, argv[0]);

	//printf("the first arg: %s\n", argv[0]);
	close(fd_saved);
	exit (EXIT_SUCCESS);
}
