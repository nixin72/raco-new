#lang racket/base

(require racket/system
         racket/file
         racket/port
         racket/list
         racket/string
         racket/set
         "error.rkt"
         "list.rkt")

;; Run the actual git clone to download the reposity.
(define [clone-repo name dir]
  (printf "Cloning ~s template to ~a...\n" name dir)

  (define templates (list-templates))
  (when (not (hash-has-key? templates name))
    (print-error null template-not-found-error #f)
    (exit 1)) ;; EXIT ON ERROR

  (define template (hash-ref templates name))
  (define url (format "https://~a.com/~a"
                      (template-from template)
                      (template-repo template)))

  (printf "Repository for template found at ~a\n" url)

  (define command (format "git clone ~a ~a" url dir))
  (define result
    (call-with-output-string
      (lambda (p)
        (parameterize ([current-output-port p]
                       [current-error-port p])
          (system command)))))

  ;; Delete the existing .git directory to get rid of that history
  (delete-directory/files (build-path (current-directory) dir ".git"))

  (define ret
    (cond
      [(string-contains? result "command not found") (print-error null git-not-found-error #f)]
      [(string-contains? result "Repository not found") (print-error null repo-not-found-error #f)]
      [#true
       (displayln "Template cloned successfully!")
       #t]))
  ret)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Update info.rkt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOTE: None of this is used at the moment.
;; An option should be able to be provided to `raco new` that will allow modification of the
;; cloned template.

(define output-dir (make-parameter null))
(define version-num (make-parameter "1.1.0"))
(define description (make-parameter ""))
(define entry-point (make-parameter "main.rkt"))
(define git-repo (make-parameter ""))
(define git-init? (make-parameter #f))
(define author (make-parameter ""))
(define license (make-parameter "MIT"))

(define [existing-options-in-info-rkt output-dir]
  (define file-path (build-path (current-directory) (output-dir) "info.rkt"))
  (if (file-exists? file-path)
      (call-with-input-string
       (string-append "(" (string-replace (file->string file-path) "#lang info" "") ")")
       (lambda (in) (read in)))
      '()))

(define [first-where predicate lst]
  (car (filter predicate lst)))

(define [write-to-info-file info-rkt-new output-dir]
  (define file-path (string-append (output-dir) "/info.rkt"))
  (define info-rkt-old (existing-options-in-info-rkt))
  (define options-old (map (lambda (x) (second x)) info-rkt-old))
  (define options-new (map (lambda (x) (second x)) info-rkt-new))

  (display-to-file "#lang info.rkt\n\n"
                   file-path
                   #:exists 'replace)
  (for ([opt (list->set (append options-new options-old))])
    (let ([i1 (index-of options-old opt)]
          [i2 (index-of options-new opt)])
      (with-output-to-file file-path #:exists 'append
        (lambda ()
          (define line (if i2
                           (list-ref info-rkt-new i2)
                           (list-ref info-rkt-old i1)))
          (displayln (list 'define (second line) (string-replace (format "~v" (third line)) "''" "'"))))))))

(provide clone-repo)