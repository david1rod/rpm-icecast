HOME=$(shell pwd)
NAME=icecast
VERSION=2.4.0
SUFIX=kh3+git+e78da33b
RELEASE=$(shell /opt/buildhelper/buildhelper getgitrev .)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)
SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME})
# Release URL
#URL=https://github.com/karlheyes/icecast-kh/archive/${NAME}-${VERSION}-${SUFIX}.tar.gz
# Git URL
URL=https://api.github.com/repos/karlheyes/icecast-kh/tarball/e78da33b004917a17210a74e33f5c768880c7cb7
ARCHIVE=SOURCES/${NAME}-${VERSION}${SUFIX}.tar.gz

all: build

clean:
	rm -rf ./rpmbuild
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/

$(ARCHIVE):
	curl -L -s -o "${ARCHIVE}" "${URL}"

build: $(ARCHIVE) clean
	cp -r ./SPECS/* ./rpmbuild/SPECS/
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/
	rpmbuild -ba ${SPEC} \
	--define "ver ${VERSION}" \
	--define "sufix ${SUFIX}" \
	--define "rel ${RELEASE}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos
