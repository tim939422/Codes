import numpy as np

if __name__ == '__main__':
    machine_zero = np.finfo(float).eps
    print(f'machine zero (double) in numpy: {machine_zero}')
    