#include <stdio.h>
#include <string.h>

void printtable(unsigned char phymem,unsigned char logmem, unsigned char pagesize, unsigned char* mapping, unsigned char* data)
{
    unsigned char totalpages = logmem/pagesize;
    unsigned char totalframes = phymem/pagesize;
    printf("PAGE DATA:\n");
    printf("page# - data\n");
    for (int i = 0; i < totalpages;i++)
    {
        printf("%5d - ", i+1);
        for (int j = 0; j < pagesize; j++)
        {
            printf("%02X", data[2*i+j]);
        }
        printf("\n");
    }

    printf("\n");
    printf("PAGE TABLE:\n");
    printf("page# - frame# - (in)valid\n");
    for (int i = 0; i < totalpages;i++)
    {
        printf("%5d - ", i+1);
        char frame = 0;
        char valid = 0;
        for (int j = 0; j < totalframes; j++)
        {
            if (mapping[j] == i+1)
            {
                frame = j;
                valid = 1;
                break;
            }
        }
        if (valid)
        {
            printf("%6d - v\n", frame);
        }
        else
        {
            printf("       - i\n");
        }
    }

    printf("\n");
    printf("FRAME TABLE:\n");
    printf("frame# - free/allocated\n");
    for (int j = 0; j < totalframes; j++)
    {
        printf("%6d - ", j);
        if (mapping[j] == 0)
        {
            printf(" free\n");
        }
        else
        {
            printf("alloc\n");
        }
    }
    return;
}


int main(int argc, char *argv[])
{
    unsigned char phymem = 16;
    unsigned char logmem = 8;
    unsigned char pagesize = 2;
    unsigned char mapping_arr[8] = {1,0,0,3,0,4,0,0};
    unsigned char *mapping = mapping_arr;
    unsigned char data_arr[8] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef};
    unsigned char *data = data_arr;
    printtable(phymem,logmem,pagesize,mapping,data);
    return 0;
}