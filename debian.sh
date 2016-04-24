#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=run_once
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-conky-starter

DEBVERSION=$(date +%Y%m%d)

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git pull origin master

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R $SOURCEBINPATH/ $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

<<<<<<< HEAD
mkdir -p debian/tmp/
=======
mkdir -p debian/tmp

>>>>>>> 98e14f5e9ba8e27de474fab286d69860942493ce
cp -R usr debian/tmp/usr
cp -R etc debian/tmp/etc

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo usr/bin/$SOURCEBIN usr/bin > debian/install 
echo etc/conkyrc etc >> debian/install 
echo etc/xdg/svirfneblin/rc.lua.conky.example etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/debian/menu.lua etc/xdg/svirfneblin/debian/ >> debian/install
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/awesome-conky-starter
#Vcs-Git: git@github.com:cmotc/svirfneblin-conky-starter
#Vcs-Browser: https://www.github.com/cmotc/svirfneblin-conky-starter

Package: $DEBFOLDER
Architecture: all
Depends: lightdm, lightdm-gtk-greeter, awesome (>= 3.4), svirfneblin-panel, conky, \${misc:Depends}
Description: A modified version of the debian rc.lua which starts conky, and
 a script which makes sure awesomewm only starts it once.
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name svirfneblin-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
