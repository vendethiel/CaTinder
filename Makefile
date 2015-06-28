NAME = catinder

SWIFT_SRC = $(wildcard *.swift) \
			$(wildcard GG/*.swift)

C_PREFIX = -import-objc-header
C_HEADERS = $(C_PREFIX) FBBridge.h $(C_PREFIX) SWRevealViewController.h

RUNNER = xcrun

SWIFT = swiftc

XCODE_BASE=/Applications/Xcode.app/Contents
SIMULATOR_BASE=$(XCODE_BASE)/Developer/Platforms/iPhoneSimulator.platform
SDK_BASE=$(SIMULATOR_BASE)/Developer/SDKs/iPhoneSimulator$(IOS_VERSION).sdk

SWIFTFLAGS = -F /System/Library/Frameworks -I/usr/include

$(NAME):
	$(RUNNER) $(SWIFT) $(SWIFTFLAGS) -c $(SWIFT_SRC) $(C_HEADERS) -o $(NAME)
