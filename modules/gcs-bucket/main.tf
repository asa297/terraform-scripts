# modules/gcs-bucket/main.tf

resource "google_storage_bucket" "bucket" {
  project                     = var.project_id
  name                        = var.name
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = true # Best practice: ทำให้การจัดการสิทธิ์ง่ายขึ้น

  versioning {
    enabled = var.versioning_enabled
  }

  public_access_prevention = "enforced" # Best practice: ป้องกันการตั้งค่าเป็น public โดยไม่ได้ตั้งใจ

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules # วนลูปตาม list ของ rules ที่รับเข้ามา

    content {
      action {
        type = "Delete" # เราจะโฟกัสที่การลบไฟล์
      }
      condition {
        age = lifecycle_rule.value.age_in_days

        # ตรวจสอบว่าใน rule object มี prefix มาด้วยหรือไม่
        # ถ้ามี ให้ใส่เงื่อนไข matches_prefix, ถ้าไม่มี (เป็น null) ให้ข้ามไป (หมายถึง ให้ใช้กับทั้ง bucket)
        matches_prefix = lookup(lifecycle_rule.value, "prefix", null) == null ? null : [lifecycle_rule.value.prefix]
      }
    }
  }

  labels = var.labels
}

# กำหนดสิทธิ์ IAM ให้กับ bucket นี้
# ใช้ for_each เพื่อวนลูปสร้างสิทธิ์ตาม map ที่รับเข้ามา
resource "google_storage_bucket_iam_member" "iam" {
  for_each = { for pair in flatten([for role, members in var.iam_members : [for member in members : { role = role, member = member }]]) : "${pair.role}-${pair.member}" => pair }

  bucket = google_storage_bucket.bucket.name
  role   = each.value.role
  member = each.value.member
}
