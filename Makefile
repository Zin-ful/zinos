ASM=nasm

SRC_DIR=src
BUILD_DIR=build
BOOTL=$(BUILD_DIR)/bootloader.bin
KERN=$(BUILD_DIR)/kernel.bin
FLOP=$(BUILD_DIR)/main_floppy.img

.PHONY: all floppy kernel boot clean always

#floppy


floppy: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: boot kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "ZOS" $(BUILD_DIR)/main_floppy.img
	dd if=$(BOOTL) of=$(FLOP) conv=notrunc
	mcopy -i $(FLOP) $(KERN) "::kernel.bin"

#bootloader

boot: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin



#kernel

kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin


#always
always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*
