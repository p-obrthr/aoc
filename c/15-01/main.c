#include <stdio.h>
#include <stdlib.h>

char *read_file(const char *file_name) {
  FILE *file = fopen(file_name, "r");
  if (file == NULL) {
    perror("Error opening file");
    return NULL;
  }

  int ch;
  int size = 4095;
  char *buffer = (char *)malloc(sizeof(char) * size);
  if (buffer == NULL) {
    fclose(file);
    perror("Error allocating memory");
    return NULL;
  }

  int len = 0;
  do {
    if (len == size) {
      size *= 2;
      char *bufferTmp = realloc(buffer, size);
      if (bufferTmp == NULL) {
        free(buffer);
        fclose(file);
        perror("Error allocating memory");
        return NULL;
      }
      buffer = bufferTmp;
    }
    ch = getc(file);
    buffer[len] = ch;
    len++;
  } while (ch != '\n' && ch != '\0' && ch != EOF);

  buffer[len] = '\0';
  fclose(file);
  return buffer;
}

int partOne(const char *input) {
  int floor = 0;
  size_t i = 0;

  while (input[i] != '\0') {
    if (input[i] == '(') {
      floor++;
    } else if (input[i] == ')') {
      floor--;
    }
    i++;
  }

  return floor;
}

int partTwo(const char *input) {
  int floor = 0;
  size_t i = 0;

  while (input[i] != '\0') {
    if (input[i] == '(') {
      floor++;
    } else if (input[i] == ')') {
      floor--;
    }
    if (floor == -1) {
      return i + 1;
    }
    i++;
  }

  return -1;
}

int main() {
  char *input = read_file("input.txt");
  if (input == NULL) {
    return 1;
  }

  printf("partOne: %d\n", partOne(input));
  printf("partTwo: %d\n", partTwo(input));

  free(input);
  return 0;
}
