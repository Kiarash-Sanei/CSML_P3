#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// Function to generate a random float number between 0 and 1
float generateRandomFloat()
{
    return (float)rand() / RAND_MAX;
}

// Function to generate a matrix and write it to a file
void generateMatrixToFile(const char *filename, int rows, int cols, int cols2)
{
    char fullName[150];
    strcat(fullName, "./samples/");
    strcat(fullName, filename);
    strcat(fullName, ".txt");
    FILE *file = fopen(fullName, "w");
    if (file == NULL)
    {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    fprintf(file, "%d %d %d\n", rows, cols, cols2); // Write dimensions to the file
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            float value = generateRandomFloat();
            fprintf(file, "%.2f ", value); // Write the float value with 2 decimal places
        }
        fprintf(file, "\n");
    }
    for (int i = 0; i < cols; i++)
    {
        for (int j = 0; j < cols2; j++)
        {
            float value = generateRandomFloat();
            fprintf(file, "%.2f ", value); // Write the float value with 2 decimal places
        }
        fprintf(file, "\n");
    }

    fclose(file);
    printf("Matrix successfully written to %s.txt\n", filename);
}

int main()
{
    int rows, cols, cols2;
    char test[100];

    // Input dimensions
    printf("Enter the number of rows of first matrix: ");
    scanf("%d", &rows);
    printf("Enter the number of columns of first matrix (rows of second matrix): ");
    scanf("%d", &cols);
    printf("Enter the number of columns of second matrix: ");
    scanf("%d", &cols2);

    // Input filename
    scanf("%s", test);

    // Seed the random number generator
    srand(time(NULL));

    // Generate and write the matrix to the file
    generateMatrixToFile(test, rows, cols, cols2);

    return 0;
}
