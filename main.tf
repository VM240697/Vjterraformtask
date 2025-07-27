resource "null_resource" "create_files" {
  provisioner "local-exec" {
    command = "touch file1.txt file2.txt"
  }
}

resource "null_resource" "create_directories" {
  provisioner "local-exec" {
    command = "mkdir dir1 dir2"
  }
}

