# ZXing-C++ Buildpack for Scalingo

Installs [zxing-cpp](https://github.com/zxing-cpp/zxing-cpp) v2.3.0 on Scalingo applications.

Supports `scalingo-22` and `scalingo-24` stacks.

## Usage

Tell Scalingo to use the buildpack:

```bash
$ echo "https://github.com/skribetech/zxing-cpp-buildpack.git" > .buildpacks
```

## What's Installed

- Library: `.zxing-cpp/lib/libZXing.so`
- Headers: `.zxing-cpp/include/ZXing/`

Environment variables are automatically configured:
- `ZXING_CPP_HOME=$HOME/.zxing-cpp`
- `LD_LIBRARY_PATH` includes the lib directory
- `PKG_CONFIG_PATH` includes pkg-config files
- `CMAKE_PREFIX_PATH` includes the installation directory

## Testing

Test locally with Docker:

```bash
./test-buildpack.sh scalingo-22
./test-buildpack.sh scalingo-24
```
