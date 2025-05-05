#include <stdio.h>
#include <errno.h>
#include <string.h>

int main (void)
{
  FILE *fp = fopen ("./sample.txt", "w");
  if (fp != NULL)
    {
	printf("File opened with fd=%d\n", fileno(fp));
	if (fprintf (fp, "Random text\n") < 0)
		{
		fprintf (stderr, "err=%d: %s\n", errno, strerror (errno));
		fclose (fp);
		return errno;
		}
	fclose (fp);
    }
  return 0;
}
