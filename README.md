
# Amadeus System Simulation Guide

This guide provides instructions for simulating and verifying the Amadeus system using Python models and RTL (Register-Transfer Level) simulations.

## Python Model Simulation

### Prerequisites

- Python 3.x installed
- Access to the `modeling` directory within the project repository

### Running the Tests

To run the test scripts, navigate to the `modeling` directory in your terminal and execute the appropriate Python scripts:

```bash
cd modeling
python3 amadeus_test1.py  # Tests the first layer convolution
python3 amadeus_test2.py  # Tests the second layer convolution
python3 amadeus_test3.py  # Tests the third layer convolution
python3 amadeus_test4.py  # Tests the third layer convolution with the accumulation method
python3 amadeus_test5.py  # Tests the second layer convolution with the accumulation method
```

Each test script automatically checks the correctness of the model. An all-zeros output following the "check correctness" message indicates that the output is correct and the model is functioning as expected.

### Test Script Descriptions

- `amadeus_test1.py`: This script performs the convolution test for the first layer.
- `amadeus_test2.py`: This script performs the convolution test for the second layer.
- `amadeus_test3.py`: This script performs the convolution test for the third layer.
- `amadeus_test4.py`: This script performs the third layer convolution using an accumulation method.
- `amadeus_test5.py`: This script performs the second layer convolution using an accumulation method.

### Code Structure

- `pe.py`: Defines the PE (Processing Element) class, containing necessary fields and functions for performing 1-D convolutions.
- `amadeus.py`: Instantiates the PE class as a 6x7 array to perform convolutions, simulates input to the PE, performs 1-D convolutions, accumulates PSUM output, and compares the results against expected outputs.

## RTL Simulation

### Prerequisites

- Access to the `rtl` directory within the project repository
- Design Verification Environment (DVE) software installed

### Running RTL Simulation

For RTL simulation, follow these steps in the terminal:

```bash
cd rtl
make dve
```

Executing the above command will open the DVE for RTL simulation, allowing for the verification of the hardware design's logic and functionality.
