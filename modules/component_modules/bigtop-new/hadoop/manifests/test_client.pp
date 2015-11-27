class hadoop::test_client(
  $test_user
)
{
  $test_file_content = 'teststring'
  $test_filename = "${test_user}-test.txt"
  $test_file_path = "/tmp/${test_filename}"

  r8::export_variable { "hadoop::test_client::test_file_content": }
  r8::export_variable { "hadoop::test_client::test_file_path": }

  file { $test_file_path:
    content => $test_file_content
  }
}