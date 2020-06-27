# Contributed code

This is the home of various potentially useful user contributed extensions for
Zepl.  Nothing here is enabled by default; individual extensions can be enabled
as desired.  Documentation for each extension can be accessed from the `:help
zepl-contrib.txt` help doc.

If you have created some useful extensions for Zepl and think that others might
also find them useful, please create a pull request.

_No guarantees are made as to the stability of these extensions._


## Rationale

My goal is to keep the Zepl core as minimal and bug-free as possible, this means
that it cannot include language-specific code or many potentially useful
features.  To resolve this issue I designed Zepl with extensibility in mind, and
created this contrib system.

The extensibility of Zepl makes it possible to add many desired features and add
support for any language, even those with unusual syntax (e.g. Python: `:help
zepl-python`).  The contrib system makes it possible to ship these with Zepl.
