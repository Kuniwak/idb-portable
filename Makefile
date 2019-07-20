SHELL = /bin/sh

WORKSPACE = tmp
IDB_COMPANION_BOTTLE_ARCHIVE = $(WORKSPACE)/idb-companion-bottle.tar.gz
IDB_COMPANION_BOTTLE = $(WORKSPACE)/idb-companion-bottle
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


$(DIST_BIN)/idb_companion: $(IDB_COMPANION_BOTTLE) \
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
	cp -f "$(IDB_COMPANION_BOTTLE)/bin/idb_companion" "$@"
	$(TOOLS)/change-dylib-loc "$@" "$(DYLIB_TABLE)"


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


$(DIST_FRAMEWORKS)/FBControlCore.framework: $(IDB_COMPANION_BOTTLE)/Frameworks/FBControlCore.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -rf "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBControlCore" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done


$(DIST_FRAMEWORKS)/FBDeviceControl.framework: $(IDB_COMPANION_BOTTLE)/Frameworks/FBDeviceControl.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -rf "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBDeviceControl" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done


$(DIST_FRAMEWORKS)/FBSimulatorControl.framework: $(IDB_COMPANION_BOTTLE)/Frameworks/FBSimulatorControl.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -rf "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/FBSimulatorControl" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done


$(DIST_FRAMEWORKS)/XCTestBootstrap.framework: $(IDB_COMPANION_BOTTLE)/Frameworks/XCTestBootstrap.framework \
		$(DIST_SHARED)/idb_companion/LICENSE
	mkdir -p "$(DIST_FRAMEWORKS)"
	cp -rf "$<" "$@"
	$(TOOLS)/change-dylib-loc "$@/Versions/A/XCTestBootstrap" "$(DYLIB_TABLE)"
	for dylib in $$(find "$@" -name '*.dylib'); do $(TOOLS)/change-dylib-loc "$$dylib" "$(DYLIB_TABLE)"; done
	

$(DIST_SHARED)/idb_companion/LICENSE: $(IDB_COMPANION_BOTTLE)
	mkdir -p "$(DIST_SHARED)/idb_companion"
	cp -f "$(IDB_COMPANION_BOTTLE)/LICENSE" "$@"


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


$(IDB_COMPANION_BOTTLE): $(IDB_COMPANION_BOTTLE_ARCHIVE)
	mkdir -p "$@"
	tar xzf "$(IDB_COMPANION_BOTTLE_ARCHIVE)" --strip 2 -C "$@"


$(IDB_COMPANION_BOTTLE_ARCHIVE):
	mkdir -p "$(WORKSPACE)"
	curl --disable --location --fail 'https://github.com/facebook/idb/releases/download/v1.0.7/idb-companion-1.0.7.mojave.bottle.tar.gz' --output "$@"


$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc.dylib $(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc++.dylib:
	brew install grpc


$(HOMEBREW_PREFIX)/opt/c-ares/lib/libcares.2.dylib:
	brew install c-ares


$(HOMEBREW_PREFIX)/opt/protobuf/lib/libprotobuf.18.dylib:
	brew install protobuf


$(HOMEBREW_PREFIX)/opt/openssl/lib/libssl.1.0.0.dylib $(HOMEBREW_PREFIX)/opt/openssl/lib/libcrypto.1.0.0.dylib:
	brew install openssl


.PHONY: clean hint test


test:
	./test


clean:
	rm -rf "$(WORKSPACE)" "$(DIST)" "$(ARCHIVES)"


archive: all
	mkdir -p "$(ARCHIVES)"
	tar -C "$(DIST)" -czf "$(ARCHIVE)" .


hint: hint-bin hint-frameworks hint-dylibs


hint-bin: $(IDB_COMPANION_BOTTLE)/bin/idb_companion
	otool -L $? | grep compatibility | grep '\(@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq


hint-frameworks: \
		$(IDB_COMPANION_BOTTLE)/Frameworks/FBControlCore.framework \
		$(IDB_COMPANION_BOTTLE)/Frameworks/FBDeviceControl.framework \
		$(IDB_COMPANION_BOTTLE)/Frameworks/FBSimulatorControl.framework \
		$(IDB_COMPANION_BOTTLE)/Frameworks/XCTestBootstrap.framework
	$(TOOLS)/show-dependencies-from-frameworks $? | grep compatibility | grep '\(@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq


hint-dylibs: \
		$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc.dylib \
		$(HOMEBREW_PREFIX)/opt/grpc/lib/libgrpc++.dylib \
		$(HOMEBREW_PREFIX)/opt/protobuf/lib/libprotobuf.18.dylib \
		$(HOMEBREW_PREFIX)/opt/c-ares/lib/libcares.2.dylib \
		$(HOMEBREW_PREFIX)/opt/openssl/lib/libssl.1.0.0.dylib \
		$(HOMEBREW_PREFIX)/opt/openssl/lib/libcrypto.1.0.0.dylib
	otool -L $? | grep compatibility | grep '\(@@HOMEBREW_PREFIX@@\|$(HOMEBREW_PREFIX)\)' | sort | uniq
