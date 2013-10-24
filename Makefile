# 1. Generate a RSA Key :
#     gpg --gen-key
#
# 2. Export the key
#     gpg --armor --export <mail> > <mail>.gpg.key
#
# 3. Sign deb package 
#     dpkg-sig --sign builder package_version_arch.deb
#
# 4. Create the repo
#     mkdir -p /var/www/deb/conf/distributions
#     cat /var/www/deb/conf 
#         Origin: domain.com
#         Label: apt repository
#         Codename: lenny
#         Architectures: amd64 i386 source
#         Components: main
#         Description: My debian package repo
#         SignWith: yes
#         Pull: lenny
#
# 5. Install debs
#     cd /var/www/deb
#     reprepro --ask-passphrase -Vb . includedeb lenny /path/to/package_version_arch.deb
#
# 6. Copy public key
#     cp ~/path/to/<mail>.gpg.key .
#
# 7. Hello World!
#     wget -O - http://domain.com/deb/<mail>.gpg.key | sudo apt-key add -
#     echo "deb http://domain.com/deb lenny main" > /etc/apt/sources.list.d/my_repo.list
#
# 8. Enjoy
#
# -- Remove a package
#
#     reprepro --ask-passphrase -Vb . list leny
#     reprepro --ask-passphrase -Vb . remove lenny sirocco-server
#
DEBS=glassfish-4_4.0-1_all.deb \
		 glassfish-4-javadb_10.9.1.0-1_all.deb \
		 glassfish-4-mq_4.0-1_all.deb 

PACKAGES=glassfish-4_4.0-1_all \
	glassfish-4-javadb_10.9.1.0-1_all \
	glassfish-4-mq_4.0-1_all

all: $(DEBS)

%.deb: %
	cd $<; fakeroot debian/rules binary
	# -- uncomment the following line if you want to sign the package -- #
	# dpkg-sig --sign builder $@

clean:
	for P in $(PACKAGES) ; do \
		cd $$P; fakeroot debian/rules clean; cd .. ; \
	done
	rm -f $(DEBS)
