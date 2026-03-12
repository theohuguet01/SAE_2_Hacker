#include <stdio.h>

int main(void)
{
    int user_login, user_passw;
    int n;

    puts(" ---------------------");
    puts(" ----- CRACKME 6 -----");
    puts(" ---------------------");

    printf("Login : ");
    fflush(NULL);
    n = scanf("%d", &user_login);
    if (n != 1)
    {
        puts("Incorrect login type");
        return 1;
    }

    printf("Password : ");
    fflush(NULL);
    n = scanf("%d", &user_passw);
    if (n != 1)
    {
        puts("Incorrect password type");
        return 2;
    }

    if (user_login == user_passw)
    {
        puts("** ACCESS GRANTED **");
    }
    else
    {
        puts("** ACCESS DENIED **");
    }

    return 0;
}
