#include <stdio.h>

int login = 145;
int passw = 954;

int main(void)
{
    int user_login, user_passw;
    int n;

    puts(" ---------------------");
    puts(" ----- CRACKME 5 -----");
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

    if (user_login == login && user_passw == passw)
    {
        puts("** ACCESS GRANTED **");
    }
    else
    {
        puts("** ACCESS DENIED **");
    }

    return 0;
}
