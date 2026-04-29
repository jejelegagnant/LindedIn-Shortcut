#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    setbuf(stdout, NULL);
    char *fifo_path = "/var/snap/quick-linkedin/common/trigger.fifo";
    
    printf("User Agent active. Waiting for hardware daemon triggers via FIFO...\n");

    while (1) {
        // This blocks until the root daemon opens the pipe to write
        int fd = open(fifo_path, O_RDONLY);
        if (fd < 0) {
            perror("Failed to open FIFO. Did you run setup?");
            sleep(2);
            continue;
        }

        char buf;
        // Read until the pipe is closed by the daemon
        while (read(fd, &buf, 1) > 0) {
            if (buf == '1') {
                // Keep only the launch command for the final version[cite: 1]
                system("xdg-open \"https://www.linkedin.com\" &");
            }
        }
        close(fd);
    }
    return 0;
}
