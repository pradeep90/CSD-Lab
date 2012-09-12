#include <math.h>
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>

int **allocate_matrix (int num_rows, int num_cols){
    int **matrix = (int **) malloc(num_rows * sizeof(int *));
    if (!matrix){
        fprintf (stderr, "Allocating pointer array failed.\nExiting...\n");
        exit (1);
    }
    int i;
    for(i = 0; i < num_rows; i++){
        matrix[i] = (int *)malloc(num_cols * sizeof(int));
        if (!matrix[i]){
            fprintf (stderr, "Allocating row failed.\nExiting...\n");
            exit (1);
        }
    }
    return matrix;
}

/**
 * Return the matrix product of matrices A and B.
 * The multiplication is done using block matrix multiplication method.
 * The total number of multiplications remains the same as in the
 * naive method but the number of memory accesses goes down.
 *
 * Assumptions: blocks are square matrices
 */
int **block_prod(int **A,
                 int **B,
                 int matrix_size,
                 int num_blocks)
{
    int **C;
    int block_size = matrix_size / num_blocks;
    C = allocate_matrix (matrix_size, matrix_size);

    int i, j, k, temp, sub_i, sub_j, sub_k;
    for (i = 0; i < num_blocks; i++){
        for (j = 0; j < num_blocks; j++){
            /* C_i_j: The submatrix at (i, j) */
            for (k = 0; k < num_blocks; k++){
                /* C_i_j = summation-k { A_i_k * B_k_j }
                   (multiplication of submatrices) */
                for (sub_i = 0; sub_i < block_size; sub_i++){
                    for (sub_j = 0; sub_j < block_size; sub_j++){
                        temp = 0;
                        for (sub_k = 0; sub_k < block_size; sub_k++){
                            /* temp += A[i + sub_i][k + sub_k] * B[k + sub_k][j + sub_j]; */
                        }
                        /* TODO: Maybe store the submatrix result in a
                           temp array and then write to C_i_j */
                        /* C[i + sub_i][j + sub_j] = temp; */
                    }
                }
            }

        }
    }
    return C;
}

/*
 * Print matrix.
 */
void print_matrix(int **A, int num_rows, int num_cols)
{
    int i,j;
    
    for (i = 0; i < num_rows; i++){
        for (j = 0; j < num_cols; j++){
            printf("%d\t", A[i][j]);
        }
        printf ("\n");
    }
}

int main(int argc, char *argv[])
{
    printf ("Yo, boyz!\n");
    int matrix_size = 2;
    int **A = allocate_matrix (matrix_size, matrix_size);
    int **B = allocate_matrix (matrix_size, matrix_size);
    int i, j;
    for (i = 0; i < matrix_size; i++){
        for (j = 0; j < matrix_size; j++){
            A[i][j] = i;
            B[i][j] = j;
        }
    }

    print_matrix (A, matrix_size, matrix_size);
    print_matrix (B, matrix_size, matrix_size);

    int **C = block_prod (A, B, matrix_size, 2);
    print_matrix (C, matrix_size, matrix_size);
    return 0;
}


