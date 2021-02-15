kernel: products/kernel.bin

# --- Boot ------------------------------------------------------------------ #

boot/aarch32/vm_init.o: boot/aarch32/vm_init.c
	@mkdir -p products
	@echo "$(notdir $(CURDIR)): S3_ENTRY_C   $@"
	${QUIET} ${CC} -c $< -o $@ ${C_FLAGS}

boot/aarch32/_start.o: boot/aarch32/_start.s
	@mkdir -p products
	@echo "$(notdir $(CURDIR)): S3_ENTRY_ASM $@"
	${QUIET} ${ASM} $< -o $@ ${ASM_KERNEL_FLAGS}

# --- Kernel ---------------------------------------------------------------- #

KERNEL_PATH = kernel/kernel

KERNEL_C_SRC = $(shell find kernel/kernel -name "*.c" -not -path "kernel/kernel/platform/x86/*" -not -path "kernel/kernel/drivers/x86/*")
KERNEL_S_SRC = $(shell find kernel/kernel -name "*.s" -not -path "kernel/kernel/platform/x86/*" -not -path "kernel/kernel/drivers/x86/*")

KERNEL_HEADERS = $(shell find include -name "*.h")
KERNEL_C_OBJ = ${KERNEL_C_SRC:.c=.o}
KERNEL_S_OBJ = ${KERNEL_S_SRC:.s=.o}

C_FLAGS = ${C_COMPILE_FLAGS} ${C_DEBUG_FLAGS} ${C_WARNING_FLAGS} ${C_INCLUDES}

products/kernel.bin: boot/aarch32/_start.o boot/aarch32/vm_init.o ${KERNEL_C_OBJ} ${KERNEL_S_OBJ}
	echo ${KERNEL_C_SRC}
	@mkdir -p products
	@echo "$(notdir $(CURDIR)): LD $@"
	${QUIET} ${LD} -o $@ $^ ${LD_KERNEL_FLAGS}

${KERNEL_PATH}/%.o: ${KERNEL_PATH}/%.c ${KERNEL_HEADERS}
	@echo "$(notdir $(CURDIR)): CC $@"
	${QUIET} ${CC} -c $< -o $@ ${C_FLAGS}

${KERNEL_PATH}/%.o: ${KERNEL_PATH}/%.s
	@echo "$(notdir $(CURDIR)): ASM $@"
	${QUIET} ${ASM} $< -o $@ ${ASM_KERNEL_FLAGS}