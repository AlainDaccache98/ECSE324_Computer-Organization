#include "address_map_arm.h"

int main(void)
{
	int a[5] = {1,20,3,4,5};
	int max_val = a[0];
	int i;
	for(i = 1; i < sizeof(a)/sizeof(a[0]); i++){
		if(max_val < MAX_2(a[i-1],a[i])){
			max_val = MAX_2(a[i-1],a[i]);
		}
	}
	printf("%d", max_val);
	return max_val;
}
