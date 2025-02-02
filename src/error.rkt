#lang racket/base

(define new-issue-url "https://github.com/racket-templates/raco-new/issues/new")

(define user-abort-error
  "\n\nProject creation aborted by user.")

(define too-many-arguments-error
  (string-append
   "Too many arguments supplied.\n"
   "Command should be in form `raco new <template-name> [dir-name]`"
  ))

(define unexpected-error
  (string-append
   "\n\nHmm, an unexpected error has occured...\n"
   "If you'd like, we'd really appreciate it if you filed a bug report at\n"
   new-issue-url
   "\n\nSorry for the inconvenience, please try again and change up your options if the problem persists."
  ))

(define git-not-found-error
  (string-append
   "Templates are cloned from GitHub via git.\n"
   "Please make sure you have git installed and visible on your PATH"))

(define template-not-found-error
  (string-append
   "The template you're trying to clone could not be found.\n"
   "To find a list of all available templates you can run:"
   "$ raco new --list"))

(define repo-not-found-error
  (string-append
   "The template you're trying to clone has been registered, but it's git repository could not be found.\n"
   "Please file a bug report at " new-issue-url))

(define [print-error error msg show-stack?]
  (when show-stack?
    (displayln error))
  (displayln msg))

(provide
  print-error
  user-abort-error
  too-many-arguments-error
  unexpected-error
  git-not-found-error
  template-not-found-error
  repo-not-found-error)