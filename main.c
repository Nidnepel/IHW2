#include <stdio.h>
#include <malloc.h>

int main()
{
	    int n;
	        scanf("%d\n", &n);
		    char *arr = malloc(n * sizeof(char));
		        int countUpper = 0;
			    int countLower = 0;
			        for (int i = 0; i < n; ++i) {
					        scanf("%c", &arr[i]);
						        if (arr[i] >= 'A' && arr[i] <= 'Z') {
								            countUpper++;
									            }
							        if (arr[i] >= 'a' && arr[i] <= 'z') {
									            countLower++;
										            }
								    }
				    free(arr);
				        printf("%d\n", countUpper);
					    printf("%d\n", countLower);
					        return 0;
}
