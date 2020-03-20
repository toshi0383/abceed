DEVICE=iPhone 11
DESTINATION=-destination "name=$(DEVICE)"
TEST=xcodebuild -project Abceed.xcodeproj $(DESTINATION) test

.PHONY: test-core
test-core:
	$(TEST) -scheme AbceedCoreTests

.PHONY: test-logic
test-logic:
	$(TEST) -scheme AbceedLogicTests

.PHONY: test-all
test-all: test-core test-logic
