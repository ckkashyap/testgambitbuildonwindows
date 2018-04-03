(define gambit-source-dir "gambit")

(shell-command (string-append "rd /s /q " gambit-source-dir))

(shell-command (string-append "git clone https://github.com/gambit/gambit.git " gambit-source-dir))

(current-directory gambit-source-dir)

(define (build bindir)
  (shell-command (string-append "cscript misc\\configure-vstudio.js --prefix=" bindir))
  (shell-command "nmake")
  (shell-command "nmake install"))

(define (bin-dir bit)
  (string-append (number->string bit) "bit"))

(shell-command "copy /y ..\\configure-vstudio-32.js misc\\configure-vstudio.js")
(build (bin-dir 32))


(define (clean-up-out)
  (newline)
  (shell-command "echo > out.txt"))

(clean-up-out)
(display (string-append (bin-dir 32) "\\bin\\gsi ..\\sample.scm > out.txt"))
(shell-command (string-append (bin-dir 32) "\\bin\\gsi.exe ..\\sample.scm > out.txt"))
(if (string=? "hello world" (call-with-input-file "out.txt" (lambda (p) (read-line p))))
    (display "32 bit interpreter passed"))
(clean-up-out)
(shell-command (string-append (bin-dir 32) "\\bin\\gsc -o sample32.exe -exe ..\\sample.scm"))
(shell-command
"sample32.exe > out.txt")
(if (string=? "hello world" (call-with-input-file "out.txt" (lambda (p) (read-line p))))
    (display "32 compiler bit passed"))
