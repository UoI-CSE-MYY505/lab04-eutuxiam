
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
 str_ge:
    # Βρόχος σύγκρισης χαρακτήρα-προς-χαρακτήρα
compare_loop:
    lbu t0, 0(a0)           # Φόρτωσε τον τρέχοντα χαρακτήρα από το πρώτο string στον t0
    lbu t1, 0(a1)           # Φόρτωσε τον τρέχοντα χαρακτήρα από το δεύτερο string στον t1

    beq t0, zero, end_check  # Αν φτάσαμε στο τέλος του πρώτου string, πήγαινε στο τέλος ελέγχου
    beq t1, zero, return_one # Αν το δεύτερο string έχει τελειώσει αλλά όχι το πρώτο, επιστρέφουμε 1

    blt t0, t1, return_zero # Αν ο χαρακτήρας του πρώτου είναι μικρότερος από τον δεύτερο, επιστρέφουμε 0
    bgt t0, t1, return_one  # Αν ο χαρακτήρας του πρώτου είναι μεγαλύτερος, επιστρέφουμε 1

    # Αν οι χαρακτήρες είναι ίδιοι, προχωράμε στον επόμενο χαρακτήρα
    addi a0, a0, 1          # Προχώρησε στον επόμενο χαρακτήρα της πρώτης συμβολοσειράς
    addi a1, a1, 1          # Προχώρησε στον επόμενο χαρακτήρα της δεύτερης συμβολοσειράς
    j compare_loop          # Επανέλαβε τον βρόχο σύγκρισης

end_check:
    beq t1, zero, return_one # Αν και το δεύτερο string έφτασε στο τέλος, τα strings είναι όμοια ή ίσα, επιστρέφουμε 1
    j return_zero            # Αλλιώς, το πρώτο string είναι μικρότερο (επιστροφή 0)

return_one:
    li a0, 1                # Επιστρέφει 1
    jr ra                   # Επιστροφή στην κλήση

return_zero:
    li a0, 0                # Επιστρέφει 0
    jr ra                   # Επιστροφή στην κλήση

       
            jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            slti t0, a1,   2
            beq  t0, zero, checkFirstTwo
            addi a0, zero, 1  # return 1
            jr   ra
checkFirstTwo:
            addi sp, sp,   -12
            sw   ra, 8(sp)
            sw   a0, 4(sp)
            sw   a1, 0(sp)
            lw   a1, 0(a0)  # 1st
            lw   a0, 4(a0)  # 2nd 
            jal  str_ge
            beq  a0, zero, return  # return 0, a0 is already 0
            # do recursion
            lw   a0, 4(sp)    # get original a0, a1 from stack
            lw   a1, 0(sp)
            addi a0, a0,   4   # check the rest of the array, after 1st element.
            addi a1, a1,   -1  # size-1
            jal  recCheck
return:
            lw   ra, 8(sp)
            addi sp, sp,   12
            jr   ra
