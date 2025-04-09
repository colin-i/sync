Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 edor (1-x68) focal; urgency=medium
 .
   * fix Error: PC not allowed in register list
Author: bc <bc@bc-desktop>

---
The information above should follow the Patch Tagging Guidelines, please
checkout https://dep.debian.net/deps/dep3/ to learn about the format. Here
are templates for supplementary fields that you might want to add:

Origin: (upstream|backport|vendor|other), (<patch-url>|commit:<commit-id>)
Bug: <upstream-bugtracker-url>
Bug-Debian: https://bugs.debian.org/<bugnumber>
Bug-Ubuntu: https://launchpad.net/bugs/<bugnumber>
Forwarded: (no|not-needed|<patch-forwarded-url>)
Applied-Upstream: <version>, (<commit-url>|commit:<commid-id>)
Reviewed-By: <name and email of someone who approved/reviewed the patch>
Last-Update: 2025-04-09

--- edor-1.orig/s/inc/main/armv7/libunwind.h
+++ edor-1/s/inc/main/armv7/libunwind.h
@@ -60,7 +60,7 @@ extern "C" {
 #endif
 
 //int unw_getcontext(unw_context_t *);
-#define unw_tdep_getcontext(uc) ({ unw_tdep_context_t *unw_ctx = (uc); register unsigned long *r0 __asm__ ("r0"); unsigned long *unw_base = unw_ctx->regs; __asm__ __volatile__ ( "mov r0, #0\n" "stmia %[base], {r0-r15}\n" "nop\n" : [r0] "=r" (r0) : [base] "r" (unw_base) : "memory"); (int)r0; })
+#define unw_tdep_getcontext(uc) ({ unw_tdep_context_t *unw_ctx = (uc); register unsigned long *r0 __asm__ ("r0"); unsigned long *unw_base = unw_ctx->regs; __asm__ __volatile__ ( ".align 2\n" "bx pc\n" "nop\n" ".code 32\n" "mov r0, #0\n" "stmia %[base], {r0-r14}\n" "adr r0, ret%=+1\n" "str r0, [%[base], #60]\n" "orr r0, pc, #1\n" "bx r0\n" ".code 16\n" "mov r0, #0\n" "ret%=:\n" : [r0] "=r" (r0) : [base] "r" (unw_base) : "memory", "cc"); (int)r0; })
 #define unw_getcontext unw_tdep_getcontext
 
 int _Uarm_init_local(unw_cursor_t *, unw_context_t *);
