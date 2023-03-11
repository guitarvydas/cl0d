Loads the files required by this project without using ASDF or Lispworks system definition file.

Lisp needs a full pathname to load a source file, so we use the variable `root` to define the project directory and we define a sub-function `ld` that loads a file from that project directory.

Order is important, the basics need to be loaded before leaf and container.  Test code needs to be loaded last.

There are 3 main test files - sequential, parallel and echopipeline. `Test.lisp` is used to compose variations of the tests.

```
(declaim (optimize (debug 3) (safety 3) (speed 0)))

(let ((root "/Users/tarvydas/quicklisp/local-projects/cl0d/"))
  (labels ((ld (fname)
             (load (format nil "~a~a" root fname))))
	  ;; basics
	  (ld "const.lisp")
	  (ld "lookup.lisp")
	  (ld "fifo.lisp")
	  (ld "message.lisp")
	  (ld "schedulable.lisp")
	  (ld "eh.lisp")
	  ;; leaf
	  (ld "leaf.lisp")
	  ;; connections
	  (ld "connection.lisp")
	  ;; container
	  (ld "container.lisp")
          ;; test
	  (ld "echo.lisp")
          (ld "sequential.lisp")
          (ld "parallel.lisp")
          (ld "echopipeline.lisp")
          (ld "test.lisp")
))
```
