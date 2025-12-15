# ZXing-C++ Buildpack for Scalingo

Installs [zxing-cpp](https://github.com/zxing-cpp/zxing-cpp) v2.3.0 on Scalingo applications.

Supports `scalingo-22` and `scalingo-24` stacks.

## Usage

This buildpack requires cmake to compile zxing-cpp. Use Scalingo's APT buildpack to install it.

1. Create an `Aptfile` with the required dependency:

```bash
$ echo "cmake" > Aptfile
```

2. Configure your buildpacks (APT buildpack must run first):

```bash
$ cat > .buildpacks << EOF
https://github.com/Scalingo/apt-buildpack.git
https://github.com/skribetech/zxing-cpp-buildpack.git
EOF
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
