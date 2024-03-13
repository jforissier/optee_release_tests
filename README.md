## Testing a new OP-TEE release on QEMUv8 (rebuilds the Docker image which includes the OP-TEE source tree)

cd qemuv8
make cleaner
make all-tests
make results

# (Re-)run a single test
rm out/test-01*
make test-01

## Run the tests without rebuilding the Docker image

Use "make clean" instead of "make cleaner"
