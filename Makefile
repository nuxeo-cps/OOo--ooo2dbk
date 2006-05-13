# $Id$

projectName := ooo2dbk
projectPath := $(shell pwd)
# $(notdir names...) extracts all but the directory-part of each file name in
# names.
projectDir := $(notdir ${projectPath})

version = $(shell grep VERSION VERSION | cut -d"=" -f2)

buildDir := ${projectName}-${version}
buildDirPath := /tmp/${buildDir}
buildArchivePath := /tmp/${projectName}-${version}.tar.gz

.PHONY: test clean check patch dist debian-dist debian rpm

test:
	echo "version = ${version}"

clean:
	find . "(" -name "*~" -or  -name ".#*" -or -name "*.pyc" ")" -print0 | xargs -0 rm -f
	rm -rf images

check:
	pychecker2 *.py

pkg:
	@(cd ooo ; \
	${MAKE} ; \
	find -not -name . -not -name .. \
	-not -name "*.stw" -not -name "*.zip" -print0 \
	| xargs -0 rm -rf ; \
	)

patch:
	diff -uNr ooo2dbk-orig/ ooo2dbk > distrib.patch

dist: clean
	rm -rf ${buildDirPath}
	rm -rf ${buildArchivePath}
	mkdir ${buildDirPath}
	cp -a README.txt HISTORY COPYING doc \
	__init__.py ole2img.py ooo2dbk \
	ooo2dbk.xml ooo2dbk.xsl ooo2dbk-fo.xsl \
	${buildDirPath}
	tar cvzf ${buildArchivePath} \
	--directory /tmp \
	${buildDir}

debian-dist: clean
	rm -rf ../ooo2dbk-${version} ../ooo2dbk_${version}.orig.tar.gz
	cp -a ../ooo2dbk ../ooo2dbk-${version}
	tar cvzf ../ooo2dbk_${version}.orig.tar.gz \
	--directory .. \
	--exclude ${projectDir}/CHANGES \
	--exclude .svn \
	--exclude ${projectDir}/setup.py \
	--exclude ${projectDir}/rpm \
	ooo2dbk-${version}
	rm -rf ../ooo2dbk-${version}

debian: debian-dist
	cd .. && tar xvzf ooo2dbk_${version}.orig.tar.gz && \
	cd ooo2dbk-${version} && dpkg-buildpackage -rfakeroot -uc -us

rpm: dist
	sudo cp ${buildArchivePath} /usr/src/rpm/SOURCES/
	sudo cp distrib.patch /usr/src/rpm/SOURCES/
	# -bb builds a binary package
	# (after doing the %prep, %build, and %install stages).
	sudo rpmbuild -v -bb rpm/ooo2dbk.spec
	# Lauching rpmbuild with a fakeroot
	#fakeroot rpmbuild -v -bb rpm/ooo2dbk.spec
