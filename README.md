## Testing a new OP-TEE release on QEMUv8 (rebuilds the Docker image which includes the OP-TEE source tree)

```
cd qemuv8
make cleaner
make -j4 all  # build & run 4 configurations simultaneously, each with make -j$(nproc)
make results
```

# (Re-)run a single test

```
rm out/test-01*
make test-01
```

## Run the tests without rebuilding the Docker image

Use "make clean" instead of "make cleaner"
