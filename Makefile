FILE = src/calculator.asm
OBJ = BIN/calculator.o
TARGET = BIN/calculator
FLAGS = -g -o
CC = as
LINKER = ld
FLAGS_LINKER = -o


all:	$(TARGET)

$(OBJ):		$(FILE)
	@$(CC) $(FLAGS) $(OBJ) $(FILE)

$(TARGET):	$(OBJ)
	@$(LINKER) $(FLAGS_LINKER) $(TARGET) $(OBJ)

clean:
	@rm -rf $(OBJ) $(TARGET)
