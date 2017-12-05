#include <stdlib.h>
#include <stdio.h>

int mystery(int n) {
    if (n == 0)
       return 0;
    else
       return 2*mystery(n-1)+1;
}





int main() {
	int x;
	x = mystery(32);
	printf("num is %d\n", x);
	return 0;

}
