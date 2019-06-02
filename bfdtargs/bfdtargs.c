/* bfdtargs: dump each target supported by BFD, one per line.
 *
 * This probably exists somewhere as a flag in one of the GNU binutils,
 * but I was too lazy to find it.
 */

#include <stdio.h>
#include <bfd.h>

int main(int argc, char const *argv[]) {
    const char **targs = bfd_target_list();

    for (int i = 0; targs[i]; ++i) {
        puts(targs[i]);
    }

    return 0;
}
