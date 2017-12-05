
#include <stdio.h>

int main(void)
{
	int a[25], i=0, j=0, n, t, w ;

	printf ("\n Enter size of list (between 1 and 25): ");
	scanf ("%d", &n);
    printf ("\n");
    if(n<1 || n>25){
        printf("incorrect size of list");
        return 0;
    }
	for (i = 0; i <n; i++)
	{
		printf ("\n Enter the %dth element: ", (i+1));
		scanf ("%d", &a[i]);
	}

    printf("\n Content of list:  ");
	for (i = 0; i <n; i++){
        printf(" %d", a[i]);
	}

    for (j=0 ; j<(n-1) ; j++)
        {
            for (i=0 ; i<(n-1) ; i++)
        {
			if (a[i+1] < a[i])
			{
				t = a[i];
				a[i] = a[i + 1];
				a[i + 1] = t;
			}
		}
	}
	printf ("\n Content of list:  ");
	for (i=0 ; i<n ; i++)
	{
		printf (" %d", a[i]);
	}
    printf("\n Enter a key to search for: ");
    scanf ("%d", &w);
     i = 0;
        while (i < n && w != a[i]) {
      i++;
    }

     if (i < n) {
      printf("Key found!");
   } else {
      printf("Key not found");
   }
      return 0;

}
