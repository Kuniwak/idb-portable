SHELL = /bin/sh

WORKSPACE = tmp
IDB = idb
IDB_COMPANION_BUILD = $(WORKSPACE)/idb_companion
DIST = dist
DIST_BIN = $(DIST)/bin
DIST_SHARED = $(DIST)/shared
DIST_LIB = $(DIST)/lib
DIST_FRAMEWORKS = $(DIST)/Frameworks
TOOLS = tools
DYLIB_TABLE = $(TOOLS)/dylib_conversion_table.txt
ARCHIVES = archives
ARCHIVE = $(ARCHIVES)/idb-portable.tar.gz

HOMEBREW_PREFIX = $(shell brew --prefix)


all: $(DIST_BIN)/idb_companion


.PHONY: clean test archive hint


clean:
	rm -rf "$(WORKSPACE)" "$(DIST)" "$(ARCHIVES)"


test:
	./test


archive: all
	mkdir -p "$(ARCHIVES)"
	tar -C "$(DIST)" -czf "$(ARCHIVE)" .


$(DIST_BIN)/idb_companion: \
		$(IDB_COMPANION_BUILD)/bin/idb_companion \
		$(DIST_SHARED)/idb_companion/LICENSE \
		$(DIST_LIB)/libgrpc.dylib \
		$(DIST_LIB)/libgrpc++.dylib \
		$(DIST_LIB)/libprotobuf.18.dylib \
		$(DIST_LIB)/libcares.2.dylib \
		$(DIST_LIB)/libssl.1.0.0.dylib \
		$(DIST_LIB)/libcrypto.1.0.0.dylib \
		$(DIST_FRAMEWORKS)/FBControlCore.framework \
		$(DIST_FRAMEWORKS)/FBDeviceControl.framework \
		$(DIST_FRAMEWORKS)/FBSimulatorControl.framework \
		$(DIST_FRAMEWORKS)/XCTestBootstrap.framework
	mkdir -p "$(DIST_BIN)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"
	codesign --force --sign "$$($(TOOLS)/find-codesigning-identity)" --timestamp=none "$@"


$(DIST_LIB)/libgrpc.dylib: $(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc.dylib \
		$(DIST_SHARED)/grpc/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_LIB)/libgrpc++.dylib: $(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc++.dylib \
		$(DIST_SHARED)/grpc/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_LIB)/libprotobuf.18.dylib: $(HOMEBREW_PREFIX)/opt/protobuf/lib/libprotobuf.18.dylib \
		$(DIST_SHARED)/protobuf/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_LIB)/libcares.2.dylib: $(HOMEBREW_PREFIX)/opt/c-ares/lib/libcares.2.dylib \
		$(DIST_SHARED)/c-ares/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_LIB)/libssl.1.0.0.dylib: $(HOMEBREW_PREFIX)/opt/openssl/lib/libssl.1.0.0.dylib \
		$(DIST_SHARED)/openssl/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_LIB)/libcrypto.1.0.0.dylib: $(HOMEBREW_PREFIX)/opt/openssl/lib/libcrypto.1.0.0.dylib \
		$(DIST_SHARED)/openssl/LICENSE
	mkdir -p "$(DIST_LIB)"
	cp -f "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


$(DIST_FRAMEWORKS)/FBControlCore.framework: $(IDB_COMPANION_BUILD)/Frameworks/FBControlCore.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -af "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBControlCore" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done
	for dylib in $$(find "$@" -name '*.dylib'); do codesign --force --sign - --timestamp=none "$$dylib"; done
	codesign --force --sign - --timestamp=none --deep "$@"


$(DIST_FRAMEWORKS)/FBDeviceControl.framework: $(IDB_COMPANION_BUILD)/Frameworks/FBDeviceControl.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -af "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBDeviceControl" "$(DYLIB_TABLE)"
	codesign --force --sign - --timestamp=none "$@/Versions/A/FBDeviceControl"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done
	for dylib in $$(find "$@" -name '*.dylib'); do codesign --force --sign - --timestamp=none "$$dylib"; done
	codesign --force --sign - --timestamp=none --deep "$@"


$(DIST_FRAMEWORKS)/FBSimulatorControl.framework: $(IDB_COMPANION_BUILD)/Frameworks/FBSimulatorControl.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -af "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBSimulatorControl" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done
	for dylib in $$(find "$@" -name '*.dylib'); do codesign --force --sign - --timestamp=none "$$dylib"; done
	codesign --force --sign - --timestamp=none --deep "$@"


$(DIST_FRAMEWORKS)/XCTestBootstrap.framework: $(IDB_COMPANION_BUILD)/Frameworks/XCTestBootstrap.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -af "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/XCTestBootstrap" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done
	for dylib in $$(find "$@" -name '*.dylib'); do codesign --force --sign - --timestamp=none "$$dylib"; done
	codesign --force --sign - --timestamp=none --deep "$@"


$(DIST_SHARED)/idb_companion/LICENSE:
	mkdir -p "$(DIST_SHARED)/idb_companion"
	cp -f "$(IDB)/LICENSE" "$@"


$(DIST_SHARED)/grpc/LICENSE: $(HOMEBREW_PREFIX)/opt/grpc/LICENSE
	mkdir -p "$(DIST_SHARED)/grpc"
	cp -f "$<" "$@"


$(DIST_SHARED)/protobuf/LICENSE: $(HOMEBREW_PREFIX)/opt/protobuf/LICENSE
	mkdir -p "$(DIST_SHARED)/protobuf"
	cp -f "$<" "$@"


$(DIST_SHARED)/c-ares/LICENSE: $(HOMEBREW_PREFIX)/opt/c-ares/LICENSE.md
	mkdir -p "$(DIST_SHARED)/c-ares"
	cp -f "$<" "$@"


$(DIST_SHARED)/openssl/LICENSE: $(HOMEBREW_PREFIX)/opt/openssl/LICENSE
	mkdir -p "$(DIST_SHARED)/openssl"
	cp -f "$<" "$@"


$(IDB_COMPANION_BUILD)/bin/idb_companion: $(IDB_COMPANION_BUILD)
$(IDB_COMPANION_BUILD)/Frameworks/FBControlCore.framework: $(IDB_COMPANION_BUILD)
$(IDB_COMPANION_BUILD)/Frameworks/FBDeviceControl.framework: $(IDB_COMPANION_BUILD)
$(IDB_COMPANION_BUILD)/Frameworks/FBSimulatorControl.framework: $(IDB_COMPANION_BUILD)
$(IDB_COMPANION_BUILD)/Frameworks/XCTestBootstrap.framework: $(IDB_COMPANION_BUILD)


$(IDB_COMPANION_BUILD):
	mkdir -p "$(WORKSPACE)"
	$(TOOLS)/build-idb-companion "$(WORKSPACE)" "$(IDB_COMPANION_BUILD)"


$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc.dylib $(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc++.dylib:
	brew install grpc


$(HOMEBREW_PREFIX)/opt/c-ares/lib/libcares.2.dylib:
	brew install c-ares


$(HOMEBREW_PREFIX)/opt/protobuf/lib/libprotobuf.18.dylib:
	brew install protobuf


$(HOMEBREW_PREFIX)/opt/openssl/lib/libssl.1.0.0.dylib $(HOMEBREW_PREFIX)/opt/openssl/lib/libcrypto.1.0.0.dylib:
	brew install openssl


hint: hint-bin hint-frameworks hint-dylibs


hint-bin: $(IDB_COMPANION_BUILD)/bin/idb_companion
	otool -L $? | grep compatibility | grep '\(@rpath\|@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq


hint-frameworks: \
		$(IDB_COMPANION_BUILD)/Frameworks/FBControlCore.framework \
		$(IDB_COMPANION_BUILD)/Frameworks/FBDeviceControl.framework \
		$(IDB_COMPANION_BUILD)/Frameworks/FBSimulatorControl.framework \
		$(IDB_COMPANION_BUILD)/Frameworks/XCTestBootstrap.framework
	$(TOOLS)/show-dependencies-from-frameworks $? | grep compatibility | grep '\(@rpath\|@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq


hint-dylibs: \
		$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc.dylib \
		$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc++.dylib \
		$(HOMEBREW_PREFIX)/opt/protobuf/lib/libprotobuf.18.dylib \
		$(HOMEBREW_PREFIX)/opt/c-ares/lib/libcares.2.dylib \
		$(HOMEBREW_PREFIX)/opt/openssl/lib/libssl.1.0.0.dylib \
		$(HOMEBREW_PREFIX)/opt/openssl/lib/libcrypto.1.0.0.dylib
	otool -L $? | grep compatibility | grep '\(@rpath\|@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq
