tgw_id                   = "tgw-REPLACE"
inspection_attachment_id = "tgw-attach-INSPECTION"
source_attachments       = { app = "tgw-attach-APP", db = "tgw-attach-DB" }
destinations             = { "10.10.0.0/16" = "tgw-attach-APP", "10.20.0.0/16" = "tgw-attach-DB" }
