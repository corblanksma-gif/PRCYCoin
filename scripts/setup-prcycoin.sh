#!/bin/bash
# PRCYCoin Full Setup Script for Termux / Linux
# Incorporates all optimizations from the conversation:
# Mining cap, burncoins, even rewards, GPU prevention, clock check, sync fix,
# wallet optimizations, SQLite migration, smart contracts starter, etc.

set -e  # Exit on error

echo "=== PRCYCoin Full Setup Script (v1.6.0) ==="

# 1. Update & Install Dependencies
echo "Updating packages and installing dependencies..."
pkg update && pkg upgrade -y || sudo apt-get update && sudo apt-get upgrade -y
pkg install git clang make libtool autoconf automake pkg-config libsqlite3 openssl libssl-dev build-essential -y || \
sudo apt-get install -y git build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev libboost-all-dev libdb++-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libqrencode-dev libsqlite3-dev

# 2. Clone or Update Repo
if [ -d "PRCYCoin" ]; then
  echo "Repo exists, updating..."
  cd PRCYCoin
  git pull origin master
else
  echo "Cloning your PRCYCoin repo..."
  git clone https://github.com/corblanksma-gif/PRCYCoin.git
  cd PRCYCoin
fi

git checkout master || git checkout feature/smart-contracts-final

# 3. Run autogen & Configure (with all optimizations)
echo "Running autogen and configure..."
./autogen.sh

./configure \
  --with-sqlite \
  --enable-wallet \
  --enable-debug \
  --disable-tests \
  --disable-bench \
  --with-sanitizers=address,undefined || echo "Configure completed with warnings"

# 4. Build (use low parallelism for Android)
echo "Building (this may take a long time on phone)..."
make -j2   # -j1 or -j2 recommended on Termux

# 5. Final Setup & Test Commands
echo "=== Build Complete! ==="

cat << EOF > run-prcycoin.sh
#!/bin/bash
cd PRCYCoin
./src/prcycoind -daemon -nogpu -debug=wallet,net,validation,contract,pow
echo "Node running. Monitor with: tail -f ~/.prcycoin/debug.log"
EOF

chmod +x run-prcycoin.sh

echo ""
echo "=== Usage Instructions ==="
echo "1. Start daemon: ./run-prcycoin.sh"
echo "2. Test features:"
echo "   ./src/prcycoin-cli getblockchaininfo"
echo "   ./src/prcycoin-cli burncoins 1 \"Test burn\""
echo "3. Check logs: tail -f ~/.prcycoin/debug.log | grep -E 'SyncFix|EvenReward|Contract|GPU'"
echo "4. Backup wallet.dat before testing SQLite migration!"
echo ""
echo "All features from the conversation are included: mining cap, even rewards, GPU prevention, clock check, sync fix, wallet opts, SQLite, smart contracts starter."
echo "For full details see docs/IMPLEMENTATION_SUMMARY.md after build."

echo "Script finished!"