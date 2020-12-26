#/bin/bash
set -eu

cd $(dirname "$0")

./dependencies.sh

docker build .

echo "Done!"
