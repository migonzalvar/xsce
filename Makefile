# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

SCRIPTS = symlink-tree.py unlink-tree.py
OLPCROOT = fsroot.olpc

install: $(OLPCROOT) $(DESTDIR)
	rsync -ar $(OLPCROOT) $(DESTDIR)

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# olpc configuration tree
OLPCIMG = fsroot.olpc.img

# symbols
PKGNAME = xs-config
VERSION = $(shell git describe | sed 's/^v//' | sed 's/-/./g')
RELEASE = 1
ARCH = noarch

NV = $(PKGNAME)-$(VERSION)

RPMBUILD = rpmbuild \
	--define "_topdir $(BUILDDIR)" \

SOURCES: Makefile $(SCRIPTS)
	mkdir -p $(BUILDDIR)/BUILD $(BUILDDIR)/RPMS \
	$(BUILDDIR)/SOURCES $(BUILDDIR)/SPECS $(BUILDDIR)/SRPMS
	mkdir -p $(NV)
	cp -p Makefile $(NV)
	rsync -ar $(OLPCIMG)/ $(NV)/$(OLPCROOT)
	cp -p $(SCRIPTS) $(NV)/$(OLPCROOT)
	tar czf $(BUILDDIR)/SOURCES/$(NV).tar.gz $(NV)
	rm -rf $(NV)

xs-config.spec: xs-config.spec.in
	sed -e 's:@VERSION@:$(VERSION):g' < $< > $@

.PHONY: xs-config.spec.in
	# This forces a rebuild of xs-config.spec.in

rpm: SOURCES xs-config.spec
	$(RPMBUILD) -ba --target $(ARCH) $(PKGNAME).spec
	rm -fr $(BUILDDIR)/BUILD/$(NV)
	rpmlint $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(ARCH).rpm
