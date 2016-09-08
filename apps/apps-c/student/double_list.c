#include "double_list.h"
/**
 * double_list swap function;
 **/
void  double_list_swap(struct double_list *old, struct double_list *new) 
{
	struct double_list  list_temp;
	double_list_replace(old, &list_temp);
	double_list_replace(new, old);
	double_list_replace(&list_temp, new);
}

