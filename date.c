#include "types.h" 
#include "user.h"
#include "date.h"

int
main(int argc, char * argv[]) 
{
    struct rtcdate r;
    char * months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
\
    if (date(&r)) {
        printf(2, "date_failed");
        exit();
    }

    //Prints the date in this specified format
    printf(1, "%s %d, %d %d:%d:%d UTC\n", months[r.month-1], r.day, r.year, r.hour, 
            r.minute, r.second);

    exit();
}
