#ifndef  DOUBLE_LIST_H
#define  DOUBLE_LIST_H

#include "define_type.h"
/**
 * double_list define;
 **/
struct double_list {
	struct double_list *prev;
	struct double_list *next;
};

/**
 * double_list init function
 **/
static  inline void double_list_init(struct double_list * list) 
{
	list->prev = list;
	list->next = list;
}
/**
 * double_list delete function;
 **/

static inline s32 double_list_is_empty(struct double_list *head)
{

	return head == head->next;

}
static inline s32 double_list_is_last(struct double_list *list, struct double_list *head)
{

	return head == list->next;

}

/**
 * double_list add function;
 **/
static inline void __double_list_add_entry(struct double_list *new, struct double_list *prev, struct double_list *next)
{
	prev->next = new;
	new->prev = prev;
	new->next = next;
	next->prev = new;
}
static inline void  double_list_add_head(struct double_list *new, struct double_list *head)
{
	__double_list_add_entry(new, head, head->next);


}
static inline void  double_list_add_tail(struct double_list *new, struct double_list *head)
{
	__double_list_add_entry(new, head->prev, head);
}

/**
 * double_list delete function;
 **/
static inline void  __double_list_delete_entry(struct double_list *prev, struct double_list *next)
{
	prev->next = next;
	next->prev = prev;
}

static inline void  double_list_delete(struct double_list *list)
{
	__double_list_delete_entry(list->prev, list->next);
}

/**
 * double_list replace function;
 **/
static  inline void double_list_replace(struct double_list *old, struct double_list *new) 
{
	old->prev->next = new;
	new->prev = old->prev;
	new->next = old->next;
	old->next->prev = new;
}

extern void  double_list_swap(struct double_list *old, struct double_list *new);

#endif /*DOUBLE_LIST_H*/
