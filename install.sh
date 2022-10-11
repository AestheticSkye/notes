swift build -c release

INSTALLSUM= shasum -a 256 /usr/local/bin/notes > /dev/null 2>&1
NEWSUM= shasum -a 256 .build/release/notes > /dev/null 2>&1

if [ $INSTALLSUM == $NEWSUM ]
then
	echo "This version is already installed"
	exit
fi

sudo mv .build/release/notes /usr/local/bin/

echo "Package Installed"
