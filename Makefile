INSTALL_DIR ?= $(HOME)/.local/bin
SCRIPT := convert-all.sh
TARGET := $(INSTALL_DIR)/convert-all

.PHONY: all install uninstall

all: install

install:
	@mkdir -p $(INSTALL_DIR)
	install -m 755 $(SCRIPT) $(TARGET)
	@echo "Installed $(TARGET)"

uninstall:
	@rm -f $(TARGET)
	@echo "Uninstalled $(TARGET)"
