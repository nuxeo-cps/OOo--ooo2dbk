#
# builds OOo addon
#
# only a matter of zip
#(.xcu file must be at the root of the zip file)
#
# retrieve parameters from conf file
include addonconf.Makefile
#
.PHONY: makeaddon
makeaddon:
	@(cd ${addonDirectory} ; \
	zip -r addon ./ ; \
	mv ./addon.zip ../${targetName} ; \
	)

clean:
	rm -f ${targetName}

