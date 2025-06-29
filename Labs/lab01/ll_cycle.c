#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node* tortoise = head;
    node* hare = head;
    while(1){
       hare = hare -> next;
       if(hare == NULL){
        return 0;
       }
       hare = hare -> next;
       if(hare == NULL){
        return 0;
       }
       tortoise = tortoise -> next;
       if(tortoise == hare){
        return 1;
       }
    }
    return -1;
}