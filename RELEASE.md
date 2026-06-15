# PRCY Coin Optimized Release v1.1.0

## What's New
- Mining supply capped at initial 1,000,000 PRCY period
- New `burncoins` RPC for permanent coin destruction
- Performance optimizations in consensus and mining
- Wallet and key management modernization
- Updated build system and CI
- Improved logging and best practices

## Build Instructions

### Prerequisites
- Ubuntu 20.04+ or equivalent
- Dependencies: autoconf, automake, libtool, pkg-config, build-essential, libssl-dev, libevent-dev, libboost-all-dev, etc.

### Steps
```bash
git clone https://github.com/corblanksma-gif/PRCYCoin.git
cd PRCYCoin
./autogen.sh
./configure --disable-tests --enable-upnp-default
make -j$(nproc)
```

### Run
```bash
./src/prcycoind -daemon
./src/prcycoin-cli getinfo
```

## Testing
- Run unit tests: `make check`
- Functional tests: `test/functional/test_runner.py`
- New burn feature test included.

## Security Notes
- Updated dependencies recommended
- Test thoroughly before mainnet use

## Changelog
See git log for full details.

## Support
Telegram: t.me/prcycoinofficial
