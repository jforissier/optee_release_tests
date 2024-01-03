## Testing a new OP-TEE release on QEMUv8 (rebuilds the Docker image which includes the OP-TEE source tree)

cd qemuv8
make cleaner
make -j
make results

## Run the tests without rebuilding the Docker image

cd qemuv8
make clean
make -j 
make results
