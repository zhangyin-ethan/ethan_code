#include  <linux/init.h>
#include  <linux/timer.h>
#include  <linux/delay.h>
#include  <linux/module.h>
#include  <linux/workqueue.h>

extern struct timeval before_idle_time;
extern struct timeval after_idle_time;

static void test_function1(struct work_struct *work);
static DECLARE_WORK(test_work1, test_function1);
struct  workqueue_struct *test_queue;

static void test_function1(struct work_struct *work)
{
	int count = 0;	
	unsigned int  unit = 1000000;
	int second = 120;
	while (1) {
		mdelay(10);
		msleep(10);
		count ++;	
		if (count % 50) {
			printk("runtime :%d -%ld, idle time:%ld-%ld",  \
					run_time_ethan/unit, run_time_ethan%unit, \
					idle_time_ethan/unit, idle_time_ethan%unit, \
					idle_time_ethan*100/(idle_time_ethan + run_time_ethan));
		}
		if (second * 50 == count) {
			break;
		}
	}

	return ;
}


static int __init cpu_test_init(void)
{
	printk("come-to %s\n", __func__);
	test_queue = create_singlethread_workqueue("test_queue");
	if (test_queue == NULL) {
		printk("creat_singlethread error");
		return 1 ;
	}
	queue_work(test_queue, &test_work1);
	return 0;
}

module_init(cpu_test_init);


static void __exit cpu_test_exit(void)
{
	printk("come-to %s\n", __func__);
	cancel_work_sync(&test_work1);
	destroy_workqueue(test_queue);
}
module_exit(cpu_test_exit);

MODULE_AUTHOR("Ethan Zhang,<zhangyin_ethan@126.com>");
MODULE_DESCRIPTION("work_queue test");
MODULE_LICENSE("GPL");
MODULE_ALIAS("cpu_test:work_queue");
