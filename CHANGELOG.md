
* v0.3.0
    * Fog storage support
    * Unlock aspect ratio
    * Fix : Critical security fix regarding input sanitizing
    * Fix : Image geometries weren't scoped with the attachment name 
    * Fix : Processor was always added in the last place
    * Better testing
* v0.2.0
    * Mongoid support
* v0.1.1
    * Fix : issue with Paperclip 3.5 (attachment_definitions failure)
* v0.1.0
    * Upgraded dependencies : Paperclip >= 3.4
    * Using assign instead of reprocess! to avoid loops with Paperclip on callbacks 
    * Including this file!
    * Now compatible with jQuery 1.9.0
    * Jcrop upgraded to v0.9.10 (build:20130117)
    * Added support for attachments on S3
* v0.0.7
    * Ajax support
* v0.0.5
    * Initial commit