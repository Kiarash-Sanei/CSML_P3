# Matrix Operations in Assembly

This project implements various matrix operations in x86_64 assembly language. It includes multiple programs that handle both integer and floating-point matrix calculations.

## Programs Overview

### 1. Basic Matrix Multiplication (1.s)
- Reads two integer matrices and performs matrix multiplication
- Uses functions: RI (Read Integer), CMS (Check Matrix Size), RIM (Read Integer Matrix), MIM (Multiply Integer Matrix), PIM (Print Integer Matrix)

### 2. Matrix Transpose and Trace (2.s)
- Performs matrix transpose operation followed by multiplication
- Calculates trace of the resulting matrix
- Uses functions: TIM (Transpose Integer Matrix), TIMC (Trace Integer Matrix Calculation)

### 3. Floating-Point Matrix Multiplication (3.s)
- Similar to program 1 but handles floating-point matrices
- Uses functions: RFM (Read Float Matrix), MFM (Multiply Float Matrix), PFM (Print Float Matrix)

### 4. Parallel Floating-Point Matrix Multiplication (4.s)
- Implements parallel floating-point matrix multiplication
- Uses MPFM (Multiply Parallel Float Matrix) for better performance

### 5. Direct Trace Calculation (5.s)
- Calculates trace of matrix multiplication directly
- Uses DTIMC (Direct Trace Integer Matrix Calculation)

### 6. Floating-Point Transpose and Trace (6.s)
- Floating-point version of program 2
- Uses TFM (Transpose Float Matrix), TFMC (Trace Float Matrix Calculation)

### 7. Direct Parallel Trace Calculation (7.s)
- Parallel version of program 5
- Uses DPTIMC (Direct Parallel Trace Integer Matrix Calculation)

## Building and Running

Each program has its own shell script (*.sh) for building and running.

## Error Handling
- All programs include size validation using CMS (Check Matrix Size)
- Maximum matrix size is defined as 10000 elements
- Returns error code 1 if matrix size exceeds limit

## Testing
The project includes C test programs (in tests/ directory) for:
- Generating test matrices with random values
- Verifying results of assembly implementations

## Dependencies
- NASM assembler
- GCC compiler
- Linux x86_64 environment