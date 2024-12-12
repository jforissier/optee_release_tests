## Testing a new OP-TEE release on QEMUv8 (rebuilds the Docker image which includes the OP-TEE source tree)

```
cd qemuv8
make cleaner
make -k -j4 all  # build & run 4 configurations simultaneously, each with make -j$(nproc)
make results
```

When a test fails, the Docker container is kept for eventual inspection. Use
`docker ps -a` to see the containers, including the stopped ones.

# (Re-)run a single test

```
rm out/test-01*
docker rm -f test-01
make test-01
```

## Run the tests without rebuilding the Docker image

Use "make clean" instead of "make cleaner"
