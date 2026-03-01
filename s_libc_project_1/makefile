# ============================================
# Makefile - Super libc (s_libc)
# ============================================

CC = gcc
CFLAGS = -m32
LDFLAGS = -m32 -shared

# Répertoires
SRC_DIR = src
INC_DIR = include
BUILD_DIR = build
LIB_DIR = lib
TEST_DIR = test

# Fichiers sources assembleur
ASM_SRC = $(wildcard $(SRC_DIR)/*.s)
# Fichiers objets correspondants
ASM_OBJ = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(ASM_SRC))

# Nom de la bibliothèque
LIB_NAME = libs_libc.so
LIB_PATH = $(LIB_DIR)/$(LIB_NAME)

# Exécutable de test
TEST_EXEC = test_s_libc

# ============================================
# Règles
# ============================================

all: $(LIB_PATH)

$(LIB_PATH): $(ASM_OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	$(CC) $(CFLAGS) -c $< -o $@

test: all
	$(CC) $(CFLAGS) -o $(TEST_EXEC) $(TEST_DIR)/main.c -I$(INC_DIR) -L$(LIB_DIR) -ls_libc
	@echo ""
	@echo "Pour exécuter : LD_LIBRARY_PATH=$(LIB_DIR) ./$(TEST_EXEC)"
	@echo ""

clean:
	rm -f $(BUILD_DIR)/*.o
	rm -f $(TEST_EXEC)

.PHONY: all test clean