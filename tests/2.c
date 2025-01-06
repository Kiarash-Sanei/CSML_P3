#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to allocate memory for a matrix
float **allocateMatrix(int rows, int cols)
{
    float **matrix = (float **)malloc(rows * sizeof(float *));
    for (int i = 0; i < rows; i++)
    {
        matrix[i] = (float *)malloc(cols * sizeof(float));
    }
    return matrix;
}

// Function to free the memory allocated for a matrix
void freeMatrix(float **matrix, int rows)
{
    for (int i = 0; i < rows; i++)
    {
        free(matrix[i]);
    }
    free(matrix);
}

// Function to multiply two matrices
float **multiplyMatrices(float **mat1, int rows1, int cols1, float **mat2, int cols2)
{

    float **result = allocateMatrix(rows1, cols2);
    for (int i = 0; i < rows1; i++)
    {
        for (int j = 0; j < cols2; j++)
        {
            result[i][j] = 0;
            for (int k = 0; k < cols1; k++)
            {
                result[i][j] += mat1[i][k] * mat2[k][j];
            }
        }
    }
    return result;
}

int main()
{
    char test[100];
    scanf("%s", test);
    char fullName[150];
    strcat(fullName, "./samples/");
    strcat(fullName, test);
    strcat(fullName, ".txt");
    FILE *file = fopen(fullName, "r");
    if (file == NULL)
    {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    int rows1, cols1, cols2;

    // Read dimensions
    fscanf(file, "%d %d %d", &rows1, &cols1, &cols2);
    float **mat1 = allocateMatrix(rows1, cols1);

    // Read elements of the first matrix
    for (int i = 0; i < rows1; i++)
    {
        for (int j = 0; j < cols1; j++)
        {
            fscanf(file, "%f", &mat1[i][j]);
        }
    }

    float **mat2 = allocateMatrix(cols1, cols2);

    // Read elements of the second matrix
    for (int i = 0; i < cols1; i++)
    {
        for (int j = 0; j < cols2; j++)
        {
            fscanf(file, "%f", &mat2[i][j]);
        }
    }

    fclose(file);

    // Perform matrix multiplication
    float **result = multiplyMatrices(mat1, rows1, cols1, mat2, cols2);

    if (result != NULL)
    {
        printf("Resulting Matrix:\n");
        for (int i = 0; i < rows1; i++)
        {
            for (int j = 0; j < cols2; j++)
            {
                printf("%.2f ", result[i][j]);
            }
            printf("\n");
        }
        freeMatrix(result, rows1);
    }

    // Free allocated memory
    freeMatrix(mat1, rows1);
    freeMatrix(mat2, cols1);

    return 0;
}
